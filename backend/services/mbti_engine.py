from collections import Counter

MBTI_KEYWORDS = {
    "E": ["party", "social", "friends", "talk", "outgoing"],
    "I": ["alone", "quiet", "books", "thinking", "calm"],
    "N": ["ideas", "future", "imagination", "creative"],
    "S": ["facts", "practical", "real", "details"],
    "T": ["logic", "objective", "analyze", "reason"],
    "F": ["feelings", "emotions", "care", "empathy"],
    "J": ["plan", "organized", "schedule", "structure"],
    "P": ["spontaneous", "flexible", "explore", "adapt"],
}

AXES = [("E", "I"), ("N", "S"), ("T", "F"), ("J", "P")]


def _normalize(text: str) -> list[str]:
    lowered = text.lower()
    for ch in ",.!?:;()[]{}\n\t\r":
        lowered = lowered.replace(ch, " ")
    return [token.strip() for token in lowered.split(" ") if token.strip()]


def analyze_personality(responses: dict[str, str]) -> dict:
    corpus = " ".join(responses.values())
    tokens = _normalize(corpus)
    token_counts = Counter(tokens)

    trait_counts: dict[str, int] = {}
    total_keywords = 0

    for trait, words in MBTI_KEYWORDS.items():
        count = sum(token_counts.get(word, 0) for word in words)
        trait_counts[trait] = count
        total_keywords += count

    mbti_chars: list[str] = []
    axis_confidences: list[float] = []

    for a, b in AXES:
        a_score = trait_counts[a]
        b_score = trait_counts[b]

        if a_score == 0 and b_score == 0:
            dominant = a
            axis_conf = 0.25
        elif a_score >= b_score:
            dominant = a
            axis_conf = a_score / max(a_score + b_score, 1)
        else:
            dominant = b
            axis_conf = b_score / max(a_score + b_score, 1)

        mbti_chars.append(dominant)
        axis_confidences.append(axis_conf)

    if total_keywords == 0:
        confidence = 0.35
    else:
        confidence = sum(axis_confidences) / len(axis_confidences)

    mbti = "".join(mbti_chars)

    return {
        "mbti": mbti,
        "confidence": round(float(confidence), 3),
        "keyword_counts": trait_counts,
    }
