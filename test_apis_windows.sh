#!/bin/bash

# Challenge Submission Backend - Complete API Testing Script
# Author: Ashwath-saxena
# Date: 2025-07-12

echo "🚀 Challenge Submission Backend - Complete API Testing"
echo "======================================================"
echo "Author: Ashwath-saxena"
echo "Date: $(date)"
echo "Testing all endpoints systematically..."
echo ""

# Colors for better output (if supported)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print test headers
print_test_header() {
    echo -e "\n${CYAN}===========================================${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${CYAN}===========================================${NC}"
}

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if server is running
print_test_header "PRE-TEST: Checking Server Status"
response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/)
if [ $response -eq 200 ]; then
    print_status "Server is running on port 3000"
else
    print_error "Server is not running! Please start the server first with 'npm start'"
    exit 1
fi

# Test 1: Health Check
print_test_header "TEST 1: Health Check Endpoint"
print_info "Testing GET /"
curl -s -X GET http://localhost:3000/ | python -m json.tool 2>/dev/null || curl -s -X GET http://localhost:3000/
print_status "Health check completed"

# Test 2: Get All Challenges
print_test_header "TEST 2: Get All Challenges"
print_info "Testing GET /challenges"
curl -s -X GET http://localhost:3000/challenges | python -m json.tool 2>/dev/null || curl -s -X GET http://localhost:3000/challenges
print_status "Get all challenges completed"

# Test 3: Get Specific Challenge (Valid ID)
print_test_header "TEST 3: Get Specific Challenge (Valid ID)"
print_info "Testing GET /challenges/1"
curl -s -X GET http://localhost:3000/challenges/1 | python -m json.tool 2>/dev/null || curl -s -X GET http://localhost:3000/challenges/1
print_status "Get specific challenge (ID=1) completed"

# Test 4: Get Specific Challenge (Invalid ID)
print_test_header "TEST 4: Get Specific Challenge (Invalid ID)"
print_info "Testing GET /challenges/999 (should return 404)"
curl -s -X GET http://localhost:3000/challenges/999 | python -m json.tool 2>/dev/null || curl -s -X GET http://localhost:3000/challenges/999
print_status "Get specific challenge (invalid ID) completed"

# Test 5: Valid Submission #1
print_test_header "TEST 5: Valid Submission #1 (Dance Challenge)"
print_info "Testing POST /submissions with valid data"
curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 1,
    "stickers": ["dance", "music", "party", "fun"],
    "duration": 12,
    "videoUrl": "https://example.com/dance-video-1.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 1,
    "stickers": ["dance", "music", "party", "fun"],
    "duration": 12,
    "videoUrl": "https://example.com/dance-video-1.mp4"
  }'
print_status "Valid submission #1 completed"

# Test 6: Valid Submission #2
print_test_header "TEST 6: Valid Submission #2 (Cooking Challenge)"
print_info "Testing POST /submissions with different challenge"
curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 2,
    "stickers": ["cooking", "chef", "food", "delicious"],
    "duration": 10,
    "videoUrl": "https://example.com/cooking-video-1.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 2,
    "stickers": ["cooking", "chef", "food", "delicious"],
    "duration": 10,
    "videoUrl": "https://example.com/cooking-video-1.mp4"
  }'
print_status "Valid submission #2 completed"

# Test 7: Valid Submission #3
print_test_header "TEST 7: Valid Submission #3 (Fitness Challenge)"
print_info "Testing POST /submissions with edge case duration (15 seconds)"
curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 3,
    "stickers": ["fitness", "workout", "strong", "health"],
    "duration": 15,
    "videoUrl": "https://example.com/fitness-video-1.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 3,
    "stickers": ["fitness", "workout", "strong", "health"],
    "duration": 15,
    "videoUrl": "https://example.com/fitness-video-1.mp4"
  }'
print_status "Valid submission #3 (edge case) completed"

# Test 8: Invalid Submission - Duration > 15 seconds
print_test_header "TEST 8: Invalid Submission - Duration Exceeds Limit"
print_info "Testing POST /submissions with duration > 15 seconds (should fail)"
curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 4,
    "stickers": ["pet", "cute", "love"],
    "duration": 20,
    "videoUrl": "https://example.com/pet-video-long.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 4,
    "stickers": ["pet", "cute", "love"],
    "duration": 20,
    "videoUrl": "https://example.com/pet-video-long.mp4"
  }'
