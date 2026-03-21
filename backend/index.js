require('dotenv').config();
const express = require("express");
const nodemailer = require("nodemailer");

const app = express();
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Davids Army Backend Running");
});

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: process.env.GMAIL_EMAIL,
    pass: process.env.GMAIL_PASSWORD,
  },
});

// POST /send-verification
app.post("/send-verification", async (req, res) => {
  try {
    const { email, uid } = req.body;
    if (!email || !uid) return res.status(400).json({ error: "Email and UID required" });

    const code = Math.floor(100000 + Math.random() * 900000);

    const mailOptions = {
      from: process.env.GMAIL_EMAIL,
      to: email,
      subject: "Your Verification Code",
      text: `Your verification code is ${code}. It expires in 10 minutes.`,
    };

    await transporter.sendMail(mailOptions);
    res.json({ success: true, code });
  } catch (err) {
    console.error("Error sending verification code:", err);
    res.status(500).json({ error: "Failed to send code" });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));