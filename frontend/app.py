import streamlit as st
import requests
import os
from dotenv import load_dotenv
import json

# Load environment variables
load_dotenv()

# Configuration
BACKEND_API_URL = os.getenv('BACKEND_API_URL', 'http://localhost:8000/api')
st.set_page_config(
    page_title="Vynq 👀 - Personality-Based Dating",
    page_icon="👀",
    layout="wide",
    initial_sidebar_state="expanded"
)

# Initialize session state
if 'token' not in st.session_state:
    st.session_state.token = None
if 'user_id' not in st.session_state:
    st.session_state.user_id = None
if 'questions' not in st.session_state:
    st.session_state.questions = []
if 'current_q' not in st.session_state:
    st.session_state.current_q = 0
if 'responses' not in st.session_state:
    st.session_state.responses = {}
if 'traits' not in st.session_state:
    st.session_state.traits = None
if 'matches' not in st.session_state:
    st.session_state.matches = None

# Helper function to get auth headers
def get_auth_headers():
    if st.session_state.token:
        return {"Authorization": f"Bearer {st.session_state.token}"}
    return {}

# Custom styling with colors
st.markdown("""
<style>
    :root {
        --color-gold: #fbb040;
        --color-lavender: #9555ff;
        --color-white: #ffffff;
    }
    
    .main {
        background: linear-gradient(135deg, #fffbf0 0%, #f9f7ff 100%);
    }
    
    .stButton>button {
        background: linear-gradient(135deg, #fbb040 0%, #9555ff 100%);
        color: white;
        border: none;
        border-radius: 0.5rem;
        padding: 0.5rem 1rem;
        font-weight: 600;
    }
    
    .stButton>button:hover {
        background: linear-gradient(135deg, #9555ff 0%, #fbb040 100%);
    }
    
    h1, h2, h3 {
        background: linear-gradient(135deg, #fbb040 0%, #9555ff 100%);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
    }
</style>
""", unsafe_allow_html=True)

# Header with authentication
col1, col2 = st.columns([3, 1])
with col1:
    st.title("Vynq 👀")
    st.markdown("**Where Personality Meets Connection** — Pronounced 'wink'")
with col2:
    if st.session_state.token:
        if st.button("Logout", use_container_width=True):
            st.session_state.token = None
            st.session_state.user_id = None
            st.rerun()
    else:
        st.write("")

# Show login/signup if not authenticated
if not st.session_state.token:
    st.markdown("---")
    st.header("Welcome to Vynq!")
    
    tab1, tab2 = st.tabs(["🔐 Login", "📝 Sign Up"])
    
    with tab1:
        st.write("Login to your account")
        email = st.text_input("Email", key="login_email")
        password = st.text_input("Password", type="password", key="login_pass")
        
        if st.button("Login", use_container_width=True, key="login_btn"):
            try:
                response = requests.post(
                    f'{BACKEND_API_URL}/auth/login',
                    json={"email": email, "password": password},
                    timeout=5
                )
                if response.status_code == 200:
                    data = response.json()
                    st.session_state.token = data['access_token']
                    st.session_state.user_id = data['user_id']
                    st.success("Logged in successfully!")
                    st.rerun()
                else:
                    st.error("Invalid email or password")
            except Exception as e:
                st.error(f"Login error: {e}")
    
    with tab2:
        st.write("Create a new account")
        email = st.text_input("Email", key="signup_email")
        password = st.text_input("Password", type="password", key="signup_pass")
        first_name = st.text_input("First Name", key="signup_first")
        last_name = st.text_input("Last Name", key="signup_last")
        
        if st.button("Sign Up", use_container_width=True, key="signup_btn"):
            try:
                response = requests.post(
                    f'{BACKEND_API_URL}/auth/signup',
                    json={
                        "email": email,
                        "password": password,
                        "first_name": first_name,
                        "last_name": last_name
                    },
                    timeout=5
                )
                if response.status_code == 200:
                    data = response.json()
                    st.session_state.token = data['access_token']
                    st.session_state.user_id = data['user_id']
                    st.success("Account created! Logging in...")
                    st.rerun()
                else:
                    st.error("Signup failed. Email may already be registered.")
            except Exception as e:
                st.error(f"Signup error: {e}")
    
    st.stop()

