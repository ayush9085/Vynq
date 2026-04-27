from collections import Counter

MBTI_KEYWORDS = {
    "E": [
        "party", "social", "friends", "talk", "outgoing", "group", "crowd",
        "energetic", "loud", "networking", "people", "extrovert", "fun",
        "lively", "talkative", "engaging", "meetup", "gathering", "team",
        "collaborate", "chatty", "sociable", "adventure", "exciting",
    ],
    "I": [
        "alone", "quiet", "books", "thinking", "calm", "solitude",
        "introvert", "private", "reflection", "reading", "writing",
        "peace", "serene", "space", "inner", "deep", "contemplation",
        "independent", "focused", "thoughtful", "reserved", "observe",
    ],
    "N": [
        "ideas", "future", "imagination", "creative", "abstract",
        "possibility", "vision", "innovation", "theory", "pattern",
        "meaning", "inspiration", "dream", "concept", "philosophy",
        "invent", "original", "intuition", "big picture", "hypothetical",
    ],
    "S": [
        "facts", "practical", "real", "details", "concrete", "hands-on",
        "realistic", "experience", "observe", "present", "tangible",
        "evidence", "data", "proven", "traditional", "step-by-step",
        "routine", "specific", "literal", "sensible", "grounded",
    ],
    "T": [
        "logic", "objective", "analyze", "reason", "rational", "fair",
        "strategy", "efficient", "systematic", "critical", "debate",
        "principles", "criteria", "justice", "consistent", "head",
        "impersonal", "problem-solving", "evaluate", "framework",
    ],
    "F": [
        "feelings", "emotions", "care", "empathy", "harmony", "compassion",
        "values", "heart", "kindness", "personal", "support", "warm",
        "gentle", "understand", "appreciate", "sensitive", "meaningful",
        "connection", "nurture", "trust", "loyal", "forgive",
    ],
    "J": [
        "plan", "organized", "schedule", "structure", "deadline",
        "systematic", "orderly", "list", "routine", "decide", "control",
        "prepare", "punctual", "discipline", "goal", "closure",
        "determined", "responsible", "tidy", "productive",
    ],
    "P": [
        "spontaneous", "flexible", "explore", "adapt", "open-ended",
        "go with the flow", "improvise", "curious", "casual", "freedom",
        "discover", "surprise", "options", "variety", "change",
        "relaxed", "easygoing", "adventurous", "playful", "wander",
    ],
}

AXES = [("E", "I"), ("N", "S"), ("T", "F"), ("J", "P")]

AXIS_DESCRIPTIONS = {
    "E": "Extraversion — energized by social interaction",
    "I": "Introversion — energized by solitude and reflection",
    "N": "Intuition — drawn to ideas, patterns, and possibilities",
    "S": "Sensing — focused on concrete facts and real experiences",
    "T": "Thinking — decides based on logic and objective analysis",
    "F": "Feeling — decides based on values and empathy",
    "J": "Judging — prefers structure, planning, and closure",
    "P": "Perceiving — prefers flexibility, spontaneity, and openness",
}

MBTI_TYPE_DESCRIPTIONS = {
    "INTJ": "The Architect — strategic, independent, and visionary.",
    "INTP": "The Logician — analytical, inventive, and curious.",
    "ENTJ": "The Commander — bold, strategic, and natural leaders.",
    "ENTP": "The Debater — clever, curious, and intellectually driven.",
    "INFJ": "The Advocate — insightful, principled, and compassionate.",
    "INFP": "The Mediator — idealistic, empathetic, and creative.",
    "ENFJ": "The Protagonist — charismatic, inspiring, and altruistic.",
    "ENFP": "The Campaigner — enthusiastic, creative, and sociable.",
    "ISTJ": "The Logistician — practical, reliable, and detail-oriented.",
    "ISFJ": "The Defender — warm, dedicated, and protective.",
    "ESTJ": "The Executive — organized, decisive, and tradition-minded.",
    "ESFJ": "The Consul — caring, social, and community-focused.",
    "ISTP": "The Virtuoso — observant, resourceful, and hands-on.",
    "ISFP": "The Adventurer — gentle, sensitive, and artistically inclined.",
    "ESTP": "The Entrepreneur — bold, practical, and action-oriented.",
    "ESFP": "The Entertainer — spontaneous, energetic, and fun-loving.",
}


def _normalize(text: str) -> list[str]:
    lowered = text.lower()
    for ch in ",.!?:;()[]{}\\n\\t\\r'\"":
        lowered = lowered.replace(ch, " ")
    return [token.strip() for token in lowered.split(" ") if token.strip()]


def analyze_personality(responses: dict[str, str]) -> dict:
    corpus = " ".join(responses.values())
    tokens = _normalize(corpus)
    token_counts = Counter(tokens)

    # Also check for two-word phrases
    bigrams = [f"{tokens[i]} {tokens[i+1]}" for i in range(len(tokens) - 1)]
    bigram_counts = Counter(bigrams)

    trait_counts: dict[str, int] = {}
    total_keywords = 0

    for trait, words in MBTI_KEYWORDS.items():
        count = 0
        for word in words:
            if " " in word:
                count += bigram_counts.get(word, 0)
            else:
                count += token_counts.get(word, 0)
        trait_counts[trait] = count
        total_keywords += count

    mbti_chars: list[str] = []
    axis_confidences: list[float] = []
    axis_scores: dict[str, dict] = {}

    for a, b in AXES:
        a_score = trait_counts[a]
        b_score = trait_counts[b]
        total = a_score + b_score

        if total == 0:
            dominant = a
            axis_conf = 0.50
            a_pct = 50.0
            b_pct = 50.0
        else:
            a_pct = round(a_score / total * 100, 1)
            b_pct = round(b_score / total * 100, 1)
            if a_score >= b_score:
                dominant = a
                axis_conf = a_score / total
            else:
                dominant = b
                axis_conf = b_score / total

        mbti_chars.append(dominant)
        axis_confidences.append(axis_conf)

        axis_scores[f"{a}/{b}"] = {
            "dominant": dominant,
            "confidence": round(float(axis_conf), 3),
            f"{a}_score": a_score,
            f"{b}_score": b_score,
            f"{a}_pct": a_pct,
            f"{b}_pct": b_pct,
            "dominant_description": AXIS_DESCRIPTIONS[dominant],
        }

    if total_keywords == 0:
        confidence = 0.35
    else:
        confidence = sum(axis_confidences) / len(axis_confidences)

    mbti = "".join(mbti_chars)
    type_desc = MBTI_TYPE_DESCRIPTIONS.get(mbti, f"Personality type {mbti}")

    return {
        "mbti": mbti,
        "confidence": round(float(confidence), 3),
        "keyword_counts": trait_counts,
        "axis_scores": axis_scores,
        "type_description": type_desc,
        "total_keywords_detected": total_keywords,
        "tokens_analyzed": len(tokens),
    }
