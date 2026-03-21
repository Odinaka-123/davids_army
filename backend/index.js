require("dotenv").config();
const express = require("express");
const nodemailer = require("nodemailer");

const app = express();
app.use(express.json());

app.get("/", (req, res) => {
  res.send("Davids Army Backend Running");
});

// POST /send-verification
app.post("/send-verification", async (req, res) => {
  try {
    const { email, uid } = req.body;
    if (!email || !uid)
      return res.status(400).json({ error: "Email and UID required" });

    // Generate 6-digit verification code
    const code = Math.floor(100000 + Math.random() * 900000);

    // Create Ethereal test account
    const testAccount = await nodemailer.createTestAccount();

    // Create transporter
    const transporter = nodemailer.createTransport({
      host: "smtp.ethereal.email",
      port: 587,
      auth: {
        user: testAccount.user,
        pass: testAccount.pass,
      },
    });

    // Email options
    const mailOptions = {
      from: '"Davids Army" <no-reply@example.com>',
      to: email,
      subject: "Your Verification Code",
      text: `Your verification code is ${code}. It expires in 10 minutes.`,
    };

    // Send email
    const info = await transporter.sendMail(mailOptions);

    console.log("Ethereal preview URL:", nodemailer.getTestMessageUrl(info));

    res.json({
      success: true,
      code,
      previewURL: nodemailer.getTestMessageUrl(info), // link to view email
    });
  } catch (err) {
    console.error("Error sending verification code:", err);
    res.status(500).json({ error: "Failed to send code" });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));