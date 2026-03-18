require('dotenv').config();
const express = require("express");
const nodemailer = require("nodemailer");

const app = express();
app.use(express.json());

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

    // TODO: Save the code to a database (e.g., Firestore or MongoDB)
    // For now, just send it in email
    const mailOptions = {
      from: process.env.GMAIL_EMAIL,
      to: email,
      subject: "Your Verification Code",
      text: `Your verification code is ${code}. It expires in 10 minutes.`,
    };

    await transporter.sendMail(mailOptions);
    res.json({ success: true, code }); // code can be removed in production
  } catch (err) {
    console.error("Error sending verification code:", err);
    res.status(500).json({ error: "Failed to send code" });
  }
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));