# Navigation in sidebar (only after login)
page = st.sidebar.radio("Navigate", [
    "🏠 Home",
    "🧠 Assessment",
    "💕 Matches",
    "👤 Profile"
])

# ==================== HOME PAGE ====================
if page == "🏠 Home":
    st.markdown("---")
    st.write("""
    ### Skip the Endless Swiping
    
    Answer thoughtful questions about who you really are, and find people who truly understand you.
    
    Vynq uses AI-powered personality analysis to match you with compatible people based on:
    - Communication style
    - Emotional tendencies  
    - Life approach and values
    - Decision-making preferences
    """)
    
    st.write("---")
    col1, col2, col3 = st.columns(3)
    
    with col1:
        st.markdown("### 🧠 Personality Assessment")
        st.write("Answer ~20 thoughtfully designed questions that capture your true self.")
    
    with col2:
        st.markdown("### 📊 Trait Vectors")
        st.write("Get your unique personality profile based on MBTI-inspired analysis.")
    
    with col3:
        st.markdown("### 🎯 Smart Matching")
        st.write("Find matches ranked by genuine psychological compatibility.")
    
    st.write("---")
    col1, col2 = st.columns(2)
    with col1:
        if st.button("🚀 Start Assessment", key="home_btn", use_container_width=True):
            st.session_state.page = "Assessment"
            st.rerun()
    with col2:
        st.button("Learn More", key="learn_btn", use_container_width=True)

# ==================== ASSESSMENT PAGE ====================
elif page == "🧠 Assessment":
    st.markdown("---")
    st.header("Personality Assessment")
    st.write("Answer ~20 questions to discover your personality traits and find your matches.")
    
    st.write("---")
    
    # Load questions button
    if not st.session_state.questions and st.button("Load Assessment", use_container_width=True):
        try:
            response = requests.get(
                f'{BACKEND_API_URL}/onboarding/questions',
                timeout=5
            )
            if response.status_code == 200:
                st.session_state.questions = response.json()
                st.session_state.current_q = 0
                st.session_state.responses = {}
                st.rerun()
            else:
                st.error("Failed to load questions")
        except Exception as e:
            st.error(f"Error loading questions: {e}")
    
    if st.session_state.questions:
        total_q = len(st.session_state.questions)
        current_idx = st.session_state.current_q
        
        progress = st.progress((current_idx + 1) / total_q)
        st.write(f"Question {current_idx + 1} of {total_q}")
        
        question = st.session_state.questions[current_idx]
        q_id = str(question.get('id', current_idx))
        
        st.markdown(f"### {question.get('text', 'Question')}")
        
        # Answer input based on question type
        q_type = question.get('type', 'text')
        
        if q_type == 'single_choice' and question.get('options'):
            answer = st.radio(
                "Choose an option:",
                question.get('options', []),
                key=f"q_{current_idx}"
            )
        elif q_type == 'likert_scale':
            answer = st.slider(
                "Rate your agreement:",
                1, 5,
                value=3,
                key=f"q_{current_idx}"
            )
            answer = str(answer)
        else:
            answer = st.text_area(
                "Your answer:",
                key=f"q_{current_idx}",
                height=100
            )
        
        col1, col2, col3 = st.columns(3)
        
        with col1:
            if st.button("← Previous", key="prev_btn", use_container_width=True):
                if st.session_state.current_q > 0:
                    st.session_state.responses[q_id] = answer
                    st.session_state.current_q -= 1
                    st.rerun()
        
        with col2:
            if st.button("Next →", key="next_btn", use_container_width=True):
                st.session_state.responses[q_id] = answer
                if st.session_state.current_q < len(st.session_state.questions) - 1:
                    st.session_state.current_q += 1
                    st.rerun()
                else:
                    st.info("All questions answered! Click 'Submit & Get Results' to finish.")
        
        with col3:
            if st.button("Submit & Get Results", key="submit_btn", use_container_width=True):
                if not answer:
                    st.warning("Please answer the current question first")
                else:
                    st.session_state.responses[q_id] = answer
                    
                    try:
                        response = requests.post(
                            f'{BACKEND_API_URL}/onboarding/submit-assessment',
                            json=st.session_state.responses,
                            headers=get_auth_headers(),
                            timeout=10
                        )
                        if response.status_code == 200:
                            results = response.json()
                            st.session_state.traits = results
                            st.session_state.questions = []
                            st.success("Assessment submitted! Your traits have been calculated.")
                            st.balloons()
                            st.rerun()
                        else:
                            st.error(f"Failed to submit: {response.text}")
                    except Exception as e:
                        st.error(f"Error: {e}")
    
    else:
        st.info("Click 'Load Assessment' to start!")
    
    # Show trait results if available
    if st.session_state.traits:
        st.markdown("---")
        st.header("Your Personality Profile")
        
        traits = st.session_state.traits
        col1, col2 = st.columns(2)
        
        with col1:
            st.write("**Social Energy: Introversion ↔ Extraversion**")
            st.progress(traits.get('introversion_extraversion', 0.5))
            st.caption(f"{traits.get('introversion_extraversion', 0.5)*100:.0f}%")
        
        with col2:
            st.write("**Information Processing: Intuition ↔ Sensing**")
            st.progress(traits.get('intuition_sensing', 0.5))
            st.caption(f"{traits.get('intuition_sensing', 0.5)*100:.0f}%")
        
        col1, col2 = st.columns(2)
        
        with col1:
            st.write("**Decision Making: Thinking ↔ Feeling**")
            st.progress(traits.get('thinking_feeling', 0.5))
            st.caption(f"{traits.get('thinking_feeling', 0.5)*100:.0f}%")
        
        with col2:
            st.write("**Life Approach: Judging ↔ Perceiving**")
            st.progress(traits.get('judging_perceiving', 0.5))
            st.caption(f"{traits.get('judging_perceiving', 0.5)*100:.0f}%")
        
        st.write("**Communication Style**")
        st.progress(traits.get('communication_style', 0.5))
        st.caption(f"{traits.get('communication_style', 0.5)*100:.0f}%")

