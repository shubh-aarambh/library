/* Athenaeum Client Interactions: Theme Toggle, Keyboard Search, Mobile Drawers, Auto-dismiss Alerts */
(function () {
    const root = document.documentElement;
    const savedTheme = localStorage.getItem('athenaeum-theme');
    if (savedTheme) {
        root.setAttribute('data-theme', savedTheme);
    }

    window.toggleTheme = function () {
        const current = root.getAttribute('data-theme') === 'light' ? 'light' : 'dark';
        const next = current === 'light' ? 'dark' : 'light';
        root.setAttribute('data-theme', next);
        localStorage.setItem('athenaeum-theme', next);
        updateThemeIcons(next);
    };

    function updateThemeIcons(theme) {
        document.querySelectorAll('[data-theme-icon]').forEach(function (el) {
            el.textContent = theme === 'light' ? '☾' : '☀';
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        const activeTheme = root.getAttribute('data-theme') === 'light' ? 'light' : 'dark';
        updateThemeIcons(activeTheme);

        // Press "/" to focus search box
        document.addEventListener('keydown', function (e) {
            if (e.key === '/' && !['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement.tagName)) {
                const searchInput = document.querySelector('[data-quick-search]');
                if (searchInput) {
                    e.preventDefault();
                    searchInput.focus();
                }
            }
        });

        // Mobile navbar toggle
        const navBtn = document.getElementById('mobileNavToggle');
        const navMenu = document.getElementById('navbarLinks');
        if (navBtn && navMenu) {
            navBtn.addEventListener('click', function () {
                navMenu.classList.toggle('open');
            });
        }

        // Mobile admin sidebar toggle
        const adminBtn = document.getElementById('adminSidebarToggle');
        const adminSidebar = document.getElementById('adminSidebar');
        if (adminBtn && adminSidebar) {
            adminBtn.addEventListener('click', function () {
                adminSidebar.classList.toggle('open');
            });
        }

        // Auto-fade flash alerts after 6 seconds
        document.querySelectorAll('.alert[data-autoclose]').forEach(function (alertEl) {
            setTimeout(function () {
                alertEl.style.transition = 'opacity 0.4s ease';
                alertEl.style.opacity = '0';
                setTimeout(function () { alertEl.remove(); }, 420);
            }, 6000);
        });
    });
})();

