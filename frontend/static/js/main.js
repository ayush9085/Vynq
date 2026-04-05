// Vynq Frontend JS

console.log('Vynq initialized');

// API Helper
class VynqAPI {
    constructor(baseUrl = '/api') {
        this.baseUrl = baseUrl;
    }

    async getQuestions() {
        const response = await fetch(`${this.baseUrl}/questions`);
        return response.json();
    }

    async submitAssessment(responses) {
        const response = await fetch(`${this.baseUrl}/submit-assessment`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(responses)
        });
        return response.json();
    }

    async getMatches(limit = 10, offset = 0) {
        const response = await fetch(`${this.baseUrl}/matches?limit=${limit}&offset=${offset}`);
        return response.json();
    }

    async getProfile() {
        const response = await fetch(`${this.baseUrl}/profile`);
        return response.json();
    }
}

const api = new VynqAPI();

// Utility Functions
function showSpinner(element) {
    element.innerHTML = '<div class="spinner"></div>';
}

function hideElement(element) {
    element.style.display = 'none';
}

function showElement(element) {
    element.style.display = 'block';
}

// Export for use in other scripts
window.VynqAPI = api;
