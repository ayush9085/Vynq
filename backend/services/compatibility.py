"""MBTI compatibility matrix — scientifically grounded pairing scores."""

# 16×16 matrix: row = user type, column = match type
# Scores 0-100 representing theoretical compatibility
# Based on cognitive function stack complementarity
COMPATIBILITY_MATRIX: dict[str, dict[str, int]] = {
    "INFP": {"ENFJ": 95, "ENTJ": 90, "INFJ": 85, "INTJ": 85, "ENFP": 80, "ENTP": 80, "INFP": 75, "INTP": 75, "ISFP": 60, "ESFP": 55, "ISTP": 50, "ESTP": 50, "ISFJ": 55, "ESFJ": 55, "ISTJ": 45, "ESTJ": 45},
    "ENFP": {"INTJ": 95, "INFJ": 90, "ENTJ": 85, "INTP": 85, "ENFJ": 80, "ENTP": 80, "ENFP": 75, "INFP": 75, "ESFP": 60, "ISFP": 55, "ESTP": 50, "ISTP": 50, "ESFJ": 55, "ISFJ": 55, "ESTJ": 45, "ISTJ": 45},
    "INFJ": {"ENTP": 95, "ENFP": 90, "INTJ": 85, "INTP": 85, "ENFJ": 80, "ENTJ": 80, "INFJ": 75, "INFP": 75, "ISFJ": 60, "ESFJ": 55, "ISTJ": 50, "ESTJ": 50, "ISFP": 55, "ESFP": 55, "ISTP": 45, "ESTP": 45},
    "ENFJ": {"INFP": 95, "ISFP": 88, "ENFP": 85, "INTJ": 82, "ENTJ": 80, "INTP": 78, "ENFJ": 75, "INFJ": 80, "ESFJ": 60, "ISFJ": 55, "ESTJ": 50, "ISTJ": 50, "ESFP": 55, "ESTP": 50, "ISTP": 45, "ENTP": 72},
    "INTP": {"ENTJ": 95, "ESTJ": 80, "ENFJ": 85, "INFJ": 85, "ENTP": 80, "INTJ": 80, "INTP": 75, "INFP": 75, "ISTP": 60, "ESTP": 55, "ISTJ": 55, "ISFJ": 50, "ISFP": 50, "ESFP": 45, "ESFJ": 45, "ENFP": 85},
    "ENTP": {"INFJ": 95, "INTJ": 90, "ENFJ": 85, "ENTJ": 82, "ENFP": 80, "INTP": 80, "ENTP": 75, "INFP": 75, "ESTP": 60, "ISTP": 55, "ESFP": 50, "ISFP": 50, "ESTJ": 50, "ISTJ": 50, "ESFJ": 45, "ISFJ": 45},
    "INTJ": {"ENFP": 95, "ENTP": 90, "INFJ": 85, "ENTJ": 82, "INFP": 80, "INTP": 80, "INTJ": 75, "ENFJ": 78, "ISTJ": 60, "ESTJ": 55, "ISTP": 55, "ESTP": 50, "ISFJ": 50, "ESFJ": 45, "ISFP": 50, "ESFP": 45},
    "ENTJ": {"INTP": 95, "INFP": 90, "ENTP": 85, "INTJ": 82, "ENFJ": 80, "ENFP": 80, "ENTJ": 75, "INFJ": 78, "ESTJ": 60, "ISTJ": 55, "ESTP": 55, "ISTP": 50, "ESFJ": 50, "ISFJ": 45, "ESFP": 50, "ISFP": 45},
    "ISFP": {"ENFJ": 90, "ESFJ": 80, "ESTJ": 78, "ENTJ": 75, "ISFJ": 70, "ESFP": 70, "ISFP": 65, "INFP": 65, "ISTP": 60, "ESTP": 60, "INTJ": 55, "INFJ": 55, "INTP": 50, "ENTP": 50, "ENFP": 55, "ISTJ": 60},
    "ESFP": {"ISFJ": 85, "ISTJ": 82, "ENFJ": 78, "ESFJ": 75, "ESTP": 70, "ISFP": 70, "ESFP": 65, "ISTP": 65, "ENFP": 60, "INFP": 55, "ENTJ": 55, "INTJ": 50, "ENTP": 50, "INTP": 45, "INFJ": 55, "ESTJ": 65},
    "ISTP": {"ESFJ": 85, "ESTJ": 80, "ISFJ": 75, "ESTP": 72, "ISTJ": 70, "ISFP": 65, "ISTP": 65, "ESFP": 65, "ENTJ": 55, "INTJ": 55, "ENTP": 55, "INTP": 55, "ENFJ": 50, "INFJ": 45, "ENFP": 50, "INFP": 45},
    "ESTP": {"ISFJ": 85, "ISTJ": 82, "ESFJ": 78, "ESTJ": 75, "ISTP": 72, "ESFP": 70, "ESTP": 65, "ISFP": 65, "ENTJ": 55, "ENTP": 55, "INTJ": 50, "INTP": 50, "ENFJ": 50, "ENFP": 50, "INFJ": 45, "INFP": 45},
    "ISFJ": {"ESTP": 85, "ESFP": 85, "ESTJ": 80, "ISTJ": 78, "ESFJ": 75, "ISFP": 70, "ISFJ": 65, "ISTP": 65, "ENFJ": 60, "INFJ": 55, "ENFP": 55, "INFP": 55, "ENTJ": 50, "INTJ": 45, "ENTP": 45, "INTP": 45},
    "ESFJ": {"ISTP": 85, "ISFP": 82, "ISTJ": 80, "ESTJ": 78, "ISFJ": 75, "ESFP": 70, "ESFJ": 65, "ESTP": 65, "ENFJ": 60, "INFJ": 55, "ENFP": 55, "INFP": 55, "ENTJ": 50, "INTJ": 45, "ENTP": 45, "INTP": 45},
    "ISTJ": {"ESFP": 85, "ESTP": 82, "ISFJ": 78, "ESTJ": 75, "ESFJ": 72, "ISTP": 70, "ISTJ": 65, "ISFP": 65, "INTJ": 60, "ENTJ": 55, "INTP": 50, "ENTP": 50, "INFJ": 50, "ENFJ": 50, "INFP": 45, "ENFP": 45},
    "ESTJ": {"INTP": 82, "ISTP": 80, "ISFP": 78, "ISTJ": 75, "ESFJ": 72, "ESTP": 70, "ESTJ": 65, "ISFJ": 65, "ENTJ": 60, "INTJ": 55, "ENTP": 55, "ENFJ": 50, "INFJ": 50, "ENFP": 50, "INFP": 45, "ESFP": 65},
}


def get_mbti_compatibility(type_a: str, type_b: str) -> int:
    """Get compatibility score between two MBTI types from the matrix."""
    type_a = type_a.upper()
    type_b = type_b.upper()
    row = COMPATIBILITY_MATRIX.get(type_a, {})
    return row.get(type_b, 50)  # Default 50 if not found


def get_top_matches_for_type(mbti_type: str, top_n: int = 5) -> list[tuple[str, int]]:
    """Get the top N most compatible types for a given MBTI type."""
    mbti_type = mbti_type.upper()
    row = COMPATIBILITY_MATRIX.get(mbti_type, {})
    sorted_matches = sorted(row.items(), key=lambda x: x[1], reverse=True)
    return sorted_matches[:top_n]


def get_full_matrix() -> dict[str, dict[str, int]]:
    """Return the full 16×16 compatibility matrix."""
    return COMPATIBILITY_MATRIX
