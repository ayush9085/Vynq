import streamlit as st
import requests
import os
from dotenv import load_dotenv

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

# Header
col1, col2 = st.columns([3, 1])
with col1:
    st.title("Vynq 👀")
    st.markdown("**Where Personality Meets Connection** — Pronounced 'wink'")
with col2:
    st.write("")

# Navigation in sidebar
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
    
    # Session state for questions
    if 'questions' not in st.session_state:
        st.session_state.questions = []
        st.session_state.current_q = 0
        st.session_state.responses = []
    
    # Load questions button
    if st.button("Load Assessment", use_container_width=True):
        try:
            response = requests.get(f'{BACKEND_API_URL}/questions', timeout=5)
            if response.status_code == 200:
                st.session_state.questions = response.json()
                st.success(f"Loaded {len(st.session_state.questions)} questions!")
        except Exception as e:
            st.error(f"Failed to load questions: {e}")
    
    if st.session_state.questions:
        progress = st.progress((st.session_state.current_q + 1) / len(st.session_state.questions))
        st.write(f"Question {st.session_state.current_q + 1} of {len(st.session_state.questions)}")
        
        question = st.session_state.questions[st.session_state.current_q]
        st.markdown(f"### {question.get('text', 'Question')}")
        
        # Answer input
        answer = st.text_area("Your answer:", key=f"q_{st.session_state.current_q}", height=100)
        
        col1, col2, col3 = st.columns(3)
        
        with col1:
            if st.button("← Previous", key="prev_btn", use_container_width=True):
                if st.session_state.current_q > 0:
                    st.session_state.current_q -= 1
                    st.rerun()
        
        with col2:
            if st.button("Next →", key="next_btn", use_container_width=True):
                st.session_state.responses.append({"question_id": question.get('id'), "response": answer})
                if st.session_state.current_q < len(st.session_state.questions) - 1:
                    st.session_state.current_q += 1
                    st.rerun()
                else:
                    st.success("Assessment complete!")
        
        with col3:
            if st.button("Submit & Get Results", key="submit_btn", use_container_width=True):
                try:
                    response = requests.post(
                        f'{BACKEND_API_URL}/submit-assessment',
                        json=st.session_state.responses,
                        timeout=10
                    )
                    if response.status_code == 200:
                        results = response.json()
                        st.session_state.traits = results
                        st.success("Assessment submitted!")
                        st.balloons()
                    else:
                        st.error("Failed to submit assessment")
                except Exception as e:
                    st.error(f"Error: {e}")
    
    else:
        st.info("Click 'Load Assessment' to start!")

# ==================== MATCHES PAGE ====================
elif page == "💕 Matches":
    st.markdown("---")
    st.header("Your Compatible Matches")
    st.write("Ranked by psychological compatibility")
    
    st.write("---")
    
    # Filters
    col1, col2 = st.columns(2)
    with col1:
        search = st.text_input("Search by name...")
    with col2:
        sort_by = st.selectbox("Sort by", ["Highest Compatibility", "Newest First"])
    
    if st.button("Load Matches", use_container_width=True):
        try:
            response = requests.get(f'{BACKEND_API_URL}/matches?limit=10', timeout=5)
            if response.status_code == 200:
                matches = response.json().get('matches', [])
                
                if not matches:
                    st.info("No matches yet. Complete your assessment first!")
                else:
                    for match in matches:
                        with st.container():
                            col1, col2 = st.columns([3, 1])
                            
                            with col1:
                                st.markdown(f"### {match.get('name', 'User')}, {match.get('age', 'N/A')}")
                                st.write(f"📍 {match.get('location', 'Unknown')}")
                                st.write(f"**Why you'd click:** {match.get('explanation', 'Great chemistry!')}")
                                st.write(match.get('bio', 'No bio available'))
                            
                            with col2:
                                compatibility = match.get('compatibility_score', 0)
                                st.metric("Compatibility", f"{int(compatibility)}%")
                            
                            col1, col2 = st.columns(2)
                            with col1:
                                st.button(f"💬 Message", key=f"msg_{match.get('user_id')}", use_container_width=True)
                            with col2:
                                st.button(f"👁️ Profile", key=f"prof_{match.get('user_id')}", use_container_width=True)
                            
                            st.divider()
            else:
                st.error("Failed to load matches")
        except Exception as e:
            st.error(f"Error: {e}")
    else:
        st.info("Click 'Load Matches' to see your recommendations")

# ==================== PROFILE PAGE ====================
elif page == "👤 Profile":
    st.markdown("---")
    st.header("Your Profile")
    st.write("---")
    
    # Tabs for profile sections
    tab1, tab2, tab3 = st.tabs(["Basic Info", "Personality Traits", "Account"])
    
    with tab1:
        st.subheader("Basic Information")
        name = st.text_input("Name", value="Alex")
        age = st.number_input("Age", min_value=18, max_value=100, value=26)
        location = st.text_input("Location", value="San Francisco")
        bio = st.text_area("Bio", value="Love hiking, yoga, and trying new restaurants.", height=100)
        
        if st.button("Save Profile", use_container_width=True):
            st.success("Profile saved!")
    
    with tab2:
        st.subheader("Your Personality Profile")
        
        col1, col2 = st.columns(2)
        
        with col1:
            st.write("**Social Energy**")
            st.progress(0.65)
            st.caption("Extraverted (65%)")
        
        with col2:
            st.write("**Information Processing**")
            st.progress(0.42)
            st.caption("Balanced (42%)")
        
        col1, col2 = st.columns(2)
        
        with col1:
            st.write("**Decision Making**")
            st.progress(0.78)
            st.caption("Feeling (78%)")
        
        with col2:
            st.write("**Life Approach**")
            st.progress(0.55)
            st.caption("Balanced (55%)")
        
        st.write("**Communication Style**")
        st.progress(0.60)
        st.caption("Moderately Direct (60%)")
        
        if st.button("Retake Assessment", use_container_width=True):
            st.session_state.page = "Assessment"
            st.rerun()
    
    with tab3:
        st.subheader("Account Settings")
        email = st.text_input("Email", value="alex@example.com")
        
        col1, col2 = st.columns(2)
        with col1:
            if st.button("Change Password", use_container_width=True):
                st.info("Password change feature coming soon")
        with col2:
            if st.button("Delete Account", use_container_width=True):
                st.warning("Are you sure? This is permanent.")
        
        if st.button("Save Settings", use_container_width=True):
            st.success("Settings saved!")

# Footer
st.divider()
st.markdown("""
---
**Vynq 👀** | Psychology-Driven Dating | © 2026 | [GitHub](https://github.com/ayush9085/Vynq)

*Where Personality Meets Connection — Pronounced 'wink'*
""")
