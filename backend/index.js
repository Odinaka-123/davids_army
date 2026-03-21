require("dotenv").config();
const express = require("express");
const nodemailer = require("nodemailer");

const app = express();
app.use(express.json());

// Nodemailer transporter
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.GMAIL_EMAIL,
    pass: process.env.GMAIL_APP_PASSWORD,
  },
});

// In-memory storage for verification codes
const verificationCodes = {};

// Function to clean expired codes every 10 minutes
setInterval(
  () => {
    const now = Date.now();
    for (const email in verificationCodes) {
      if (verificationCodes[email].expiresAt < now) {
        delete verificationCodes[email];
      }
    }
  },
  10 * 60 * 1000,
); // every 10 minutes

// Root route
app.get("/", (req, res) => {
  res.send("David's Army Backend is online!");
});

// Send verification code
app.post("/send-verification", async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: "Email is required" });

    // Generate 6-digit code
    const code = Math.floor(100000 + Math.random() * 900000);

    // Store code with 5-min expiry
    verificationCodes[email] = {
      code,
      expiresAt: Date.now() + 5 * 60 * 1000, // 5 minutes
    };

    // Prepare email content
    const mailOptions = {
      from: `"David's Army" <${process.env.GMAIL_EMAIL}>`,
      to: email,
      subject: "Your David's Army Verification Code",
      text: `Hello,

Your verification code is: ${code}

This code will expire in 5 minutes.

If you did not request this, please ignore this email.

- David's Army Team`,
      html: `<div style="font-family: Arial, sans-serif; color:#333;">
        <h2 style="color:#2c3e50;">David's Army Verification</h2>
        <p>Hello,</p>
        <p>Your verification code is:</p>
        <h1 style="color:#e74c3c;">${code}</h1>
        <p>This code will expire in <strong>5 minutes</strong>.</p>
        <p>If you did not request this, please ignore this email.</p>
        <hr>
        <p style="font-size:0.85em; color:#888;">- David's Army Team</p>
      </div>`,
    };

    await transporter.sendMail(mailOptions);

    res.json({ message: "Verification email sent", code }); // remove code in production
  } catch (err) {
    console.error("Nodemailer error:", err);
    res
      .status(500)
      .json({ error: "Failed to send email", details: err.message });
  }
});

// Verify code
app.post("/verify-code", (req, res) => {
  const { email, code } = req.body;

  const stored = verificationCodes[email];
  if (!stored) return res.status(400).json({ error: "No code found" });
  if (Date.now() > stored.expiresAt) {
    delete verificationCodes[email];
    return res.status(400).json({ error: "Code expired" });
  }
  if (stored.code == code) {
    delete verificationCodes[email];
    return res.json({ message: "Email verified successfully" });
  } else {
    return res.status(400).json({ error: "Invalid code" });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on ${PORT}`));
