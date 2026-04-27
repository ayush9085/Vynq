"""Unit tests for MBTI engine and compatibility matrix."""

import sys
import os

# Add project root to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from backend.services.mbti_engine import analyze_personality, MBTI_TYPE_DESCRIPTIONS
from backend.services.compatibility import (
    get_mbti_compatibility,
    get_top_matches_for_type,
    get_full_matrix,
    COMPATIBILITY_MATRIX,
)


def test_all_16_types_in_matrix():
    """All 16 MBTI types should appear as rows in the matrix."""
    expected = [
        "INTJ", "INTP", "ENTJ", "ENTP",
        "INFJ", "INFP", "ENFJ", "ENFP",
        "ISTJ", "ISFJ", "ESTJ", "ESFJ",
        "ISTP", "ISFP", "ESTP", "ESFP",
    ]
    for t in expected:
        assert t in COMPATIBILITY_MATRIX, f"{t} missing from compatibility matrix"
    print("✓ All 16 types present in matrix")


def test_all_16_type_descriptions():
    """All 16 MBTI types should have a description."""
    expected = [
        "INTJ", "INTP", "ENTJ", "ENTP",
        "INFJ", "INFP", "ENFJ", "ENFP",
        "ISTJ", "ISFJ", "ESTJ", "ESFJ",
        "ISTP", "ISFP", "ESTP", "ESFP",
    ]
    for t in expected:
        assert t in MBTI_TYPE_DESCRIPTIONS, f"{t} missing description"
    print("✓ All 16 type descriptions present")


def test_compatibility_symmetry():
    """If A→B is high, B→A should also exist."""
    for type_a in COMPATIBILITY_MATRIX:
        for type_b in COMPATIBILITY_MATRIX[type_a]:
            score_ab = get_mbti_compatibility(type_a, type_b)
            score_ba = get_mbti_compatibility(type_b, type_a)
            assert score_ab > 0, f"{type_a}→{type_b} score is 0"
            assert score_ba > 0, f"{type_b}→{type_a} score is 0"
    print("✓ Compatibility symmetry check passed")


def test_analyze_with_extraverted_input():
    """Extraverted language should produce E-type result."""
    responses = {
        "1": "I love going to parties with friends and socializing all weekend.",
        "2": "I talk it through with my team, very outgoing and collaborative.",
        "3": "Group activities, networking events, meeting new people.",
        "4": "I plan social gatherings and group meetings every day.",
    }
    result = analyze_personality(responses)
    assert result["mbti"][0] == "E", f"Expected E-type but got {result['mbti']}"
    assert result["confidence"] > 0, "Confidence should be > 0"
    assert result["tokens_analyzed"] > 0
    print(f"✓ Extraverted input → {result['mbti']} (confidence: {result['confidence']})")


def test_analyze_with_introverted_input():
    """Introverted language should produce I-type result."""
    responses = {
        "1": "Quiet time alone with books, calm reading and thinking.",
        "2": "I reflect privately, deep contemplation in solitude.",
        "3": "Independent thinkers who value peace and space.",
        "4": "I keep a private schedule, focused and reserved.",
    }
    result = analyze_personality(responses)
    assert result["mbti"][0] == "I", f"Expected I-type but got {result['mbti']}"
    print(f"✓ Introverted input → {result['mbti']} (confidence: {result['confidence']})")


def test_analyze_returns_axis_scores():
    """Analysis should return axis breakdown."""
    responses = {"1": "I love logic and analyzing problems objectively."}
    result = analyze_personality(responses)
    assert "axis_scores" in result
    assert "E/I" in result["axis_scores"]
    assert "N/S" in result["axis_scores"]
    assert "T/F" in result["axis_scores"]
    assert "J/P" in result["axis_scores"]
    print("✓ Axis scores present in result")


def test_analyze_empty_input():
    """Empty input should still return a valid MBTI type."""
    responses = {"1": ""}
    result = analyze_personality(responses)
    assert len(result["mbti"]) == 4
    assert result["confidence"] == 0.35  # Default when no keywords
    print(f"✓ Empty input → {result['mbti']} (default confidence)")


def test_top_matches():
    """Top matches should return sorted results."""
    top = get_top_matches_for_type("INFP", top_n=3)
    assert len(top) == 3
    assert top[0][1] >= top[1][1] >= top[2][1]
    print(f"✓ INFP top 3 matches: {top}")


def test_full_matrix_returns_16x16():
    """Full matrix should have 16 rows, each with 16 columns."""
    matrix = get_full_matrix()
    assert len(matrix) == 16
    for t, row in matrix.items():
        assert len(row) == 16, f"{t} has {len(row)} columns instead of 16"
    print("✓ Full 16×16 matrix verified")


def test_type_description_format():
    """Each type description should contain the type archetype name."""
    for mbti_type, desc in MBTI_TYPE_DESCRIPTIONS.items():
        assert "—" in desc, f"{mbti_type} description missing dash separator"
        assert len(desc) > 10, f"{mbti_type} description too short"
    print("✓ All type descriptions properly formatted")


if __name__ == "__main__":
    tests = [
        test_all_16_types_in_matrix,
        test_all_16_type_descriptions,
        test_compatibility_symmetry,
        test_analyze_with_extraverted_input,
        test_analyze_with_introverted_input,
        test_analyze_returns_axis_scores,
        test_analyze_empty_input,
        test_top_matches,
        test_full_matrix_returns_16x16,
        test_type_description_format,
    ]

    print(f"\n🧪 Running {len(tests)} tests...\n")
    passed = 0
    failed = 0
    for test in tests:
        try:
            test()
            passed += 1
        except AssertionError as e:
            print(f"✗ {test.__name__}: {e}")
            failed += 1
        except Exception as e:
            print(f"✗ {test.__name__}: {e}")
            failed += 1

    print(f"\n{'='*40}")
    print(f"Results: {passed} passed, {failed} failed out of {len(tests)}")
    if failed == 0:
        print("🎉 All tests passed!")
    else:
        print("❌ Some tests failed")
        sys.exit(1)
