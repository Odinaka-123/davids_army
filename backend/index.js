require("dotenv").config();
const express = require("express");
const Mailjet = require("node-mailjet"); // Updated import

const app = express();
app.use(express.json());

// Initialize Mailjet client
const mailjet = new Mailjet({
  apiKey: process.env.MAILJET_API_KEY,
  apiSecret: process.env.MAILJET_SECRET_KEY,
});

// Temporary in-memory storage for verification codes
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

    await mailjet
      .post("send", { version: "v3.1" })
      .request({
        Messages: [
          {
            From: {
              Email: process.env.MAILJET_SENDER_EMAIL,
              Name: process.env.MAILJET_SENDER_NAME,
            },
            To: [
              {
                Email: email,
                Name: "",
              },
            ],
            Subject: "Your Verification Code",
            TextPart: `Your verification code is: ${code}`,
          },
        ],
      });

    res.json({ message: "Verification email sent", code }); // remove code in production
  } catch (err) {
    console.error("Mailjet error:", err);
    res.status(500).json({
      error: "Failed to send email",
      details: err.message,
    });
  }
});

// Verify code
app.post("/verify-code", (req, res) => {
  const { email, code } = req.body;

  if (verificationCodes[email] == code) {
    delete verificationCodes[email]; // remove after verification
    return res.json({ message: "Email verified successfully" });
  } else {
    return res.status(400).json({ error: "Invalid code" });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on ${PORT}`));