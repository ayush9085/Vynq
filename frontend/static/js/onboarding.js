// Onboarding functionality

document.addEventListener('DOMContentLoaded', function() {
    let currentQuestionIndex = 0;
    let questions = [];
    let responses = [];

    // Fetch questions
    async function loadQuestions() {
        try {
            const response = await fetch('/api/questions');
            questions = await response.json();
            document.getElementById('total-questions').textContent = questions.length;
            showQuestion(0);
        } catch (error) {
            console.error('Error loading questions:', error);
        }
    }

    function showQuestion(index) {
        if (index >= questions.length) {
            showResults();
            return;
        }

        currentQuestionIndex = index;
        const question = questions[index];
        const assessmentForm = document.getElementById('assessment-form');
        const loading = document.getElementById('loading');

        if (loading) loading.style.display = 'none';
        if (assessmentForm) assessmentForm.style.display = 'block';

        // Update progress
        document.getElementById('current-question').textContent = index + 1;
        document.getElementById('progress-bar').style.width = ((index + 1) / questions.length * 100) + '%';

        // Update buttons
        document.getElementById('prev-btn').style.display = index > 0 ? 'block' : 'none';

        // Render question (placeholder)
        const questionContent = document.getElementById('question-content');
        questionContent.innerHTML = `<h3 style="font-weight: 600; margin-bottom: 1rem;">${question.text}</h3>`;
    }

    function showResults() {
        document.getElementById('assessment-form').style.display = 'none';
        document.getElementById('results-section').style.display = 'block';
        
        // Populate with sample data
        setTimeout(() => {
            document.getElementById('confidence-score').textContent = '87%';
        }, 500);
    }

    // Event listeners
    document.getElementById('next-btn').addEventListener('click', function() {
        if (currentQuestionIndex < questions.length - 1) {
            showQuestion(currentQuestionIndex + 1);
        } else {
            showResults();
        }
    });

    document.getElementById('prev-btn').addEventListener('click', function() {
        if (currentQuestionIndex > 0) {
            showQuestion(currentQuestionIndex - 1);
        }
    });

    // Load questions on page load
    loadQuestions();
});
