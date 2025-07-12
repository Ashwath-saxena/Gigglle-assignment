# Challenge Submission Backend

A lightweight Node.js backend that supports a simplified version of the "Challenge Submission" flow used in the Gigglle app.

## Features Completed ✅

### Core Features
- ✅ **GET /challenges** - Returns a list of 5 dummy challenges with id, title, videoUrl, and stickers
- ✅ **POST /submissions** - Accepts video submissions with validation for video existence and duration (≤15 seconds)
- ✅ **GET /submissions** - Returns all submitted entries (moderation queue)

### Bonus Features 🌟
- ✅ **POST /preview** - Preview video before final submission
- ✅ **Processing delay simulation** - Adds realistic delay with middleware
- ✅ **Moderation status** - Random moderation status simulation ('pending', 'approved', 'rejected')
- ✅ **Fun ASCII art** - Displays when server starts
- ✅ **Modular routes** - Proper folder structure with separate route files

## Setup Instructions

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn

### Installation
1. Clone or download the project files
2. Install dependencies:
```bash
npm install
```

### Running the Server
```bash
# Development mode with auto-restart
npm run dev

# Production mode
npm start
```

The server will start on `http://localhost:3000`

## API Endpoints

### 1. Get Challenges
```http
GET /challenges
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "Dance Challenge 💃",
      "videoUrl": "https://example.com/dance-challenge.mp4",
      "stickers": ["🕺", "💃", "🎵", "🎶", "✨", "🔥"]
    }
  ],
  "message": "Challenges retrieved successfully!"
}
```

### 2. Submit Challenge Entry
```http
POST /submissions
Content-Type: multipart/form-data

{
  "challengeId": 1,
  "stickers": ["🕺", "💃", "🎵"],
  "duration": 12,
  "videoUrl": "https://example.com/my-video.mp4"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "challengeId": 1,
    "videoUrl": "https://example.com/my-video.mp4",
    "stickers": ["🕺", "💃", "🎵"],
    "duration": 12,
    "status": "pending",
    "submittedAt": "2024-01-15T10:30:00.000Z",
    "moderationStatus": "pending"
  },
  "message": "Submission pending review by moderator"
}
```

### 3. Get All Submissions
```http
GET /submissions
```

### 4. Preview Submission (Bonus)
```http
POST /preview
Content-Type: multipart/form-data

{
  "challengeId": 1,
  "stickers": ["🕺", "💃"],
  "duration": 14,
  "videoUrl": "https://example.com/preview-video.mp4"
}
```

## cURL Test Examples

### Get Challenges
```bash
curl -X GET http://localhost:3000/challenges
```

### Submit a Challenge Entry
```bash
curl -X POST http://localhost:3000/submissions \
  -F "challengeId=1" \
  -F "stickers=[\"🕺\", \"💃\", \"🎵\"]" \
  -F "duration=12" \
  -F "videoUrl=https://example.com/my-dance-video.mp4"
```

### Get All Submissions
```bash
curl -X GET http://localhost:3000/submissions
```

### Preview Submission
```bash
curl -X POST http://localhost:3000/preview \
  -F "challengeId=1" \
  -F "stickers=[\"🕺\", \"💃\"]" \
  -F "duration=14" \
  -F "videoUrl=https://example.com/preview-video.mp4"
```

## Project Structure

```
challenge-submission-backend/
├── package.json
├── server.js
├── routes/
│   ├── challenges.js
│   └── submissions.js
└── README.md
```

## Tech Stack

- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **Multer** - File upload middleware
- **CORS** - Cross-origin resource sharing

## Assumptions & Tradeoffs

### Assumptions
1. **Video Duration Simulation**: Since we're not processing actual video files, duration is either provided in the request or randomly generated (5-25 seconds) for validation testing
2. **Video Storage**: Videos are simulated using URLs or filenames rather than actual file storage
3. **Stickers**: Represented as emoji arrays for simplicity
4. **Moderation**: Status is randomly assigned for demonstration purposes

### Tradeoffs
1. **In-Memory Storage**: Submissions are stored in memory, so they're lost when server restarts. In production, you'd use a database
2. **No Authentication**: No user authentication implemented for simplicity
3. **Basic Validation**: Minimal validation on file types and sizes
4. **Mock Data**: All challenges and some submission data are hardcoded for demonstration

## Future Enhancements

- Add database integration (MongoDB/PostgreSQL)
- Implement user authentication and authorization
- Add actual video processing and storage
- Implement real-time notifications for moderation updates
- Add rate limiting and better error handling
- Add unit tests and integration tests

## Author

Ashwath Saxena

---

🎬 **Happy Coding!** 🎬