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

// 🔥 STORE VERIFIED USERS
const verifiedUsers = {};

// Clean expired codes
setInterval(() => {
  const now = Date.now();
  for (const email in verificationCodes) {
    if (verificationCodes[email].expiresAt < now) {
      delete verificationCodes[email];
    }
  }
}, 10 * 60 * 1000);

// Root
app.get("/", (req, res) => {
  res.send("Backend is running");
});


// ✅ SEND VERIFICATION EMAIL (RESTORED)
app.post("/send-verification", async (req, res) => {
  try {
    const email = req.body.email?.trim().toLowerCase();

    console.log("SEND VERIFICATION:", email);

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
      from: "David's Army <davisdsarmy@kakkatech.com>", 
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


// ✅ VERIFY CODE (ONLY ONE VERSION)
app.post("/verify-code", (req, res) => {
  const email = req.body.email?.trim().toLowerCase();
  const code = req.body.code;

  console.log("VERIFY:", email, code);

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
    verifiedUsers[email] = true;
    delete verificationCodes[email];

    console.log("VERIFIED USERS:", verifiedUsers);

    return res.json({ success: true });
  }

  return res.status(400).json({ error: "Invalid code" });
});


// ✅ CHECK VERIFICATION
app.post("/check-verification", (req, res) => {
  const email = req.body.email?.trim().toLowerCase();

  console.log("CHECK:", email);
  console.log("STATE:", verifiedUsers);

  res.json({
    verified: verifiedUsers[email] === true,
  });
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on ${PORT}`));