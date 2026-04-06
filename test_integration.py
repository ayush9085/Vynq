#!/usr/bin/env python3
"""
Integration test for VYNK API endpoints
Tests the complete flow: Register -> Login -> Onboarding -> Matches
"""

import requests
import json
import time
from datetime import datetime

# API Configuration
BASE_URL = "http://localhost:8000"
API_URL = f"{BASE_URL}/api"

# Test user data
TEST_EMAIL = f"test_user_{int(time.time())}@example.com"
TEST_USER = {
    "email": TEST_EMAIL,
    "first_name": "Test",
    "last_name": "User",
    "password": "testpass123"
}

# Colors for terminal output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
BLUE = '\033[94m'
RESET = '\033[0m'

def log_header(text):
    print(f"\n{BLUE}{'='*60}{RESET}")
    print(f"{BLUE}{text:^60}{RESET}")
    print(f"{BLUE}{'='*60}{RESET}\n")

def log_success(text):
    print(f"{GREEN}✓ {text}{RESET}")

def log_error(text):
    print(f"{RED}✗ {text}{RESET}")

def log_info(text):
    print(f"{YELLOW}ℹ {text}{RESET}")

def test_health_check():
    """Test 1: Health check"""
    log_header("TEST 1: Health Check")
    try:
        response = requests.get(f"{BASE_URL}/health")
        if response.status_code == 200:
            log_success(f"Health check passed - {response.json()['status']}")
            return True
        else:
            log_error(f"Health check failed with status {response.status_code}")
            return False
    except Exception as e:
        log_error(f"Health check error: {e}")
        return False

def test_registration():
    """Test 2: User registration"""
    log_header("TEST 2: User Registration")
    try:
        response = requests.post(
            f"{API_URL}/auth/register",
            json=TEST_USER
        )
        if response.status_code == 201:
            data = response.json()
            log_success(f"User registered successfully")
            log_info(f"Email: {TEST_USER['email']}")
            log_info(f"User ID: {data['user_id']}")
            log_info(f"Token: {data['access_token'][:50]}...")
            return True, data['access_token'], data['user_id']
        else:
            log_error(f"Registration failed with status {response.status_code}")
            log_error(f"Response: {response.json()}")
            return False, None, None
    except Exception as e:
        log_error(f"Registration error: {e}")
        return False, None, None

def test_login(token=None):
    """Test 3: User login"""
    log_header("TEST 3: User Login")
    try:
        response = requests.post(
            f"{API_URL}/auth/login",
            json={
                "email": TEST_USER["email"],
                "password": TEST_USER["password"]
            }
        )
        if response.status_code == 200:
            data = response.json()
            log_success("User logged in successfully")
            log_info(f"Token: {data['access_token'][:50]}...")
            return True, data['access_token']
        else:
            log_error(f"Login failed with status {response.status_code}")
            log_error(f"Response: {response.json()}")
            return False, token
    except Exception as e:
        log_error(f"Login error: {e}")
        return False, token

def test_assessment_questions(token):
    """Test 4: Get assessment questions"""
    log_header("TEST 4: Get Assessment Questions")
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(
            f"{API_URL}/users/assessment-questions",
            headers=headers
        )
        if response.status_code == 200:
            questions = response.json()
            log_success(f"Got {len(questions)} assessment questions")
            for q in questions[:2]:
                log_info(f"Q{q['id']}: {q['text'][:50]}...")
            return True, questions
        else:
            log_error(f"Failed to get questions - status {response.status_code}")
            return False, None
    except Exception as e:
        log_error(f"Assessment questions error: {e}")
        return False, None

def test_onboarding(token):
    """Test 5: Complete onboarding"""
    log_header("TEST 5: Complete Onboarding")
    try:
        headers = {"Authorization": f"Bearer {token}"}
        payload = {
            "age": 25,
            "gender": "male",
            "interests": ["music", "travel", "fitness"],
            "responses": {
                "1": "Agree",
                "2": "Neutral",
                "3": "Disagree",
                "4": "Agree"
            }
        }
        response = requests.post(
            f"{API_URL}/users/onboarding",
            json=payload,
            headers=headers
        )
        if response.status_code == 200:
            data = response.json()
            log_success("Onboarding completed")
            log_info(f"MBTI Type: {data.get('mbti')}")
            log_info(f"Confidence: {data.get('confidence', 0) * 100:.0f}%")
            log_info(f"Message: {data.get('message')}")
            return True
        else:
            log_error(f"Onboarding failed - status {response.status_code}")
            log_error(f"Response: {response.json()}")
            return False
    except Exception as e:
        log_error(f"Onboarding error: {e}")
        return False

