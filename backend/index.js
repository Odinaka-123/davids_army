require("dotenv").config();

const express = require("express");
const cors = require("cors");
const { Resend } = require("resend");
const admin = require("firebase-admin");

// 🔥 FIREBASE INIT
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

// ✅ FIX PRIVATE KEY (CRITICAL)
serviceAccount.private_key = serviceAccount.private_key.replace(/\\n/g, "\n");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const app = express();
app.use(express.json());
app.use(cors());

const resend = new Resend(process.env.RESEND_API_KEY);

// 🔥 TEMP CODE STORAGE
const verificationCodes = {};

// 🔄 Clean expired codes
setInterval(() => {
  const now = Date.now();
  for (const email in verificationCodes) {
    if (verificationCodes[email].expiresAt < now) {
      delete verificationCodes[email];
    }
  }
}, 10 * 60 * 1000);

// 🟢 ROOT
app.get("/", (req, res) => {
  res.send("Backend is running");
});


// ✅ SEND VERIFICATION EMAIL
app.post("/send-verification", async (req, res) => {
  try {
    const email = req.body.email?.trim().toLowerCase();

    if (!email) {
      return res.status(400).json({ error: "Email required" });
    }

    const code = Math.floor(100000 + Math.random() * 900000);

    verificationCodes[email] = {
      code,
      expiresAt: Date.now() + 5 * 60 * 1000,
    };

    console.log("CODE:", code);

    await resend.emails.send({
      from: "David's Army <davidsarmy@kakkatech.com>",
      to: email,
      subject: "Your Verification Code",
      html: `<h1>${code}</h1><p>Expires in 5 minutes</p>`,
    });

    console.log("EMAIL SENT ✅");

    res.json({ success: true });
  } catch (err) {
    console.error("EMAIL ERROR:", err);
    res.status(500).json({ error: "Failed to send email" });
  }
});


// ✅ VERIFY CODE → SAVE TO FIRESTORE
app.post("/verify-code", async (req, res) => {
  try {
    const email = req.body.email?.trim().toLowerCase();
    const code = req.body.code;

    if (!email || !code) {
      return res.status(400).json({ error: "Missing fields" });
    }

    const stored = verificationCodes[email];

    if (!stored) {
      return res.status(400).json({ error: "No code found" });
    }

    if (Date.now() > stored.expiresAt) {
      delete verificationCodes[email];
      return res.status(400).json({ error: "Code expired" });
    }

    if (stored.code == code) {
      delete verificationCodes[email];

      // 🔥 SAVE TO FIRESTORE
      await db.collection("verified_users").doc(email).set({
        email,
        verified: true,
        verifiedAt: new Date(),
      });

      console.log("USER VERIFIED + SAVED:", email);

      return res.json({ success: true });
    }

    return res.status(400).json({ error: "Invalid code" });
  } catch (err) {
    console.error("VERIFY ERROR:", err);
    res.status(500).json({ error: "Verification failed" });
  }
});


// ✅ CHECK VERIFICATION FROM FIRESTORE
app.post("/check-verification", async (req, res) => {
  try {
    const email = req.body.email?.trim().toLowerCase();

    if (!email) {
      return res.status(400).json({ error: "Email required" });
    }

    const doc = await db.collection("verified_users").doc(email).get();

    const isVerified = doc.exists && doc.data().verified === true;

    console.log("CHECK:", email, "→", isVerified);

    res.json({ verified: isVerified });
  } catch (err) {
    console.error("CHECK ERROR:", err);
    res.status(500).json({ error: "Check failed" });
  }
});


// 🚀 START SERVER
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on ${PORT}`));