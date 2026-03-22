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
app.post("/verify-code", (req, res) => {
  const { email, code } = req.body;

  console.log("VERIFY REQUEST:", email, code); // 👈 ADD THIS

  const stored = verificationCodes[email];

  if (!stored) {
    console.log("NO CODE FOUND");
    return res.status(400).json({ error: "No verification code found" });
  }

  if (stored.code == code) {
    console.log("CODE MATCHED ✅");

    verifiedUsers[email] = true;

    console.log("VERIFIED USERS:", verifiedUsers); // 👈 ADD THIS

    delete verificationCodes[email];

    return res.json({ success: true });
  } else {
    console.log("INVALID CODE ❌");
    return res.status(400).json({ error: "Invalid code" });
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

  console.log("CHECK REQUEST:", email); // 👈 ADD

  console.log("VERIFIED USERS STATE:", verifiedUsers); // 👈 ADD

  const isVerified = verifiedUsers[email] === true;

  res.json({ verified: isVerified });
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on ${PORT}`));