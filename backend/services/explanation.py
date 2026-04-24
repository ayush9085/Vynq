def generate_match_explanation(
    user_mbti: str,
    match_mbti: str,
    shared_interests: list[str],
) -> tuple[list[str], str]:
    reasons: list[str] = []

    if user_mbti[0] != match_mbti[0]:
        reasons.append("Your social energies complement each other well.")
    if user_mbti[1] == match_mbti[1]:
        reasons.append("You both think about the world in a similar abstract/concrete style.")
    if user_mbti[2] != match_mbti[2]:
        reasons.append("Your logical and emotional styles balance each other.")
    if user_mbti[3] == match_mbti[3]:
        reasons.append("Your approach to planning and lifestyle rhythm is aligned.")

    if shared_interests:
        if len(shared_interests) == 1:
            reasons.append(f"You both enjoy {shared_interests[0]}, adding a natural connection.")
        else:
            interest_text = ", ".join(shared_interests[:-1]) + f" and {shared_interests[-1]}"
            reasons.append(f"You share interests in {interest_text}, which strengthens compatibility.")

    if not reasons:
        reasons.append("Your profiles show a balanced potential with room to discover chemistry.")

    paragraph = " ".join(reasons)
    return reasons, paragraph
