const express = require('express');
const router = express.Router();

// Dummy challenges data
const challenges = [
  {
    id: 1,
    title: "Dance Challenge 💃",
    videoUrl: "https://example.com/dance-challenge.mp4",
    stickers: ["🕺", "💃", "🎵", "🎶", "✨", "🔥"]
  },
  {
    id: 2,
    title: "Cooking Challenge 👨‍🍳",
    videoUrl: "https://example.com/cooking-challenge.mp4",
    stickers: ["👨‍🍳", "🍳", "🥘", "🍕", "🎂", "😋"]
  },
  {
    id: 3,
    title: "Fitness Challenge 💪",
    videoUrl: "https://example.com/fitness-challenge.mp4",
    stickers: ["💪", "🏃‍♂️", "🏋️‍♀️", "🧘‍♂️", "🔥", "💦"]
  },
  {
    id: 4,
    title: "Pet Challenge 🐕",
    videoUrl: "https://example.com/pet-challenge.mp4",
    stickers: ["🐕", "🐱", "🐰", "🐹", "❤️", "🐾"]
  },
  {
    id: 5,
    title: "Art Challenge 🎨",
    videoUrl: "https://example.com/art-challenge.mp4",
    stickers: ["🎨", "🖌️", "🖍️", "🎭", "🌈", "✨"]
  }
];

// GET /challenges - Returns list of 5 dummy challenges
router.get('/', (req, res) => {
  console.log('📋 Fetching challenges...');
  res.json({
    success: true,
    data: challenges,
    message: 'Challenges retrieved successfully!'
  });
});

// GET /challenges/:id - Get specific challenge
router.get('/:id', (req, res) => {
  const challengeId = parseInt(req.params.id);
  const challenge = challenges.find(c => c.id === challengeId);
  
  if (!challenge) {
    return res.status(404).json({
      success: false,
      message: 'Challenge not found'
    });
  }
  
  res.json({
    success: true,
    data: challenge,
    message: 'Challenge retrieved successfully!'
  });
});

module.exports = router;