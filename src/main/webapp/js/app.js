/**
 * DermAnalysis Client Application Interactions
 */
document.addEventListener('DOMContentLoaded', () => {
    
    // 1. Double confirmation for destructive actions (Delete records)
    const deleteButtons = document.querySelectorAll('.btn-delete-confirm');
    deleteButtons.forEach(btn => {
        btn.addEventListener('click', (e) => {
            const recordName = btn.getAttribute('data-name') || 'this record';
            const confirmed = confirm(`Are you sure you want to delete ${recordName}? This action cannot be undone.`);
            if (!confirmed) {
                e.preventDefault();
            }
        });
    });

    // 2. Auto-scroll terminal console in lifecycle demo to the bottom
    const consoleTerminal = document.querySelector('.terminal-console');
    if (consoleTerminal) {
        consoleTerminal.scrollTop = consoleTerminal.scrollHeight;
    }

    // 3. Clear URL Parameter alerts after displaying
    const errorAlert = document.querySelector('.alert');
    if (errorAlert) {
        setTimeout(() => {
            // Smooth fade out
            errorAlert.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            errorAlert.style.opacity = '0';
            errorAlert.style.transform = 'translateY(-10px)';
            setTimeout(() => {
                errorAlert.remove();
                // Clean the query string without reloading page
                const cleanURL = window.location.protocol + "//" + window.location.host + window.location.pathname;
                window.history.replaceState({ path: cleanURL }, '', cleanURL);
            }, 500);
        }, 5000);
    }
    
    // 4. Highlight current navigation link
    const currentPath = window.location.pathname;
    const navLinks = document.querySelectorAll('.nav-links a');
    navLinks.forEach(link => {
        const href = link.getAttribute('href');
        if (currentPath.endsWith(href) || (currentPath.endsWith('/') && href === 'index.jsp')) {
            link.classList.add('active');
        } else {
            link.classList.remove('active');
        }
    });
});
