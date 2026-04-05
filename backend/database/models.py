from sqlalchemy import Column, String, Integer, Float, DateTime, Text, ForeignKey, Boolean
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime
import uuid

Base = declarative_base()

class User(Base):
    __tablename__ = "users"
    
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    email = Column(String(255), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    first_name = Column(String(100))
    last_name = Column(String(100))
    age = Column(Integer)
    bio = Column(Text)
    location = Column(String(255))
    completed_onboarding = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class TraitVector(Base):
    __tablename__ = "trait_vectors"
    
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), unique=True, nullable=False)
    introversion_extraversion = Column(Float, nullable=False)  # 0-1, where 1 = extraverted
    intuition_sensing = Column(Float, nullable=False)  # 0-1, where 1 = intuition
    thinking_feeling = Column(Float, nullable=False)  # 0-1, where 1 = feeling
    judging_perceiving = Column(Float, nullable=False)  # 0-1, where 1 = perceiving
    communication_style = Column(Float, nullable=False)  # 0-1, where 1 = direct
    confidence = Column(Float, nullable=False)  # Model confidence score (0-1)
    generated_at = Column(DateTime, default=datetime.utcnow)

class AssessmentQuestion(Base):
    __tablename__ = "assessment_questions"
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    question_text = Column(Text, nullable=False)
    trait_dimension = Column(String(100), nullable=False)  # Which trait this question targets
    question_order = Column(Integer, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)

class AssessmentResponse(Base):
    __tablename__ = "assessment_responses"
    
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    question_id = Column(Integer, ForeignKey("assessment_questions.id"), nullable=False)
    response_text = Column(Text, nullable=False)
    response_score = Column(Float, nullable=True)  # 0-1 score for this question
    created_at = Column(DateTime, default=datetime.utcnow)

class CompatibilityMatch(Base):
    __tablename__ = "compatibility_matches"
    
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id_1 = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    user_id_2 = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    compatibility_score = Column(Float, nullable=False)  # 0-100
    explanation = Column(Text, nullable=True)
    computed_at = Column(DateTime, default=datetime.utcnow)
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    question_id = Column(Integer, ForeignKey("assessment_questions.id"), nullable=False)
    response_text = Column(Text, nullable=False)
    response_score = Column(Float, nullable=True)  # 0-1 score for this question
    created_at = Column(DateTime, default=datetime.utcnow)

class CompatibilityMatch(Base):
    __tablename__ = "compatibility_matches"
    
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    user_id_1 = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    user_id_2 = Column(String(36), ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    compatibility_score = Column(Float, nullable=False)  # 0-100
    explanation = Column(Text, nullable=True)
    computed_at = Column(DateTime, default=datetime.utcnow)
