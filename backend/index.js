require("dotenv").config();

const express = require("express");
const cors = require("cors");
const { Resend } = require("resend");

const app = express();
app.use(express.json());
app.use(cors());

const resend = new Resend(process.env.RESEND_API_KEY);

// In-memory storage for verification codes
const verificationCodes = {};

// Clean expired codes every 10 minutes
setInterval(() => {
  const now = Date.now();
  for (const email in verificationCodes) {
    if (verificationCodes[email].expiresAt < now) {
      delete verificationCodes[email];
    }
  }
}, 10 * 60 * 1000);

// Root route
app.get("/", (req, res) => {
  res.send("David's Army Backend is online!");
});

// Send verification code
app.post("/send-verification", async (req, res) => {
  try {
    const { email } = req.body;

    if (!email) {
      return res.status(400).json({ error: "Email is required" });
    }

    const existing = verificationCodes[email];
    if (existing && Date.now() < existing.expiresAt) {
      return res.json({
        message: "Verification code already sent. Check your email.",
      });
    }

    const code = Math.floor(100000 + Math.random() * 900000);

    verificationCodes[email] = {
      code,
      expiresAt: Date.now() + 5 * 60 * 1000,
    };

    await resend.emails.send({
      from: "onboarding@resend.dev",
      to: email,
      subject: "Your David's Army Verification Code",
      html: `
        <div style="font-family: Arial, sans-serif; color:#333;">
          <h2>David's Army Verification</h2>
          <p>Your verification code is:</p>
          <h1 style="color:#e74c3c;">${code}</h1>
          <p>This code will expire in <strong>5 minutes</strong>.</p>
        </div>
      `,
    });

    res.json({ message: "Verification email sent" });
  } catch (err) {
    console.error("Resend error:", err);
    res.status(500).json({ error: "Failed to send email" });
  }
});

// Verify code
app.post("/verify-code", (req, res) => {
  const { email, code } = req.body;

  if (!email || !code) {
    return res.status(400).json({ error: "Email and code are required" });
  }

  const stored = verificationCodes[email];

  if (!stored) {
    return res.status(400).json({ error: "No verification code found" });
  }

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