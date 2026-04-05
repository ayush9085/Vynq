# Personality Assessment Questions
# These questions are designed to explore MBTI-inspired traits and communication style

ASSESSMENT_QUESTIONS = [
    {
        "id": 1,
        "text": "On a typical weekend, I prefer to...",
        "trait": "introversion_extraversion",
        "type": "single_choice",
        "options": [
            "Spend time alone or with close friends, doing quiet activities",
            "Go out and socialize with a larger group of people",
            "A mix of both, depending on my mood"
        ]
    },
    {
        "id": 2,
        "text": "When learning something new, I prefer to...",
        "trait": "intuition_sensing",
        "type": "single_choice",
        "options": [
            "Focus on concrete facts, real-world examples, and proven methods",
            "Explore theories, possibilities, and the bigger picture",
            "Happy with either approach"
        ]
    },
    {
        "id": 3,
        "text": "When making important decisions, I typically...",
        "trait": "thinking_feeling",
        "type": "single_choice",
        "options": [
            "Analyze pros/cons logically, even if it seems cold",
            "Consider how it affects people's feelings and relationships",
            "Try to balance both logic and emotion"
        ]
    },
    {
        "id": 4,
        "text": "In my daily life, I tend to be...",
        "trait": "judging_perceiving",
        "type": "single_choice",
        "options": [
            "Well-organized, prefer plans and structure",
            "Flexible, spontaneous, and go with the flow",
            "Depends on the situation"
        ]
    },
    {
        "id": 5,
        "text": "In conversations, I usually...",
        "trait": "communication_style",
        "type": "single_choice",
        "options": [
            "Say what I think directly and honestly",
            "Soften my words to avoid hurting people's feelings",
            "Adjust my approach based on who I'm talking to"
        ]
    },
    {
        "id": 6,
        "text": "What energizes you the most?",
        "trait": "introversion_extraversion",
        "type": "text"
    },
    {
        "id": 7,
        "text": "What's your ideal type of date?",
        "trait": "intuition_sensing",
        "type": "text"
    },
    {
        "id": 8,
        "text": "What's most important to you in a relationship?",
        "trait": "thinking_feeling",
        "type": "text"
    },
    {
        "id": 9,
        "text": "How do you handle stress?",
        "trait": "judging_perceiving",
        "type": "text"
    },
    {
        "id": 10,
        "text": "Describe your communication style with others.",
        "trait": "communication_style",
        "type": "text"
    },
    {
        "id": 11,
        "text": "I enjoy meeting new people and making friends.",
        "trait": "introversion_extraversion",
        "type": "likert_scale"
    },
    {
        "id": 12,
        "text": "I prefer to follow established rules and procedures.",
        "trait": "intuition_sensing",
        "type": "likert_scale"
    },
    {
        "id": 13,
        "text": "I make decisions based on my values and empathy.",
        "trait": "thinking_feeling",
        "type": "likert_scale"
    },
    {
        "id": 14,
        "text": "I prefer my schedule to be structured and planned.",
        "trait": "judging_perceiving",
        "type": "likert_scale"
    },
    {
        "id": 15,
        "text": "I'm very honest, even when it might hurt someone.",
        "trait": "communication_style",
        "type": "likert_scale"
    },
    {
        "id": 16,
        "text": "What's something you're passionate about?",
        "trait": "intuition_sensing",
        "type": "text"
    },
    {
        "id": 17,
        "text": "How do you show affection to someone you care about?",
        "trait": "thinking_feeling",
        "type": "text"
    },
    {
        "id": 18,
        "text": "What's your biggest strength in relationships?",
        "trait": "communication_style",
        "type": "text"
    },
    {
        "id": 19,
        "text": "Tell me about your ideal partner's personality type.",
        "trait": "introversion_extraversion",
        "type": "text"
    },
    {
        "id": 20,
        "text": "What quality do you find most attractive in a person?",
        "trait": "thinking_feeling",
        "type": "text"
    }
]

# Trait dimension definitions
TRAIT_DEFINITIONS = {
    "introversion_extraversion": {
        "name": "Introversion ↔ Extraversion",
        "description": "Social energy and preference for interaction",
        "low": "Introverted - energized by alone time",
        "high": "Extraverted - energized by interaction"
    },
    "intuition_sensing": {
        "name": "Intuition ↔ Sensing",
        "description": "How you perceive and process information",
        "low": "Sensing - focuses on concrete facts and present",
        "high": "Intuition - focuses on patterns and possibilities"
    },
    "thinking_feeling": {
        "name": "Thinking ↔ Feeling",
        "description": "How you make decisions",
        "low": "Thinking - logic-driven, objective",
        "high": "Feeling - values-driven, empathetic"
    },
    "judging_perceiving": {
        "name": "Judging ↔ Perceiving",
        "description": "Approach to structure and organization",
        "low": "Perceiving - flexible, spontaneous, open-ended",
        "high": "Judging - organized, planned, structured"
    },
    "communication_style": {
        "name": "Communication Style",
        "description": "Directness and diplomatic approach",
        "low": "Diplomatic - tactful, soft-spoken",
        "high": "Direct - straightforward, honest"
    }
}

# Number of questions to show user
QUESTIONS_PER_SESSION = 20