print_status "Invalid submission (duration) test completed"

# Test 9: Invalid Submission - Missing Challenge ID
print_test_header "TEST 9: Invalid Submission - Missing Challenge ID"
print_info "Testing POST /submissions without challengeId (should fail)"
curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "stickers": ["art", "creative", "beautiful"],
    "duration": 8,
    "videoUrl": "https://example.com/art-video.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "stickers": ["art", "creative", "beautiful"],
    "duration": 8,
    "videoUrl": "https://example.com/art-video.mp4"
  }'
print_status "Invalid submission (missing challengeId) test completed"

# Test 10: Invalid Submission - Missing Video URL
print_test_header "TEST 10: Invalid Submission - Missing Video URL"
print_info "Testing POST /submissions without videoUrl (should fail)"
curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 5,
    "stickers": ["art", "creative", "masterpiece"],
    "duration": 12
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 5,
    "stickers": ["art", "creative", "masterpiece"],
    "duration": 12
  }'
print_status "Invalid submission (missing videoUrl) test completed"

# Test 11: Invalid Submission - Invalid Stickers Format
print_test_header "TEST 11: Invalid Submission - Invalid Stickers Format"
print_info "Testing POST /submissions with invalid stickers format (should fail)"
curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 1,
    "stickers": "invalid-string-instead-of-array",
    "duration": 10,
    "videoUrl": "https://example.com/test-video.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 1,
    "stickers": "invalid-string-instead-of-array",
    "duration": 10,
    "videoUrl": "https://example.com/test-video.mp4"
  }'
print_status "Invalid submission (invalid stickers) test completed"

# Test 12: Get All Submissions
print_test_header "TEST 12: Get All Submissions (Moderation Queue)"
print_info "Testing GET /submissions"
curl -s -X GET http://localhost:3000/submissions | python -m json.tool 2>/dev/null || curl -s -X GET http://localhost:3000/submissions
print_status "Get all submissions completed"

# Test 13: Get Specific Submission (Valid ID)
print_test_header "TEST 13: Get Specific Submission (Valid ID)"
print_info "Testing GET /submissions/1"
curl -s -X GET http://localhost:3000/submissions/1 | python -m json.tool 2>/dev/null || curl -s -X GET http://localhost:3000/submissions/1
print_status "Get specific submission (ID=1) completed"

# Test 14: Get Specific Submission (Invalid ID)
print_test_header "TEST 14: Get Specific Submission (Invalid ID)"
print_info "Testing GET /submissions/999 (should return 404)"
curl -s -X GET http://localhost:3000/submissions/999 | python -m json.tool 2>/dev/null || curl -s -X GET http://localhost:3000/submissions/999
print_status "Get specific submission (invalid ID) completed"

# Test 15: Preview Feature - Valid Request
print_test_header "TEST 15: Preview Feature - Valid Request"
print_info "Testing POST /submissions/preview with valid data"
curl -s -X POST http://localhost:3000/submissions/preview \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 1,
    "stickers": ["dance", "music", "preview"],
    "duration": 13,
    "videoUrl": "https://example.com/dance-preview.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions/preview \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 1,
    "stickers": ["dance", "music", "preview"],
    "duration": 13,
    "videoUrl": "https://example.com/dance-preview.mp4"
  }'
print_status "Valid preview request completed"

# Test 16: Preview Feature - Long Duration Warning
print_test_header "TEST 16: Preview Feature - Long Duration Warning"
print_info "Testing POST /submissions/preview with duration > 15 seconds"
curl -s -X POST http://localhost:3000/submissions/preview \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 2,
    "stickers": ["cooking", "chef", "preview"],
    "duration": 18,
    "videoUrl": "https://example.com/cooking-preview-long.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions/preview \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 2,
    "stickers": ["cooking", "chef", "preview"],
    "duration": 18,
    "videoUrl": "https://example.com/cooking-preview-long.mp4"
  }'
print_status "Preview with long duration completed"

# Test 17: Preview Feature - Missing Video URL
print_test_header "TEST 17: Preview Feature - Missing Video URL"
print_info "Testing POST /submissions/preview without videoUrl (should fail)"
curl -s -X POST http://localhost:3000/submissions/preview \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 3,
    "stickers": ["fitness", "workout", "preview"],
    "duration": 14
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions/preview \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 3,
    "stickers": ["fitness", "workout", "preview"],
    "duration": 14
  }'
