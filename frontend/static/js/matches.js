// Matches functionality

document.addEventListener('DOMContentLoaded', function() {
    const matchesContainer = document.getElementById('matches-container');
    const loading = document.getElementById('loading');
    const noMatches = document.getElementById('no-matches');
    const noAssessment = document.getElementById('no-assessment');
    const template = document.getElementById('match-card-template');

    // Load matches
    async function loadMatches() {
        try {
            const response = await fetch('/api/matches?limit=10');
            if (!response.ok) throw new Error('Failed to load matches');
            
            const data = await response.json();
            
            if (loading) loading.style.display = 'none';
            
            if (!data.matches || data.matches.length === 0) {
                if (noMatches) noMatches.style.display = 'block';
                return;
            }

            // Render matches
            data.matches.forEach(match => {
                const clone = template.content.cloneNode(true);
                clone.querySelector('[data-name]').textContent = match.name || 'User';
                clone.querySelector('[data-age-location]').textContent = `${match.age || 'N/A'}, ${match.location || 'Unknown'}`;
                clone.querySelector('[data-score]').textContent = Math.round(match.compatibility_score) + '%';
                clone.querySelector('[data-explanation]').textContent = match.explanation || 'Compatible personality profiles';
                clone.querySelector('[data-bio]').textContent = match.bio || 'No bio available';
                
                matchesContainer.appendChild(clone);
            });
        } catch (error) {
            console.error('Error loading matches:', error);
            if (loading) loading.style.display = 'none';
            if (noAssessment) noAssessment.style.display = 'block';
        }
    }

    // Load matches on page load
    loadMatches();
});
