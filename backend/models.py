import numpy as np
from typing import Dict, Tuple, List
import json
from pathlib import Path

class PersonalityModel:
    """
    MBTI-inspired personality model that converts assessment responses to trait vectors.
    
    PLACEHOLDER: This is a simplified implementation. The actual model should be:
    - Pre-trained on personality assessment data
    - Use neural network (PyTorch/TensorFlow) or statistical methods
    - Handle complex response patterns and correlations
    """
    
    def __init__(self):
        self.trait_dimensions = [
            "introversion_extraversion",
            "intuition_sensing",
            "thinking_feeling",
            "judging_perceiving",
            "communication_style"
        ]
        self.confidence = 0.0
        
    def process_responses(self, responses: List[Dict]) -> Dict:
        """
        Convert assessment responses to personality trait vector.
        
        Args:
            responses: List of dicts with question_id and response_text
            
        Returns:
            Dict with trait scores (0-1) and confidence
        """
        # PLACEHOLDER: Simplified scoring logic
        # In production, this would use pre-trained model
        
        traits = {}
        scores = []
        
        for response in responses:
            # Simple word-based scoring (placeholder)
            score = self._score_response(response.get("response_text", ""))
            scores.append(score)
        
        # Map scores to trait dimensions
        if len(scores) >= 20:
            # Simple heuristic: divide scores among trait dimensions
            for i, dimension in enumerate(self.trait_dimensions):
                start_idx = int(i * len(scores) / len(self.trait_dimensions))
                end_idx = int((i + 1) * len(scores) / len(self.trait_dimensions))
                dimension_scores = scores[start_idx:end_idx]
                
                if dimension_scores:
                    traits[dimension] = np.mean(dimension_scores)
                else:
                    traits[dimension] = 0.5  # Default neutral
        else:
            # Default neutral traits if not enough responses
            for dimension in self.trait_dimensions:
                traits[dimension] = 0.5
        
        # Calculate confidence based on response consistency
        self.confidence = self._calculate_confidence(scores)
        
        return traits
    
    def _score_response(self, text: str) -> float:
        """
        Simple scoring heuristic based on response text length and keywords.
        PLACEHOLDER - Replace with pre-trained model scoring.
        """
        if not text:
            return 0.5
        
        # Placeholder: Score based on text characteristics
        # In production: Use neural network or ML model
        keywords_extraverted = ["social", "outgoing", "people", "talk", "engaging", "party"]
        keywords_introverted = ["quiet", "alone", "think", "reflect", "comfort", "home"]
        
        text_lower = text.lower()
        extraverted_count = sum(1 for kw in keywords_extraverted if kw in text_lower)
        introverted_count = sum(1 for kw in keywords_introverted if kw in text_lower)
        
        total = extraverted_count + introverted_count
        if total == 0:
            return 0.5 + np.random.uniform(-0.1, 0.1)  # Random variation
        
        score = extraverted_count / total
        return max(0.0, min(1.0, score))  # Clamp to [0, 1]
    
    def _calculate_confidence(self, scores: List[float]) -> float:
        """
        Calculate model confidence based on response variance.
        PLACEHOLDER - More sophisticated metrics in production.
        """
        if not scores or len(scores) < 5:
            return 0.65
        
        # Confidence based on score variance (less variance = more confident)
        variance = np.var(scores)
        confidence = 1.0 - (variance * 0.5)  # Adjust multiplier as needed
        return max(0.5, min(0.95, confidence))  # Clamp to reasonable range


class MatchingEngine:
    """
    Computes compatibility scores between users based on trait vectors.
    """
    
    @staticmethod
    def compute_compatibility(
        user_traits: Dict[str, float],
        candidate_traits: Dict[str, float],
        weights: Dict[str, float] = None
    ) -> Tuple[float, str]:
        """
        Compute compatibility score between two users.
        
        Args:
            user_traits: User's trait vector (dict with scores 0-1)
            candidate_traits: Candidate's trait vector
            weights: Optional weights for each dimension (default: equal)
            
        Returns:
            Tuple of (compatibility_score 0-100, explanation_string)
        """
        if weights is None:
            weights = {dim: 1.0 for dim in user_traits.keys()}
        
        # Normalize weights
        total_weight = sum(weights.values())
        weights = {k: v / total_weight for k, v in weights.items()}
        
        # Compute weighted Euclidean distance
        distance = 0.0
        for dimension in user_traits.keys():
            user_val = user_traits.get(dimension, 0.5)
            candidate_val = candidate_traits.get(dimension, 0.5)
            weight = weights.get(dimension, 1.0)
            
            distance += weight * ((user_val - candidate_val) ** 2)
        
        distance = np.sqrt(distance)
        
        # Convert distance to compatibility score (0-100)
        # Max possible distance is sqrt(5) for 5 dimensions
        max_distance = np.sqrt(5)
        compatibility_score = (1 - (distance / max_distance)) * 100
        compatibility_score = max(0, min(100, compatibility_score))  # Clamp
        
        # Generate explanation
        explanation = MatchingEngine._generate_explanation(
            user_traits,
            candidate_traits,
            compatibility_score
        )
        
        return compatibility_score, explanation
    
    @staticmethod
    def _generate_explanation(
        user_traits: Dict[str, float],
        candidate_traits: Dict[str, float],
        compatibility_score: float
    ) -> str:
        """Generate human-readable match explanation."""
        explanations = []
        
        # Analyze each dimension
        for dimension in user_traits.keys():
            user_val = user_traits.get(dimension, 0.5)
            candidate_val = candidate_traits.get(dimension, 0.5)
            diff = abs(user_val - candidate_val)
            
            if diff < 0.15:
                # High similarity
                if dimension == "thinking_feeling":
                    explanations.append("Strong emotional alignment")
                elif dimension == "communication_style":
                    explanations.append("Similar communication style")
                elif dimension == "introversion_extraversion":
                    explanations.append("Matching social preferences")
            elif diff > 0.35:
                # High complementarity
                if dimension == "thinking_feeling":
                    explanations.append("Complementary decision-making styles")
                elif dimension == "judging_perceiving":
                    explanations.append("Balance between planning and spontaneity")
        
        # Default explanations if none generated
        if not explanations:
            if compatibility_score > 75:
                explanations.append("Highly compatible personality profiles")
            elif compatibility_score > 50:
                explanations.append("Good personality compatibility")
            else:
                explanations.append("Different personality profiles")
        
        return ", ".join(explanations[:3])  # Return top 3
    
    @staticmethod
    def get_top_matches(
        user_traits: Dict[str, float],
        all_candidates: List[Tuple[str, Dict[str, float]]],
        limit: int = 10
    ) -> List[Dict]:
        """
        Get top matches for a user from all candidates.
        
        Args:
            user_traits: User's trait vector
            all_candidates: List of (user_id, traits_dict) tuples
            limit: Number of top matches to return
            
        Returns:
            Sorted list of match dicts with scores and explanations
        """
        matches = []
        
        for candidate_id, candidate_traits in all_candidates:
            score, explanation = MatchingEngine.compute_compatibility(
                user_traits,
                candidate_traits
            )
            matches.append({
                "user_id": candidate_id,
                "compatibility_score": round(score, 2),
                "explanation": explanation
            })
        
        # Sort by compatibility score (descending)
        matches.sort(key=lambda x: x["compatibility_score"], reverse=True)
        
        return matches[:limit]
