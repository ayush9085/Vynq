"""MBTI Personality Classifier Service"""

import logging
import json
from typing import Tuple, Dict
import numpy as np
import os
from dotenv import load_dotenv

load_dotenv()

logger = logging.getLogger(__name__)

# Pre-defined MBTI patterns for keyword-based classification
# In production, this would use a trained transformer model
MBTI_KEYWORDS = {
    "E": ["social", "outgoing", "talkative", "energetic", "people", "party", "group", "active"],
    "I": ["quiet", "alone", "introspective", "solitude", "reserved", "thoughtful", "independent"],
    "N": ["imagination", "future", "possibilities", "abstract", "theories", "symbols", "patterns"],
    "S": ["practical", "present", "concrete", "facts", "details", "reality", "tangible"],
    "T": ["logical", "objective", "analysis", "truth", "rational", "principles", "justice"],
    "F": ["values", "harmony", "feelings", "compassion", "empathy", "personal", "relationships"],
    "J": ["organized", "planned", "structured", "orderly", "systematic", "decided", "closure"],
    "P": ["spontaneous", "flexible", "adaptable", "open", "curious", "explore", "freedom"],
}

# Mapping of dimensions to MBTI positions
DIMENSIONS = ["EI", "NS", "TF", "JP"]
DIM_MAPPING = {
    "EI": {"E": 1, "I": 0},
    "NS": {"N": 1, "S": 0},
    "TF": {"T": 1, "F": 0},
    "JP": {"J": 1, "P": 0},
}


class MBTIClassifier:
    """MBTI Personality Classifier using KEYWORDS."""
    
    def __init__(self):
        """Initialize the classifier."""
        self.model_loaded = False
        self.model = None
        self.try_load_pretrained()
        
    def try_load_pretrained(self):
        """Attempt to load pre-trained model if available."""
        try:
            model_path = os.getenv("MODEL_PATH", "ml_models/mbti_classifier.joblib")
            if os.path.exists(model_path):
                import joblib
                self.model = joblib.load(model_path)
                self.model_loaded = True
                logger.info(f"✓ Loaded pre-trained MBTI model from {model_path}")
            else:
                logger.info("⚠ Pre-trained MBTI model not found, using keyword-based classification")
        except Exception as e:
            logger.warning(f"⚠ Could not load pre-trained model: {e}")
    
    def predict(self, text: str) -> Tuple[str, float, Dict[str, float]]:
        """
        Predict MBTI type from text.
        
        Args:
            text: User's open-ended assessment responses
            
        Returns:
            Tuple of (mbti_type, confidence, trait_scores)
        """
        try:
            # Use pre-trained model if available
            if self.model_loaded and self.model is not None:
                return self._predict_with_model(text)
            else:
                return self._predict_keyword_based(text)
        except Exception as e:
            logger.error(f"Error in MBTI prediction: {e}")
            # Fallback to neutral type
            return ("ENFP", 0.5, {"E/I": 0.5, "N/S": 0.5, "T/F": 0.5, "J/P": 0.5})
    
    def _predict_keyword_based(self, text: str) -> Tuple[str, float, Dict[str, float]]:
        """Keyword-based MBTI prediction (fallback)."""
        text_lower = text.lower()
        scores = {}
        
        for dim in DIMENSIONS:
            dim_score = 0.5  # neutral
            count = 0
            
            for trait in dim:
                keywords = MBTI_KEYWORDS.get(trait, [])
                trait_matches = sum(text_lower.count(kw) for kw in keywords)
                count += trait_matches
                
                if trait == dim[0]:  # First trait in dimension
                    dim_score += trait_matches * 0.1
                else:  # Second trait
                    dim_score -= trait_matches * 0.1
            
            # Clamp score between 0 and 1
            dim_score = max(0.0, min(1.0, dim_score))
            scores[dim] = dim_score
        
        # Generate MBTI type based on scores
        mbti_type = ""
        for dim in DIMENSIONS:
            score = scores[dim]
            if score > 0.6:
                mbti_type += dim[0]
            elif score < 0.4:
                mbti_type += dim[1]
            else:
                # Neutral - pick randomly or use default
                mbti_type += dim[0]  # Default to first trait
        
        # Calculate confidence based on how strong the preferences are
        confidence = sum(abs(s - 0.5) for s in scores.values()) / len(scores) + 0.3
        confidence = max(0.3, min(1.0, confidence))
        
        logger.info(f"Predicted MBTI: {mbti_type} (confidence: {confidence:.2f})")
        
        return (mbti_type, confidence, scores)
    
    def _predict_with_model(self, text: str) -> Tuple[str, float, Dict[str, float]]:
        """Predict using pre-trained model."""
        try:
            # This assumes the model is a sklearn classifier with predict and predict_proba
            # Real implementation would depend on actual model interface
            prediction = self.model.predict([text])[0]
            confidence = max(self.model.predict_proba([text])[0])
            
            # Calculate trait scores (would be extracted from model)
            scores = {
                "E/I": 0.5,
                "N/S": 0.5,
                "T/F": 0.5,
                "J/P": 0.5,
            }
            
            return (prediction, confidence, scores)
        except Exception as e:
            logger.error(f"Error with pre-trained model: {e}")
            return self._predict_keyword_based(text)


# Global classifier instance
_classifier = None


def get_classifier():
    """Get or create the MBTI classifier."""
    global _classifier
    if _classifier is None:
        _classifier = MBTIClassifier()
    return _classifier


def predict_mbti(text: str) -> Dict:
    """Predict MBTI from text."""
    classifier = get_classifier()
    mbti_type, confidence, trait_scores = classifier.predict(text)
    
    return {
        "mbti_type": mbti_type,
        "confidence": float(confidence),
        "trait_scores": trait_scores,
    }
