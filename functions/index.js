require("dotenv").config();

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.GMAIL_EMAIL,
    pass: process.env.GMAIL_PASSWORD,
  },
});

exports.sendVerificationCode = functions.https.onCall(async (data, context) => {
  try {
    const {email, uid} = data;

    if (!email || !uid) {
      throw new functions.https.HttpsError(
          "invalid-argument",
          "Email and UID are required.",
      );
    }

    // Generate 6-digit verification code
    const code = Math.floor(100000 + Math.random() * 900000);

    // Store code and timestamp in Firestore
    await admin.firestore().collection("users").doc(uid).update({
      verificationCode: code,
      codeCreatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // Email options
    const mailOptions = {
      from: process.env.GMAIL_EMAIL,
      to: email,
      subject: "Your Verification Code",
      text: `Your verification code is ${code}. It expires in 10 minutes.`,
    };

    // Send email
    await transporter.sendMail(mailOptions);

    return {success: true};
  } catch (error) {
    console.error("Error sending verification code:", error);
    throw new functions.https.HttpsError(
        "internal",
        "Failed to send verification code.",
    );
  }
});

exports.verifyCode = functions.https.onCall(async (data, context) => {
  try {
    const {uid, code} = data;

    if (!uid || !code) {
      throw new functions.https.HttpsError(
          "invalid-argument",
          "UID and code are required.",
      );
    }

    const userDoc = await admin.firestore().collection("users").doc(uid).get();

    if (!userDoc.exists) {
      throw new functions.https.HttpsError("not-found", "User not found.");
    }

    const userData = userDoc.data();
    const storedCode = userData.verificationCode;
    const codeCreatedAt =
      userData.codeCreatedAt ? userData.codeCreatedAt.toDate() : null;

    if (!storedCode || !codeCreatedAt) {
      throw new functions.https.HttpsError(
          "failed-precondition",
          "No code stored.",
      );
    }

    const now = new Date();
    const diffMinutes = (now - codeCreatedAt) / 1000 / 60;

    if (parseInt(code, 10) === storedCode && diffMinutes <= 10) {
      return {verified: true};
    }

    return {verified: false};
  } catch (error) {
    console.error("Error verifying code:", error);
    throw new functions.https.HttpsError("internal", "Failed to verify code.");
  }
});
