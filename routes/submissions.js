const express = require('express');
const multer = require('multer');
const router = express.Router();

// In-memory storage for submissions
let submissions = [];
let submissionIdCounter = 1;

// Multer configuration for file uploads
const storage = multer.memoryStorage();
const upload = multer({ 
  storage: storage,
  limits: { fileSize: 50 * 1024 * 1024 } // 50MB limit
});

// Helper function to generate random moderation status
const getRandomModerationStatus = () => {
  const statuses = ['pending', 'approved', 'rejected'];
  return statuses[Math.floor(Math.random() * statuses.length)];
};

// Middleware to simulate processing delay
const simulateProcessingDelay = (req, res, next) => {
  console.log('⏳ Processing submission...');
  setTimeout(() => {
    console.log('✅ Processing complete!');
    next();
  }, 1000 + Math.random() * 2000); // Random delay between 1-3 seconds
};

// POST /submissions - Submit a challenge entry
router.post('/', upload.single('video'), simulateProcessingDelay, (req, res) => {
  const { challengeId, stickers, duration } = req.body;
  const videoFile = req.file;
  const videoUrl = req.body.videoUrl; // For URL-based submissions

  // Validation
  if (!challengeId) {
    return res.status(400).json({
      success: false,
      message: 'Challenge ID is required'
    });
  }

  if (!videoFile && !videoUrl) {
    return res.status(400).json({
      success: false,
      message: 'Video file or video URL is required'
    });
  }

  // Fix: Better stickers validation
  let parsedStickers = [];
  if (stickers) {
    try {
      parsedStickers = typeof stickers === 'string' ? JSON.parse(stickers) : stickers;
    } catch (error) {
      return res.status(400).json({
        success: false,
        message: 'Invalid stickers format. Must be a valid JSON array.'
      });
    }
  }

  if (!Array.isArray(parsedStickers)) {
    return res.status(400).json({
      success: false,
      message: 'Stickers must be provided as an array'
    });
  }

  // Duration validation (simulate ≤ 15 seconds)
  const videoDuration = parseInt(duration) || Math.floor(Math.random() * 20) + 5; // Random duration for simulation
  if (videoDuration > 15) {
    return res.status(400).json({
      success: false,
      message: 'Video duration must be 15 seconds or less'
    });
  }

  // Create submission object
  const submission = {
    id: submissionIdCounter++,
    challengeId: parseInt(challengeId),
    videoUrl: videoUrl || `uploaded-video-${Date.now()}.mp4`,
    stickers: parsedStickers,
    duration: videoDuration,
    status: 'pending',
    submittedAt: new Date().toISOString(),
    moderationStatus: getRandomModerationStatus()
  };

  // Store submission
  submissions.push(submission);

  console.log(`🎬 New submission received for challenge ${challengeId}`);

  res.status(201).json({
    success: true,
    data: submission,
    message: 'Submission pending review by moderator'
  });
});

// GET /submissions - Get all submissions (moderation queue)
router.get('/', (req, res) => {
  console.log('📋 Fetching submissions queue...');
  
  // Simulate random status updates for existing submissions
  const updatedSubmissions = submissions.map(submission => ({
    ...submission,
    moderationStatus: submission.moderationStatus === 'pending' ? 
      getRandomModerationStatus() : submission.moderationStatus
  }));

  res.json({
    success: true,
    data: updatedSubmissions,
    count: updatedSubmissions.length,
    message: 'Submissions retrieved successfully!'
  });
});

// GET /submissions/:id - Get specific submission
router.get('/:id', (req, res) => {
  const submissionId = parseInt(req.params.id);
  const submission = submissions.find(s => s.id === submissionId);
  
  if (!submission) {
    return res.status(404).json({
      success: false,
      message: 'Submission not found'
    });
  }
  
  res.json({
    success: true,
    data: submission,
    message: 'Submission retrieved successfully!'
  });
});

// POST /submissions/preview - Preview video before submission (Bonus feature)
router.post('/preview', upload.single('video'), (req, res) => {
  const { challengeId, stickers, duration } = req.body;
  const videoFile = req.file;
  const videoUrl = req.body.videoUrl;

  if (!videoFile && !videoUrl) {
    return res.status(400).json({
      success: false,
      message: 'Video file or video URL is required for preview'
    });
  }

  // Fix: Better stickers validation for preview
  let parsedStickers = [];
  if (stickers) {
    try {
      parsedStickers = typeof stickers === 'string' ? JSON.parse(stickers) : stickers;
    } catch (error) {
      parsedStickers = [];
    }
  }

  const videoDuration = parseInt(duration) || Math.floor(Math.random() * 20) + 5;
  
  console.log('👀 Generating preview...');

  // Simulate preview generation
  setTimeout(() => {
    const previewData = {
      challengeId: parseInt(challengeId),
      videoUrl: videoUrl || `preview-${Date.now()}.mp4`,
      stickers: parsedStickers,
      duration: videoDuration,
      previewUrl: `preview-${Date.now()}.mp4`,
      isValid: videoDuration <= 15,
      warnings: videoDuration > 15 ? ['Video duration exceeds 15 seconds'] : []
    };

    res.json({
      success: true,
      data: previewData,
      message: 'Preview generated successfully!'
    });
  }, 500);
});

module.exports = router;