# ==================== MATCHES PAGE ====================
elif page == "💕 Matches":
    st.markdown("---")
    st.header("Your Compatible Matches")
    st.write("Ranked by psychological compatibility")
    
    st.write("---")
    
    col1, col2 = st.columns(2)
    
    with col1:
        if st.button("🔄 Compute Matches", use_container_width=True):
            try:
                response = requests.get(
                    f'{BACKEND_API_URL}/matches/compute',
                    headers=get_auth_headers(),
                    timeout=10
                )
                if response.status_code == 200:
                    result = response.json()
                    st.success(f"Computed matches for {result.get('matches_computed', 0)} users!")
                    st.session_state.matches = None
                    st.rerun()
                else:
                    st.error(response.json().get('detail', 'Failed to compute matches'))
            except Exception as e:
                st.error(f"Error: {e}")
    
    with col2:
        if st.button("📋 Load Matches", use_container_width=True):
            try:
                response = requests.get(
                    f'{BACKEND_API_URL}/matches/?limit=10',
                    headers=get_auth_headers(),
                    timeout=5
                )
                if response.status_code == 200:
                    st.session_state.matches = response.json()
                    st.rerun()
                else:
                    st.error(response.json().get('detail', 'Failed to load matches'))
            except Exception as e:
                st.error(f"Error: {e}")
    
    st.write("---")
    
    if st.session_state.matches:
        if not st.session_state.matches:
            st.info("No matches yet. Try computing matches first!")
        else:
            for match in st.session_state.matches:
                with st.container():
                    col1, col2 = st.columns([3, 1])
                    
                    with col1:
                        name = f"{match.get('match_first_name', 'User')} {match.get('match_last_name', '')}"
                        st.markdown(f"### {name}")
                        st.write(f"**Compatibility: {match.get('compatibility_score', 0):.0f}%**")
                        st.write(f"**Why you match:** {match.get('explanation', 'Great chemistry!')}")
                    
                    with col2:
                        st.metric("Score", f"{match.get('compatibility_score', 0):.0f}%")
                    
                    col1, col2 = st.columns(2)
                    with col1:
                        st.button(f"👁️ View Profile", key=f"prof_{match.get('id')}", use_container_width=True)
                    with col2:
                        st.button(f"💬 Connect", key=f"msg_{match.get('id')}", use_container_width=True)
                    
                    st.divider()
    else:
        st.info("Click 'Load Matches' to see your recommendations (compute first if needed)")

