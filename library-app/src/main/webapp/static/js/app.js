/* Athenaeum Client Interactions v3.1 — Inline Header Search, Reader Modal, Theme */
(function () {
    const root = document.documentElement;
    const savedTheme = localStorage.getItem('athenaeum-theme-v3');
    if (savedTheme) {
        root.setAttribute('data-theme', savedTheme);
    }

    const ctx = window.__CTX__ || '';

    window.toggleTheme = function () {
        const current = root.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
        const next = current === 'dark' ? 'light' : 'dark';
        root.setAttribute('data-theme', next);
        localStorage.setItem('athenaeum-theme-v3', next);
        updateThemeIcons(next);
    };

    function updateThemeIcons(theme) {
        document.querySelectorAll('[data-theme-icon]').forEach(function (el) {
            el.textContent = theme === 'dark' ? '☀' : '☾';
        });
    }

    // ---- Built-in Study Guide Reader Modal ----
    let readerFontSize = 1.08;

    window.openReaderPreview = function (bookId) {
        const backdrop = document.getElementById('readerModalBackdrop');
        const body = document.getElementById('readerContent');
        const titleEl = document.getElementById('readerTitle');
        const metaEl = document.getElementById('readerMeta');
        const actionLink = document.getElementById('readerBookLink');
        if (!backdrop) return;

        backdrop.hidden = false;
        backdrop.classList.add('open');
        titleEl.textContent = 'Loading notes...';
        metaEl.textContent = '';
        body.textContent = '';

        fetch(ctx + '/api/books/' + bookId + '/preview')
            .then(function (r) { return r.json(); })
            .then(function (b) {
                titleEl.textContent = b.title;
                metaEl.textContent = b.author + ' · ' + b.genre + ' · ' + b.readingTime + ' · Shelf ' + b.shelf;
                body.textContent = (b.librarianNote ? b.librarianNote + '\n\n' : '') + (b.previewGuide || '');
                actionLink.href = ctx + '/books/' + b.id;
                actionLink.textContent = b.available ? 'View & Borrow' : 'View & Join Waitlist';
            })
            .catch(function () {
                body.textContent = 'Unable to load reading guide right now.';
            });
    };

    window.closeReaderPreview = function () {
        const backdrop = document.getElementById('readerModalBackdrop');
        if (!backdrop) return;
        backdrop.classList.remove('open');
        backdrop.hidden = true;
    };

    window.setReaderTheme = function (theme) {
        const sheet = document.getElementById('readerSheet');
        if (sheet) sheet.setAttribute('data-reader-theme', theme);
    };

    window.adjustReaderFont = function (delta) {
        readerFontSize = Math.min(1.38, Math.max(0.88, readerFontSize + delta));
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

        // Inline Live Header Search Dropdown
        const searchInput = document.getElementById('headerSearchInput');
        const dropdown = document.getElementById('headerSearchDropdown');
        let timer = null;

        if (searchInput && dropdown) {
            searchInput.addEventListener('input', function () {
                const q = searchInput.value.trim();
                clearTimeout(timer);
                if (q.length < 1) {
                    dropdown.hidden = true;
                    return;
                }
                timer = setTimeout(function () {
                    fetch(ctx + '/api/search?q=' + encodeURIComponent(q))
                        .then(function (r) { return r.json(); })
                        .then(function (data) {
                            let html = '';
                            if (data.books && data.books.length > 0) {
                                html += '<div class="search-dd-label">Books</div>';
                                data.books.forEach(function (b) {
                                    const st = b.available ? 'Available' : 'Waitlist';
                                    html += '<a class="search-dd-item" href="' + ctx + '/books/' + b.id + '">' +
                                        '<div class="search-dd-thumb" style="background:' + b.coverColor + ';">' +
                                        (b.coverUrl ? '<img src="' + b.coverUrl + '" alt="" onerror="this.style.display=\'none\'">' : '') +
                                        '</div>' +
                                        '<div style="flex:1; min-width:0;">' +
                                        '<div style="font-weight:600; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">' + escapeHtml(b.title) + '</div>' +
                                        '<div style="font-size:0.76rem; color:var(--ink-3);">' + escapeHtml(b.author) + ' · ' + escapeHtml(b.genre) + '</div>' +
                                        '</div>' +
                                        '<span class="tag ' + (b.available ? 'tag-green' : 'tag-amber') + '">' + st + '</span>' +
                                        '</a>';
                                });
                            }
                            if (data.authors && data.authors.length > 0) {
                                html += '<div class="search-dd-label">Authors</div>';
                                data.authors.forEach(function (a) {
                                    html += '<a class="search-dd-item" href="' + ctx + '/authors/' + a.id + '">' +
                                        '<div style="flex:1;"><strong>' + escapeHtml(a.name) + '</strong> <span style="color:var(--ink-3); font-size:0.76rem;">' + escapeHtml(a.nationality) + '</span></div>' +
                                        '</a>';
                                });
                            }
                            if (!html) {
                                html = '<div style="padding:1rem; text-align:center; color:var(--ink-3); font-size:0.84rem;">No matches for "' + escapeHtml(q) + '"</div>';
                            }
                            dropdown.innerHTML = html;
                            dropdown.hidden = false;
                        })
                        .catch(function () { dropdown.hidden = true; });
                }, 170);
            });

            document.addEventListener('click', function (e) {
                if (!searchInput.contains(e.target) && !dropdown.contains(e.target)) {
                    dropdown.hidden = true;
                }
            });
        }

        // Press "/" to focus search, "Escape" to close modal/dropdown
        document.addEventListener('keydown', function (e) {
            if (e.key === '/' && !['INPUT', 'TEXTAREA', 'SELECT'].includes(document.activeElement.tagName)) {
                if (searchInput) {
                    e.preventDefault();
                    searchInput.focus();
                }
            } else if (e.key === 'Escape') {
                if (dropdown) dropdown.hidden = true;
                window.closeReaderPreview();
            }
        });

        const navBtn = document.getElementById('mobileNavToggle');
        const navMenu = document.getElementById('mainNav');
        if (navBtn && navMenu) {
            navBtn.addEventListener('click', function () { navMenu.classList.toggle('open'); });
        }

        const adminBtn = document.getElementById('adminSidebarToggle');
        const adminSidebar = document.getElementById('adminSidebar');
        if (adminBtn && adminSidebar) {
            adminBtn.addEventListener('click', function () { adminSidebar.classList.toggle('open'); });
        }
    });
})();
