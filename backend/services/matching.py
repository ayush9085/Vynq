"""
Matching Engine Service
Calculates compatibility scores between users based on MBTI and interests
"""

import logging
from typing import List, Dict, Tuple
from database.models import MatchResult

logger = logging.getLogger(__name__)

class MatchingEngine:
    """Algorithm for calculating MBTI compatibility"""
    
    # MBTI Trait compatibility rules
    MBTI_TRAITS = {
        "E_I": {"opposite": True, "score": 25},      # Extroversion/Introversion - opposite is better
        "N_S": {"opposite": False, "score": 25},     # Intuition/Sensing - same is better
        "T_F": {"opposite": True, "score": 25},      # Thinking/Feeling - opposite is better
        "J_P": {"opposite": False, "score": 25}      # Judging/Perceiving - same is better
    }
    
    INTEREST_SCORE_PER_MATCH = 5  # Points per shared interest
    MAX_SCORE = 100
    
    @staticmethod
    def parse_mbti(mbti_type: str) -> Dict[str, str]:
        """
        Parse MBTI type into individual traits
        
        Args:
            mbti_type: e.g., "ENFP"
        
        Returns:
            Dict with keys "E_I", "N_S", "T_F", "J_P"
        """
        if len(mbti_type) != 4:
            raise ValueError(f"Invalid MBTI type: {mbti_type}")
        
        return {
            "E_I": mbti_type[0],
            "N_S": mbti_type[1],
            "T_F": mbti_type[2],
            "J_P": mbti_type[3]
        }
    
    @staticmethod
    def calculate_trait_compatibility(user_trait: str, match_trait: str, 
                                     trait_key:str) -> float:
        """
        Calculate compatibility score for a single trait
        
        Args:
            user_trait: User's trait (e.g., "E")
            match_trait: Match's trait (e.g., "I")
            trait_key: Trait key (e.g., "E_I")
        
        Returns:
            Score (0-25)
        """
        rule = MatchingEngine.MBTI_TRAITS[trait_key]
        base_score = rule["score"]
        
        if user_trait == match_trait:
            # Same trait
            if not rule["opposite"]:
                return base_score  # Good match
            else:
                return 0  # Not ideal
        else:
            # Different trait
            if rule["opposite"]:
                return base_score  # Good match
            else:
                return 0  # Not ideal
    
    @staticmethod
    def calculate_mbti_compatibility(user_mbti: str, match_mbti: str) -> Tuple[float, List[str]]:
        """
        Calculate MBTI compatibility score
        
        Args:
            user_mbti: User's MBTI type
            match_mbti: Match's MBTI type
        
        Returns:
            Tuple of (score, reasons)
        """
        try:
            user_traits = MatchingEngine.parse_mbti(user_mbti)
            match_traits = MatchingEngine.parse_mbti(match_mbti)
        except ValueError as e:
            logger.error(f"Invalid MBTI type: {e}")
            return 0, ["Invalid MBTI type"]
        
        total_score = 0
        reasons = []
        
        # E/I compatibility
        ei_score = MatchingEngine.calculate_trait_compatibility(
            user_traits["E_I"], match_traits["E_I"], "E_I"
        )
        total_score += ei_score
        if ei_score > 0:
            if user_traits["E_I"] != match_traits["E_I"]:
                reasons.append("Complementary social traits (Extrovert/Introvert balance)")
            else:
                reasons.append("Similar social preferences")
        
        # N/S compatibility
        ns_score = MatchingEngine.calculate_trait_compatibility(
            user_traits["N_S"], match_traits["N_S"], "N_S"
        )
        total_score += ns_score
        if ns_score > 0:
            if user_traits["N_S"] == match_traits["N_S"]:
                reasons.append("Aligned thinking style (both intuitive or both practical)")
            else:
                reasons.append("Different thinking styles")
        
        # T/F compatibility
        tf_score = MatchingEngine.calculate_trait_compatibility(
            user_traits["T_F"], match_traits["T_F"], "T_F"
        )
        total_score += tf_score
        if tf_score > 0:
            if user_traits["T_F"] != match_traits["T_F"]:
                reasons.append("Complementary decision-making styles")
            else:
                reasons.append("Similar values and priorities")
        
        # J/P compatibility
        jp_score = MatchingEngine.calculate_trait_compatibility(
            user_traits["J_P"], match_traits["J_P"], "J_P"
        )
        total_score += jp_score
        if jp_score > 0:
            if user_traits["J_P"] == match_traits["J_P"]:
                reasons.append("Aligned lifestyle preferences")
            else:
                reasons.append("Different but complementary lifestyles")
        
        return total_score, reasons
    
    @staticmethod
    def calculate_interest_compatibility(user_interests: List[str], 
                                        match_interests: List[str]) -> Tuple[float, List[str]]:
        """
        Calculate interest compatibility score
        
        Args:
            user_interests: User's interests
            match_interests: Match's interests
        
        Returns:
            Tuple of (score, common_interests)
        """
        user_set = set(interest.lower() for interest in user_interests)
        match_set = set(interest.lower() for interest in match_interests)
        
        common = user_set.intersection(match_set)
        score = len(common) * MatchingEngine.INTEREST_SCORE_PER_MATCH
        
        return min(score, 100), list(common)  # Cap at 100
    
    @staticmethod
    def calculate_total_compatibility(user_mbti: str, user_interests: List[str],
                                     match_mbti: str, match_interests: List[str]) -> Tuple[float, List[str]]:
        """
        Calculate total compatibility score (0-100)
        
        Args:
            user_mbti: User's MBTI type
            user_interests: User's interests
            match_mbti: Match's MBTI type
            match_interests: Match's interests
        
        Returns:
            Tuple of (total_score, all_reasons)
        """
        # Calculate MBTI compatibility (0-100)
        mbti_score, mbti_reasons = MatchingEngine.calculate_mbti_compatibility(user_mbti, match_mbti)
        
        # Calculate interest compatibility (0-100)
        interest_score, common_interests = MatchingEngine.calculate_interest_compatibility(
            user_interests, match_interests
        )
        
        # Average the scores
        total_score = (mbti_score + interest_score) / 2
        
        # Build reasons list
        all_reasons = mbti_reasons.copy()
        if common_interests:
            all_reasons.append(f"Shared interests: {', '.join(common_interests)}")
        
        return total_score, all_reasons


