require('dotenv').config();
const express = require('express');
const nodemailer = require('nodemailer');

const app = express();
app.use(express.json());

// POST /send-verification
app.post('/send-verification', async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }

    // Create Ethereal test account
    const testAccount = await nodemailer.createTestAccount();

    // Create transporter
    const transporter = nodemailer.createTransport({
      host: 'smtp.ethereal.email',
      port: 587,
      auth: {
        user: testAccount.user,
        pass: testAccount.pass,
      },
    });

    // Generate a simple verification code
    const code = Math.floor(100000 + Math.random() * 900000);

    // Email options
    const mailOptions = {
      from: '"David\'s Army" <no-reply@davidsarmy.com>',
      to: email,
      subject: 'Your Verification Code',
      text: `Your verification code is: ${code}`,
    };

    // Send mail
    const info = await transporter.sendMail(mailOptions);

    console.log('Message sent: %s', info.messageId);
    console.log('Preview URL: %s', nodemailer.getTestMessageUrl(info));

    res.json({
      message: 'Verification code sent',
      preview: nodemailer.getTestMessageUrl(info), // URL you can open in browser
      code, // for testing
    });
  } catch (err) {
    console.error('Error sending verification code:', err);
    res.status(500).json({ error: err.message || 'Failed to send code' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));