# ==================== PROFILE PAGE ====================
elif page == "👤 Profile":
    st.markdown("---")
    st.header("Your Profile")
    
    # Load profile
    if st.button("Load Profile", use_container_width=True):
        try:
            response = requests.get(
                f'{BACKEND_API_URL}/profiles/me',
                headers=get_auth_headers(),
                timeout=5
            )
            if response.status_code == 200:
                st.session_state.profile = response.json()
                st.rerun()
            else:
                st.error("Failed to load profile")
        except Exception as e:
            st.error(f"Error: {e}")
    
    st.write("---")
    
    # Tabs for profile sections
    tab1, tab2, tab3 = st.tabs(["Basic Info", "Personality Traits", "Account"])
    
    with tab1:
        st.subheader("Basic Information")
        
        profile = st.session_state.get('profile', {})
        
        first_name = st.text_input("First Name", value=profile.get('first_name', ''))
        last_name = st.text_input("Last Name", value=profile.get('last_name', ''))
        age = st.number_input("Age", min_value=18, max_value=100, value=profile.get('age', 26))
        location = st.text_input("Location", value=profile.get('location', ''))
        bio = st.text_area("Bio", value=profile.get('bio', ''), height=100)
        
        if st.button("Save Profile", use_container_width=True):
            try:
                response = requests.put(
                    f'{BACKEND_API_URL}/profiles/me',
                    json={
                        "first_name": first_name,
                        "last_name": last_name,
                        "age": age,
                        "location": location,
                        "bio": bio
                    },
                    headers=get_auth_headers(),
                    timeout=5
                )
                if response.status_code == 200:
                    st.session_state.profile = response.json()
                    st.success("Profile saved!")
                else:
                    st.error("Failed to save profile")
            except Exception as e:
                st.error(f"Error: {e}")
    
    with tab2:
        st.subheader("Your Personality Profile")
        
        profile = st.session_state.get('profile', {})
        traits = profile.get('traits', None)
        
        if not traits:
            st.info("Complete your assessment to see your personality profile")
        else:
            col1, col2 = st.columns(2)
            
            with col1:
                st.write("**Social Energy: Introversion ↔ Extraversion**")
                st.progress(traits.get('introversion_extraversion', 0.5))
                st.caption(f"{traits.get('introversion_extraversion', 0.5)*100:.0f}%")
            
            with col2:
                st.write("**Information Processing: Intuition ↔ Sensing**")
                st.progress(traits.get('intuition_sensing', 0.5))
                st.caption(f"{traits.get('intuition_sensing', 0.5)*100:.0f}%")
            
            col1, col2 = st.columns(2)
            
            with col1:
                st.write("**Decision Making: Thinking ↔ Feeling**")
                st.progress(traits.get('thinking_feeling', 0.5))
                st.caption(f"{traits.get('thinking_feeling', 0.5)*100:.0f}%")
            
            with col2:
                st.write("**Life Approach: Judging ↔ Perceiving**")
                st.progress(traits.get('judging_perceiving', 0.5))
                st.caption(f"{traits.get('judging_perceiving', 0.5)*100:.0f}%")
            
            st.write("**Communication Style**")
            st.progress(traits.get('communication_style', 0.5))
            st.caption(f"{traits.get('communication_style', 0.5)*100:.0f}%")
            
            if st.button("Retake Assessment", use_container_width=True):
                st.session_state.page = "Assessment"
                st.rerun()
    
    with tab3:
        st.subheader("Account Settings")
        
        profile = st.session_state.get('profile', {})
        st.text_input("Email", value=profile.get('email', ''), disabled=True)
        
        st.markdown("---")
        st.write("Danger Zone")
        
        if st.button("Delete Account", use_container_width=True, key="delete_btn"):
            st.error("Account deletion coming soon")

# Footer
st.divider()
st.markdown("""
---
**Vynq 👀** | Psychology-Driven Dating | © 2026 | [GitHub](https://github.com/ayush9085/Vynq)

*Where Personality Meets Connection — Pronounced 'wink'*
""")
