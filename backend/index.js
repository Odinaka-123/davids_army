require("dotenv").config();
const express = require("express");
const { BrevoClient } = require("@getbrevo/brevo");

const app = express();
app.use(express.json());

// Initialize Brevo client
const brevo = new BrevoClient({
  apiKey: process.env.BREVO_API_KEY,
});

// Root route
app.get("/", (req, res) => {
  res.send("David's Army Backend is online!");
});

// POST /send-verification
app.post("/send-verification", async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({ error: "Email is required" });
    }

    // Generate 6-digit verification code
    const code = Math.floor(100000 + Math.random() * 900000);

    // Send email via Brevo
    const response = await brevo.transactionalEmails.sendTransacEmail({
      sender: {
        email: process.env.BREVO_SENDER_EMAIL,
        name: process.env.BREVO_SENDER_NAME,
      },
      to: [{ email, name: "" }],
      subject: "Your Verification Code",
      textContent: `Your verification code is: ${code}`,
    });

    res.json({
      message: "Verification email sent",
      code, // only for testing; remove in production
    });
  } catch (err) {
    console.error("Brevo error:", err.response?.data || err);
    res.status(500).json({
      error: "Failed to send email",
      details: err.response?.data || err.message,
    });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on ${PORT}`));