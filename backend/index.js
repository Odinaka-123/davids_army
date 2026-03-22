require("dotenv").config();

const express = require("express");
const cors = require("cors");
const { Resend } = require("resend");

const app = express();
app.use(express.json());
app.use(cors());

const resend = new Resend(process.env.RESEND_API_KEY);

// 🔥 STORE VERIFICATION CODES
const verificationCodes = {};

// 🔥 STORE VERIFIED USERS (VERY IMPORTANT)
const verifiedUsers = {};

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


// ✅ SEND VERIFICATION CODE
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
      from: "David's Army <davidsarmy@kakkatech.com>",
      to: email,
      subject: "Your David's Army Verification Code",
      html: `
        <h2>Verification Code</h2>
        <h1>${code}</h1>
        <p>Expires in 5 minutes</p>
      `,
    });

    res.json({ message: "Verification email sent" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to send email" });
  }
});


// ✅ VERIFY CODE (FIXED)
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

    // 🔥🔥🔥 THIS IS THE MOST IMPORTANT FIX
    verifiedUsers[email] = true;

    return res.json({ success: true });
  } else {
    return res.status(400).json({ error: "Invalid code" });
  }
});


// ✅ CHECK VERIFICATION (NEW ROUTE)
app.post("/check-verification", (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ verified: false });
  }

  const isVerified = verifiedUsers[email] === true;

  return res.json({
    verified: isVerified,
  });
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on ${PORT}`));