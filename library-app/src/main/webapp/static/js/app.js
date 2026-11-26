/* Athenaeum Interactive Experience: Theme Toggle, Cmd+K Spotlight Search, Built-in Reader Preview Modal */
(function () {
    const root = document.documentElement;
    const savedTheme = localStorage.getItem('athenaeum-theme-v2');
    if (savedTheme) {
        root.setAttribute('data-theme', savedTheme);
    }

    const ctx = window.__CTX__ || '';

    window.toggleTheme = function () {
        const current = root.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
        const next = current === 'dark' ? 'light' : 'dark';
        root.setAttribute('data-theme', next);
        localStorage.setItem('athenaeum-theme-v2', next);
        updateThemeIcons(next);
    };

    function updateThemeIcons(theme) {
        document.querySelectorAll('[data-theme-icon]').forEach(function (el) {
            el.textContent = theme === 'dark' ? '☀' : '☾';
        });
    }

    // ---- Cmd+K Spotlight Search Modal ----
    let searchTimer = null;

    window.openSpotlight = function () {
        const modal = document.getElementById('spotlightModal');
        const input = document.getElementById('spotlightInput');
        if (!modal) return;
        modal.classList.add('open');
        setTimeout(function () {
            if (input) {
                input.focus();
                runLiveSearch(input.value || '');
            }
        }, 40);
    };

    window.closeSpotlight = function () {
        const modal = document.getElementById('spotlightModal');
        if (modal) modal.classList.remove('open');
    };

    function runLiveSearch(query) {
        const container = document.getElementById('spotlightResults');
        if (!container) return;
        fetch(ctx + '/api/search?q=' + encodeURIComponent(query))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                let html = '';
                if (data.books && data.books.length > 0) {
                    html += '<div class="cmd-section-label">Books (' + data.books.length + ')</div>';
                    data.books.forEach(function (b) {
                        const statusBadge = b.available
                            ? '<span class="badge badge-emerald">' + b.availableCopies + ' on shelf</span>'
                            : '<span class="badge">Waitlist</span>';
                        html += '<a class="cmd-item" href="' + ctx + '/books/' + b.id + '">' +
                            '<div class="cmd-thumb" style="background:' + b.coverColor + ';">' +
                            (b.coverUrl ? '<img src="' + b.coverUrl + '" alt="" onerror="this.style.display=\'none\'">' : '') +
                            '</div>' +
                            '<div style="flex:1; min-width:0;">' +
                            '<div style="font-weight:700; font-size:0.92rem; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' + escapeHtml(b.title) + '</div>' +
                            '<div style="font-size:0.78rem; color:var(--text-muted);">' + escapeHtml(b.author) + ' · ' + escapeHtml(b.genre) + ' · ' + escapeHtml(b.readingTime) + '</div>' +
                            '</div>' + statusBadge + '</a>';
                    });
                }
                if (data.authors && data.authors.length > 0) {
                    html += '<div class="cmd-section-label" style="margin-top:6px;">Authors</div>';
                    data.authors.forEach(function (a) {
                        html += '<a class="cmd-item" href="' + ctx + '/authors/' + a.id + '">' +
                            '<div class="user-avatar" style="background:' + a.avatarColor + '; width:34px; height:34px;">' + escapeHtml(a.initials) + '</div>' +
                            '<div style="flex:1;">' +
                            '<div style="font-weight:700; font-size:0.9rem;">' + escapeHtml(a.name) + '</div>' +
                            '<div style="font-size:0.77rem; color:var(--text-muted);">' + escapeHtml(a.nationality) + (a.award ? ' · ' + escapeHtml(a.award) : '') + '</div>' +
                            '</div></a>';
                    });
                }
                if (!html) {
                    html = '<div style="padding:2rem; text-align:center; color:var(--text-muted);">No matching books or authors found. Try another keyword.</div>';
                }
                container.innerHTML = html;
            })
            .catch(function () {
                container.innerHTML = '<div style="padding:1.5rem; text-align:center; color:var(--text-muted);">Search unavailable right now.</div>';
            });
    }

    // ---- Built-in Reader Preview & Study Guide Modal ----
    let readerFontSize = 1.03;

    window.openReaderPreview = function (bookId) {
        const modal = document.getElementById('readerModalBackdrop');
        const body = document.getElementById('readerContent');
        const titleEl = document.getElementById('readerTitle');
        const metaEl = document.getElementById('readerMeta');
        const noteEl = document.getElementById('readerNote');
        const actionLink = document.getElementById('readerBookLink');
        if (!modal) return;

        modal.classList.add('open');
        titleEl.textContent = 'Loading Reader Guide...';
        metaEl.textContent = '';
        noteEl.textContent = '';
        body.textContent = 'Opening edition notes...';

        fetch(ctx + '/api/books/' + bookId + '/preview')
            .then(function (r) { return r.json(); })
            .then(function (b) {
                titleEl.textContent = b.title;
                metaEl.textContent = b.author + ' · ' + b.genre + ' · ' + b.readingTime + ' · Shelf ' + b.shelf;
                noteEl.textContent = 'Librarian Pick Note: ' + (b.librarianNote || '');
                body.textContent = b.previewGuide || '';
                actionLink.href = ctx + '/books/' + b.id;
                actionLink.textContent = b.available ? 'Borrow or View Details →' : 'Join Waitlist or View Details →';
            })
            .catch(function () {
                body.textContent = 'Could not load reader preview.';
            });
    };

    window.closeReaderPreview = function () {
        const modal = document.getElementById('readerModalBackdrop');
        if (modal) modal.classList.remove('open');
    };

    window.setReaderTheme = function (theme) {
        const sheet = document.getElementById('readerSheet');
        if (sheet) sheet.setAttribute('data-reader-theme', theme);
    };

    window.adjustReaderFont = function (delta) {
        readerFontSize = Math.min(1.4, Math.max(0.85, readerFontSize + delta));
        const body = document.getElementById('readerContent');
        if (body) body.style.fontSize = readerFontSize.toFixed(2) + 'rem';
    };

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/[&<>"']/g, function (c) {
            return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        const activeTheme = root.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
        updateThemeIcons(activeTheme);

        // Cmd+K / Ctrl+K or "/" opens Spotlight Search
        document.addEventListener('keydown', function (e) {
            if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === 'k') {
                e.preventDefault();
                window.openSpotlight();
            } else if (e.key === '/' && !['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement.tagName)) {
                e.preventDefault();
                window.openSpotlight();
            } else if (e.key === 'Escape') {
                window.closeSpotlight();
                window.closeReaderPreview();
            }
        });

        const spInput = document.getElementById('spotlightInput');
        if (spInput) {
            spInput.addEventListener('input', function () {
                clearTimeout(searchTimer);
                const val = spInput.value;
                searchTimer = setTimeout(function () { runLiveSearch(val); }, 160);
            });
        }

        const navBtn = document.getElementById('mobileNavToggle');
        const navMenu = document.getElementById('navbarLinks');
        if (navBtn && navMenu) {
            navBtn.addEventListener('click', function () { navMenu.classList.toggle('open'); });
        }

        const adminBtn = document.getElementById('adminSidebarToggle');
        const adminSidebar = document.getElementById('adminSidebar');
        if (adminBtn && adminSidebar) {
            adminBtn.addEventListener('click', function () { adminSidebar.classList.toggle('open'); });
        }

        document.querySelectorAll('.alert[data-autoclose]').forEach(function (el) {
            setTimeout(function () {
                el.style.transition = 'opacity 0.4s ease';
                el.style.opacity = '0';
                setTimeout(function () { el.remove(); }, 420);
            }, 6500);
        });
    });
})();
