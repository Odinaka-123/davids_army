require("dotenv").config();
const express = require("express");
const nodemailer = require("nodemailer");

const app = express();
app.use(express.json());

// Nodemailer transporter using Gmail
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.GMAIL_EMAIL,
    pass: process.env.GMAIL_APP_PASSWORD,
  },
});

// In-memory verification codes
const verificationCodes = {};

// Root route
app.get("/", (req, res) => {
  res.send("David's Army Backend is online!");
});

// Send verification code
app.post("/send-verification", async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) return res.status(400).json({ error: "Email is required" });

    const code = Math.floor(100000 + Math.random() * 900000);
    verificationCodes[email] = code; // store code temporarily

    await transporter.sendMail({
      from: `"David's Army" <${process.env.GMAIL_EMAIL}>`,
      to: email,
      subject: "Your Verification Code",
      text: `Your verification code is: ${code}`,
    });

    res.json({ message: "Verification email sent", code }); // remove code in production
  } catch (err) {
    console.error("Nodemailer error:", err);
    res.status(500).json({ error: "Failed to send email", details: err.message });
  }
});

// Verify code
app.post("/verify-code", (req, res) => {
  const { email, code } = req.body;

  if (verificationCodes[email] == code) {
    delete verificationCodes[email];
    return res.json({ message: "Email verified successfully" });
  } else {
    return res.status(400).json({ error: "Invalid code" });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on ${PORT}`));