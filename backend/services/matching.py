from .explanation import generate_match_explanation


def _axis_score(user_mbti: str, other_mbti: str) -> int:
    score = 0

    # E/I opposite = +25
    if user_mbti[0] != other_mbti[0]:
        score += 25

    # N/S same = +25
    if user_mbti[1] == other_mbti[1]:
        score += 25

    # T/F opposite = +25
    if user_mbti[2] != other_mbti[2]:
        score += 25

    # J/P same = +25
    if user_mbti[3] == other_mbti[3]:
        score += 25

    return score


def compute_match(user: dict, other: dict) -> dict:
    user_mbti = user.get("mbti") or "ENFP"
    other_mbti = other.get("mbti") or "ENFP"

    user_interests = set(i.lower() for i in user.get("interests", []))
    other_interests = set(i.lower() for i in other.get("interests", []))

    shared = sorted(user_interests.intersection(other_interests))

    base = _axis_score(user_mbti, other_mbti)
    interest_score = len(shared) * 5
    total = min(100.0, float(base + interest_score))

    reasons, explanation = generate_match_explanation(user_mbti, other_mbti, shared)

    return {
        "compatibility_score": round(total, 1),
        "shared_interests": shared,
        "reasons": reasons,
        "explanation": explanation,
    }