def test_get_profile(token, user_id):
    """Test 6: Get user profile"""
    log_header("TEST 6: Get User Profile")
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(
            f"{API_URL}/users/{user_id}",
            headers=headers
        )
        if response.status_code == 200:
            user = response.json()
            log_success("Profile retrieved successfully")
            log_info(f"Name: {user['first_name']} {user['last_name']}")
            log_info(f"Email: {user['email']}")
            log_info(f"Age: {user.get('age')}")
            log_info(f"MBTI: {user.get('mbti')}")
            return True
        else:
            log_error(f"Failed to get profile - status {response.status_code}")
            return False
    except Exception as e:
        log_error(f"Get profile error: {e}")
        return False

def test_find_matches(token):
    """Test 7: Find matches"""
    log_header("TEST 7: Find Matches")
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(
            f"{API_URL}/matches/find?limit=5",
            headers=headers
        )
        if response.status_code == 200:
            matches = response.json()
            log_success(f"Found {len(matches)} matches")
            for match in matches[:3]:
                log_info(f"Match: {match['name']} ({match['mbti']}) - {match['compatibility_score']}% compatible")
            return True, matches
        elif response.status_code == 400:
            log_error("User hasn't completed onboarding yet")
            return False, None
        else:
            log_error(f"Failed to find matches - status {response.status_code}")
            return False, None
    except Exception as e:
        log_error(f"Find matches error: {e}")
        return False, None

def test_match_details(token, match_user_id):
    """Test 8: Get match details"""
    log_header("TEST 8: Get Match Details")
    try:
        headers = {"Authorization": f"Bearer {token}"}
        response = requests.get(
            f"{API_URL}/matches/{match_user_id}",
            headers=headers
        )
        if response.status_code == 200:
            match = response.json()
            log_success("Match details retrieved")
            log_info(f"Name: {match['name']}")
            log_info(f"MBTI: {match['mbti']}")
            log_info(f"Compatibility: {match['compatibility_score']}%")
            log_info(f"Reasons: {', '.join(match['match_reasons'][:2])}")
            return True
        else:
            log_error(f"Failed to get match details - status {response.status_code}")
            return False
    except Exception as e:
        log_error(f"Get match details error: {e}")
        return False

def main():
    """Run all integration tests"""
    print(f"\n{YELLOW}VYNK API Integration Test Suite{RESET}")
    print(f"{YELLOW}Started at {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}{RESET}\n")

    results = {}
    
    # Test 1: Health check
    results['health_check'] = test_health_check()
    if not results['health_check']:
        log_error("Backend is not running! Please start the backend server.")
        return

    # Test 2: Registration
    reg_success, token, user_id = test_registration()
    results['registration'] = reg_success
    
    if not reg_success:
        log_error("Cannot proceed without registration")
        return
    
    # Test 3: Login
    login_success, login_token = test_login(token)
    results['login'] = login_success
    if login_success:
        token = login_token

    # Test 4: Assessment questions
    results['assessment_questions'] = test_assessment_questions(token)[0]

    # Test 5: Onboarding
    results['onboarding'] = test_onboarding(token)

    # Test 6: Get profile
    results['get_profile'] = test_get_profile(token, user_id)

    # Test 7: Find matches
    matches_success, matches = test_find_matches(token)
    results['find_matches'] = matches_success

    # Test 8: Match details (if matches found)
    if matches_success and matches:
        results['match_details'] = test_match_details(token, matches[0]['match_user_id'])
    else:
        log_info("Skipping match details test - no matches available")
        results['match_details'] = None

    # Summary
    log_header("TEST SUMMARY")
    passed = sum(1 for v in results.values() if v is True)
    failed = sum(1 for v in results.values() if v is False)
    skipped = sum(1 for v in results.values() if v is None)
    total = len(results)

    for test, result in results.items():
        status = "✓ PASS" if result is True else ("✗ FAIL" if result is False else "⊘ SKIP")
        symbol = GREEN if result is True else (RED if result is False else YELLOW)
        print(f"{symbol}{status}{RESET} - {test}")

    print(f"\n{BLUE}Results: {GREEN}{passed}{RESET} passed, {RED}{failed}{RESET} failed, {YELLOW}{skipped}{RESET} skipped{RESET}\n")

    if failed == 0:
        print(f"{GREEN}All tests passed! ✓{RESET}\n")
    else:
        print(f"{RED}Some tests failed. Please review the errors above.{RESET}\n")

if __name__ == "__main__":
    main()
