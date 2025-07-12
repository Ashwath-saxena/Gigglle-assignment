const express = require('express');
const cors = require('cors');
const challengeRoutes = require('./routes/challenges');
const submissionRoutes = require('./routes/submissions');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Fun ASCII art when server starts
const asciiArt = `
╔══════════════════════════════════════════════════════════════╗
║                                                              ║
║   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   ║
║   ░░    ░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    ░░   ║
║   ░░    ░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    ░░   ║
║   ░░    ░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    ░░   ║
║   ░░    ░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    ░░   ║
║   ░░    ░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    ░░   ║
║   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░   ║
║                                                              ║
║              🎬 Challenge Submission Backend 🎬              ║
║                     Ready to accept challenges!             ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
`;

// Routes
app.use('/challenges', challengeRoutes);
app.use('/submissions', submissionRoutes);

// Health check endpoint
app.get('/', (req, res) => {
  res.json({ 
    message: 'Challenge Submission Backend is running! 🚀',
    endpoints: {
      challenges: 'GET /challenges',
      submissions: 'GET /submissions, POST /submissions',
      preview: 'POST /preview'
    }
  });
});

// Start server
app.listen(PORT, () => {
  console.log(asciiArt);
  console.log(`🚀 Server is running on port ${PORT}`);
  console.log(`🌐 Visit http://localhost:${PORT} to test the API`);
});