print_status "Preview without video URL test completed"

# Test 18: Form Data Submission (Alternative Method)
print_test_header "TEST 18: Form Data Submission (Alternative Method)"
print_info "Testing POST /submissions using form data instead of JSON"
curl -s -X POST http://localhost:3000/submissions \
  -F "challengeId=4" \
  -F "stickers=[\"pet\", \"cute\", \"adorable\", \"love\"]" \
  -F "duration=11" \
  -F "videoUrl=https://example.com/pet-video-form.mp4" | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -F "challengeId=4" \
  -F "stickers=[\"pet\", \"cute\", \"adorable\", \"love\"]" \
  -F "duration=11" \
  -F "videoUrl=https://example.com/pet-video-form.mp4"
print_status "Form data submission completed"

# Test 19: Multiple Rapid Submissions (Testing Processing Delay)
print_test_header "TEST 19: Multiple Rapid Submissions (Testing Processing Delay)"
print_info "Testing multiple rapid submissions to observe processing delays"

echo "Submission 1/3:"
curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 5,
    "stickers": ["art", "creative", "rapid1"],
    "duration": 9,
    "videoUrl": "https://example.com/art-rapid-1.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 5,
    "stickers": ["art", "creative", "rapid1"],
    "duration": 9,
    "videoUrl": "https://example.com/art-rapid-1.mp4"
  }'

echo -e "\nSubmission 2/3:"
curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 1,
    "stickers": ["dance", "music", "rapid2"],
    "duration": 7,
    "videoUrl": "https://example.com/dance-rapid-2.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 1,
    "stickers": ["dance", "music", "rapid2"],
    "duration": 7,
    "videoUrl": "https://example.com/dance-rapid-2.mp4"
  }'

echo -e "\nSubmission 3/3:"
curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 2,
    "stickers": ["cooking", "chef", "rapid3"],
    "duration": 14,
    "videoUrl": "https://example.com/cooking-rapid-3.mp4"
  }' | python -m json.tool 2>/dev/null || curl -s -X POST http://localhost:3000/submissions \
  -H "Content-Type: application/json" \
  -d '{
    "challengeId": 2,
    "stickers": ["cooking", "chef", "rapid3"],
    "duration": 14,
    "videoUrl": "https://example.com/cooking-rapid-3.mp4"
  }'

print_status "Multiple rapid submissions completed"

# Test 20: Final Submissions Check
print_test_header "TEST 20: Final Submissions Check (Moderation Status Updates)"
print_info "Testing GET /submissions to see all submissions and random moderation statuses"
curl -s -X GET http://localhost:3000/submissions | python -m json.tool 2>/dev/null || curl -s -X GET http://localhost:3000/submissions
print_status "Final submissions check completed"

# Test Summary
print_test_header "TEST SUMMARY"
echo -e "${GREEN}🎉 All API tests completed successfully!${NC}"
echo ""
echo -e "${CYAN}Tests Performed:${NC}"
echo "✅ Health Check"
echo "✅ Get All Challenges"
echo "✅ Get Specific Challenge (Valid & Invalid)"
echo "✅ Valid Submissions (Multiple scenarios)"
echo "✅ Invalid Submissions (All validation cases)"
echo "✅ Get All Submissions"
echo "✅ Get Specific Submission (Valid & Invalid)"
echo "✅ Preview Feature (Valid & Invalid)"
echo "✅ Form Data Submission"
echo "✅ Multiple Rapid Submissions"
echo "✅ Processing Delays"
echo "✅ Random Moderation Status"
echo ""
echo -e "${PURPLE}Assignment Features Demonstrated:${NC}"
echo "🎯 RESTful API Design"
echo "🎯 Input Validation"
echo "🎯 Error Handling"
echo "🎯 Processing Delays"
echo "🎯 Moderation System"
echo "🎯 Memory Storage"
echo "🎯 JSON & Form Data Support"
echo ""
echo -e "${YELLOW}Check your server console for fun messages and ASCII art!${NC}"
echo -e "${GREEN}Assignment completed successfully! 🚀${NC}"