def find_matches(current_user: Dict, all_users: List[Dict], limit: int = 10) -> List[Dict]:
    """
    Find best matches for current user
    
    Args:
        current_user: Current user document from DB
        all_users: List of other users (excluding current user)
        limit: Maximum number of matches to return
    
    Returns:
        List of match results, sorted by compatibility score
    """
    matches = []
    
    for match_user in all_users:
        if match_user["_id"] == current_user["_id"]:
            continue  # Skip self
        
        if not match_user.get("mbti"):
            continue  # Skip users without MBTI
        
        # Calculate compatibility
        score, reasons = MatchingEngine.calculate_total_compatibility(
            current_user["mbti"],
            current_user.get("interests", []),
            match_user["mbti"],
            match_user.get("interests", [])
        )
        
        match_result = {
            "match_user_id": str(match_user["_id"]),
            "name": f"{match_user['first_name']} {match_user['last_name']}",
            "age": match_user.get("age"),
            "gender": match_user.get("gender"),
            "mbti": match_user["mbti"],
            "interests": match_user.get("interests", []),
            "compatibility_score": round(score, 1),
            "match_reasons": reasons[:3],  # Top 3 reasons
            "user_bio": match_user.get("bio")
        }
        
        matches.append(match_result)
    
    # Sort by compatibility score descending
    matches.sort(key=lambda x: x["compatibility_score"], reverse=True)
    
    return matches[:limit]
