from flask import Flask, render_template, request, jsonify, session
from flask_cors import CORS
from dotenv import load_dotenv
import os
import requests
from datetime import datetime

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__, template_folder='templates', static_folder='static')
app.secret_key = os.getenv('SECRET_KEY', 'dev-secret-key-change-in-production')

# CORS configuration
CORS(app, resources={
    r"/api/*": {
        "origins": "*",
        "methods": ["GET", "POST", "PUT", "DELETE"],
        "allow_headers": ["Content-Type", "Authorization"]
    }
})

# Backend API base URL
BACKEND_API_URL = os.getenv('BACKEND_API_URL', 'http://localhost:8000/api')

# ==================== Routes ====================

@app.route('/')
def index():
    """Home page"""
    return render_template('index.html')

@app.route('/onboarding')
def onboarding():
    """Onboarding personality assessment"""
    return render_template('onboarding.html')

@app.route('/profile')
def profile():
    """User profile page"""
    return render_template('profile.html')

@app.route('/matches')
def matches():
    """Matches discovery page"""
    return render_template('matches.html')

@app.route('/health')
def health():
    """Health check"""
    return jsonify({"status": "healthy", "version": "0.1.0"})

# ==================== API Proxy Routes ====================

@app.route('/api/backend-health')
def backend_health():
    """Check if backend is alive"""
    try:
        response = requests.get(f'{BACKEND_API_URL.replace("/api", "")}/health', timeout=5)
        return jsonify(response.json())
    except:
        return jsonify({"status": "offline"}), 503

@app.route('/api/questions')
def get_questions():
    """Get personality assessment questions"""
    try:
        response = requests.get(f'{BACKEND_API_URL}/onboarding/questions')
        return jsonify(response.json())
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/submit-assessment', methods=['POST'])
def submit_assessment():
    """Submit assessment responses"""
    try:
        data = request.json
        response = requests.post(f'{BACKEND_API_URL}/onboarding/submit', json=data)
        return jsonify(response.json())
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/api/matches', methods=['GET'])
def get_matches():
    """Get recommended matches"""
    try:
        limit = request.args.get('limit', 10)
        offset = request.args.get('offset', 0)
        response = requests.get(
            f'{BACKEND_API_URL}/matches',
            params={'limit': limit, 'offset': offset}
        )
        return jsonify(response.json())
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ==================== Error Handlers ====================

@app.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404

@app.errorhandler(500)
def server_error(error):
    return render_template('500.html'), 500

# ==================== Context Processors ====================

@app.context_processor
def inject_config():
    """Inject config into templates"""
    return {
        'backend_url': BACKEND_API_URL,
        'current_year': datetime.now().year,
        'app_name': 'Vynq',
        'app_tagline': 'Where Wink Meets Psychology'
    }

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=3000)
