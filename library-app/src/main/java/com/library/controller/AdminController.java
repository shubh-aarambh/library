package com.library.controller;

import com.library.config.AuthInterceptor;
import com.library.model.Author;
import com.library.model.Book;
import com.library.model.Member;
import com.library.service.AuthorService;
import com.library.service.BookService;
import com.library.service.LibraryOpsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.Optional;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final BookService bookService;
    private final AuthorService authorService;
    private final LibraryOpsService libraryOpsService;

    public AdminController(BookService bookService,
                           AuthorService authorService,
                           LibraryOpsService libraryOpsService) {
        this.bookService = bookService;
        this.authorService = authorService;
        this.libraryOpsService = libraryOpsService;
    }

    // =====================================================
    // Admin Authentication
    // =====================================================

    @GetMapping("/login")
    public String showAdminLogin(@RequestParam(required = false) Boolean required, Model model) {
        model.addAttribute("authRequired", Boolean.TRUE.equals(required));
        model.addAttribute("pageTitle", "Admin Console Sign In");
        return "admin/login";
    }

    @PostMapping("/login")
    public String doAdminLogin(@RequestParam String email,
                               @RequestParam String password,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        Optional<Member> adminOpt = libraryOpsService.authenticate(email, password)
                .filter(Member::isAdmin);
        if (adminOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Invalid administrator credentials or insufficient privileges.");
            return "redirect:/admin/login";
        }
        Member admin = adminOpt.get();
        session.setAttribute(AuthInterceptor.SESSION_MEMBER_ID, admin.getId());
        libraryOpsService.logActivity("ADMIN_LOGIN", "SYSTEM", admin.getFullName(),
                "Signed in to Athenaeum Admin Console");
        redirectAttributes.addFlashAttribute("successMessage", "Welcome to Admin Console, " + admin.getFullName() + "!");
        return "redirect:/admin";
    }

    @PostMapping("/demo-login")
    public String demoAdminLogin(HttpSession session, RedirectAttributes redirectAttributes) {
        Member admin = libraryOpsService.findMemberByEmail("admin@library.dev")
                .orElseThrow(() -> new IllegalStateException("Admin account not found"));
        session.setAttribute(AuthInterceptor.SESSION_MEMBER_ID, admin.getId());
        libraryOpsService.logActivity("ADMIN_LOGIN", "SYSTEM", admin.getFullName(),
                "Quick demo admin sign-in");
        redirectAttributes.addFlashAttribute("successMessage", "Signed in to Admin Console as " + admin.getFullName());
        return "redirect:/admin";
    }

    // =====================================================
    // Admin Overview Dashboard
    // =====================================================

    @GetMapping({"", "/"})
    public String dashboard(Model model) {
        libraryOpsService.refreshOverdueLoans();
        model.addAttribute("stats", libraryOpsService.getLibraryStats());
        model.addAttribute("genreBreakdown", bookService.getGenreBreakdown());
        model.addAttribute("topBooks", bookService.getTopRatedBooks());
        model.addAttribute("recentLoans", libraryOpsService.getAllLoans("ALL").stream().limit(6).toArray());
        model.addAttribute("recentActivity", libraryOpsService.getRecentActivity());
        model.addAttribute("adminSection", "dashboard");
        model.addAttribute("pageTitle", "Admin Overview");
        return "admin/dashboard";
    }

    // =====================================================
    // Admin Books Management
    // =====================================================

    @GetMapping("/books")
    public String manageBooks(@RequestParam(required = false) String q,
                              @RequestParam(required = false, defaultValue = "ALL") String genre,
                              Model model) {
        model.addAttribute("books", bookService.filterBooks(q, genre, "ALL", "title"));
        model.addAttribute("genres", bookService.getAllGenres());
        model.addAttribute("query", q != null ? q : "");
        model.addAttribute("selectedGenre", genre);
        model.addAttribute("adminSection", "books");
        model.addAttribute("pageTitle", "Manage Books");
        return "admin/books";
    }

    @GetMapping("/books/new")
    public String newAdminBook(Model model) {
        model.addAttribute("book", new Book());
        model.addAttribute("authors", authorService.getAllAuthors());
        model.addAttribute("formAction", "/admin/books/save");
        model.addAttribute("buttonLabel", "Create Book");
        model.addAttribute("adminSection", "books");
        model.addAttribute("pageTitle", "Add Catalog Volume");
        return "admin/book-form";
    }

    @PostMapping("/books/save")
    public String saveAdminBook(@Valid @ModelAttribute("book") Book book,
                                BindingResult bindingResult,
                                HttpServletRequest request,
                                Model model,
                                RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("authors", authorService.getAllAuthors());
            model.addAttribute("formAction", "/admin/books/save");
            model.addAttribute("buttonLabel", "Create Book");
            model.addAttribute("adminSection", "books");
            model.addAttribute("pageTitle", "Add Catalog Volume");
            return "admin/book-form";
        }
        Book saved = bookService.saveBook(book);
        Member admin = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("BOOK_CREATED", "CATALOG", admin.getFullName(),
                "Added volume \"" + saved.getTitle() + "\" (" + saved.getTotalCopies() + " copies)");
        redirectAttributes.addFlashAttribute("successMessage", "Volume \"" + saved.getTitle() + "\" added to catalog.");
        return "redirect:/admin/books";
    }

    @GetMapping("/books/edit/{id}")
    public String editAdminBook(@PathVariable Long id, Model model) {
        model.addAttribute("book", bookService.getBookById(id));
        model.addAttribute("authors", authorService.getAllAuthors());
        model.addAttribute("formAction", "/admin/books/update/" + id);
        model.addAttribute("buttonLabel", "Save Changes");
        model.addAttribute("adminSection", "books");
        model.addAttribute("pageTitle", "Edit Catalog Volume");
        return "admin/book-form";
    }

    @PostMapping("/books/update/{id}")
    public String updateAdminBook(@PathVariable Long id,
                                  @Valid @ModelAttribute("book") Book book,
                                  BindingResult bindingResult,
                                  HttpServletRequest request,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("authors", authorService.getAllAuthors());
            model.addAttribute("formAction", "/admin/books/update/" + id);
            model.addAttribute("buttonLabel", "Save Changes");
            model.addAttribute("adminSection", "books");
            model.addAttribute("pageTitle", "Edit Catalog Volume");
            return "admin/book-form";
        }
        Book updated = bookService.updateBook(id, book);
        Member admin = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("BOOK_UPDATED", "CATALOG", admin.getFullName(),
                "Updated volume \"" + updated.getTitle() + "\"");
        redirectAttributes.addFlashAttribute("successMessage", "Volume \"" + updated.getTitle() + "\" updated.");
        return "redirect:/admin/books";
    }

    @PostMapping("/books/feature/{id}")
    public String toggleFeatureBook(@PathVariable Long id,
                                    HttpServletRequest request,
                                    RedirectAttributes redirectAttributes) {
        Book book = bookService.toggleFeatured(id);
        Member admin = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("BOOK_FEATURED", "CATALOG", admin.getFullName(),
                (book.getFeatured() ? "Featured" : "Unfeatured") + " \"" + book.getTitle() + "\" on homepage");
        redirectAttributes.addFlashAttribute("successMessage",
                "\"" + book.getTitle() + "\" " + (book.getFeatured() ? "marked as Staff Pick." : "removed from Staff Picks."));
        return "redirect:/admin/books";
    }

    @PostMapping("/books/delete/{id}")
    public String deleteAdminBook(@PathVariable Long id,
                                  HttpServletRequest request,
                                  RedirectAttributes redirectAttributes) {
        Book book = bookService.getBookById(id);
        bookService.deleteBook(id);
        Member admin = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("BOOK_DELETED", "CATALOG", admin.getFullName(),
                "Deleted volume \"" + book.getTitle() + "\"");
        redirectAttributes.addFlashAttribute("successMessage", "Volume \"" + book.getTitle() + "\" deleted.");
        return "redirect:/admin/books";
    }

    // =====================================================
    // Admin Authors Management
    // =====================================================

    @GetMapping("/authors")
    public String manageAuthors(@RequestParam(required = false) String q, Model model) {
        model.addAttribute("authors", authorService.filterAuthors(q, "ALL", false));
        model.addAttribute("query", q != null ? q : "");
        model.addAttribute("adminSection", "authors");
        model.addAttribute("pageTitle", "Manage Authors");
        return "admin/authors";
    }

    @GetMapping("/authors/new")
    public String newAdminAuthor(Model model) {
        model.addAttribute("author", new Author());
        model.addAttribute("formAction", "/admin/authors/save");
        model.addAttribute("buttonLabel", "Create Author");
        model.addAttribute("adminSection", "authors");
        model.addAttribute("pageTitle", "Add Author Profile");
        return "admin/author-form";
    }

    @PostMapping("/authors/save")
    public String saveAdminAuthor(@Valid @ModelAttribute("author") Author author,
                                  BindingResult bindingResult,
                                  HttpServletRequest request,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("formAction", "/admin/authors/save");
            model.addAttribute("buttonLabel", "Create Author");
            model.addAttribute("adminSection", "authors");
            model.addAttribute("pageTitle", "Add Author Profile");
            return "admin/author-form";
        }
        Author saved = authorService.saveAuthor(author);
        Member admin = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("AUTHOR_CREATED", "CATALOG", admin.getFullName(),
                "Created author profile \"" + saved.getName() + "\"");
        redirectAttributes.addFlashAttribute("successMessage", "Author \"" + saved.getName() + "\" created.");
        return "redirect:/admin/authors";
    }

    @GetMapping("/authors/edit/{id}")
    public String editAdminAuthor(@PathVariable Long id, Model model) {
        model.addAttribute("author", authorService.getAuthorById(id));
        model.addAttribute("formAction", "/admin/authors/update/" + id);
        model.addAttribute("buttonLabel", "Save Changes");
        model.addAttribute("adminSection", "authors");
        model.addAttribute("pageTitle", "Edit Author Profile");
        return "admin/author-form";
    }

    @PostMapping("/authors/update/{id}")
    public String updateAdminAuthor(@PathVariable Long id,
                                    @Valid @ModelAttribute("author") Author author,
                                    BindingResult bindingResult,
                                    HttpServletRequest request,
                                    Model model,
                                    RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("formAction", "/admin/authors/update/" + id);
            model.addAttribute("buttonLabel", "Save Changes");
            model.addAttribute("adminSection", "authors");
            model.addAttribute("pageTitle", "Edit Author Profile");
            return "admin/author-form";
        }
        Author updated = authorService.updateAuthor(id, author);
        Member admin = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("AUTHOR_UPDATED", "CATALOG", admin.getFullName(),
                "Updated author \"" + updated.getName() + "\"");
        redirectAttributes.addFlashAttribute("successMessage", "Author \"" + updated.getName() + "\" updated.");
        return "redirect:/admin/authors";
    }

    @PostMapping("/authors/delete/{id}")
    public String deleteAdminAuthor(@PathVariable Long id,
                                    HttpServletRequest request,
                                    RedirectAttributes redirectAttributes) {
        Author author = authorService.getAuthorById(id);
        authorService.deleteAuthor(id);
        Member admin = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("AUTHOR_DELETED", "CATALOG", admin.getFullName(),
                "Deleted author \"" + author.getName() + "\" and linked books");
        redirectAttributes.addFlashAttribute("successMessage", "Author \"" + author.getName() + "\" deleted.");
        return "redirect:/admin/authors";
    }

    // =====================================================
    // Admin Circulation & Loans Desk
    // =====================================================

    @GetMapping("/loans")
    public String manageLoans(@RequestParam(required = false, defaultValue = "ALL") String status, Model model) {
        libraryOpsService.refreshOverdueLoans();
        model.addAttribute("loans", libraryOpsService.getAllLoans(status));
        model.addAttribute("selectedStatus", status.toUpperCase());
        model.addAttribute("availableBooks", bookService.filterBooks(null, "ALL", "AVAILABLE", "title"));
        model.addAttribute("members", libraryOpsService.getAllMembers());
        model.addAttribute("stats", libraryOpsService.getLibraryStats());
        model.addAttribute("adminSection", "loans");
        model.addAttribute("pageTitle", "Circulation Desk");
        return "admin/loans";
    }

    @PostMapping("/loans/issue")
    public String issueLoan(@RequestParam Long bookId,
                            @RequestParam Long memberId,
                            @RequestParam(defaultValue = "14") Integer days,
                            @RequestParam(required = false) String notes,
                            HttpServletRequest request,
                            RedirectAttributes redirectAttributes) {
        Member admin = (Member) request.getAttribute("currentUser");
        try {
            libraryOpsService.borrowBook(bookId, memberId, days,
                    notes != null && !notes.isBlank() ? notes : "Issued at Admin Circulation Desk",
                    admin.getFullName());
            redirectAttributes.addFlashAttribute("successMessage", "Loan issued successfully!");
        } catch (IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/loans";
    }

    @PostMapping("/loans/return/{id}")
    public String returnLoan(@PathVariable Long id,
                             HttpServletRequest request,
                             RedirectAttributes redirectAttributes) {
        Member admin = (Member) request.getAttribute("currentUser");
        libraryOpsService.returnBook(id, admin.getFullName());
        redirectAttributes.addFlashAttribute("successMessage", "Book checked back in and inventory restored.");
        return "redirect:/admin/loans";
    }

    @PostMapping("/loans/renew/{id}")
    public String renewLoan(@PathVariable Long id,
                            HttpServletRequest request,
                            RedirectAttributes redirectAttributes) {
        Member admin = (Member) request.getAttribute("currentUser");
        try {
            libraryOpsService.renewLoan(id, 7, admin.getFullName());
            redirectAttributes.addFlashAttribute("successMessage", "Due date extended by 7 days.");
        } catch (IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/admin/loans";
    }

    @PostMapping("/loans/pay-fine/{id}")
    public String settleFine(@PathVariable Long id,
                             HttpServletRequest request,
                             RedirectAttributes redirectAttributes) {
        Member admin = (Member) request.getAttribute("currentUser");
        libraryOpsService.markFinePaid(id, admin.getFullName());
        redirectAttributes.addFlashAttribute("successMessage", "Fine marked as settled.");
        return "redirect:/admin/loans";
    }

    // =====================================================
    // Admin Members & Audit Log
    // =====================================================

    @GetMapping("/members")
    public String manageMembers(Model model) {
        model.addAttribute("members", libraryOpsService.getAllMembers());
        model.addAttribute("stats", libraryOpsService.getLibraryStats());
        model.addAttribute("adminSection", "members");
        model.addAttribute("pageTitle", "Member Directory");
        return "admin/members";
    }

    @PostMapping("/members/update/{id}")
    public String updateMember(@PathVariable Long id,
                               @RequestParam String tier,
                               @RequestParam String role,
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        Member admin = (Member) request.getAttribute("currentUser");
        libraryOpsService.updateMemberTierAndRole(id, tier, role, admin.getFullName());
        redirectAttributes.addFlashAttribute("successMessage", "Member role and tier updated.");
        return "redirect:/admin/members";
    }

    @PostMapping("/members/toggle/{id}")
    public String toggleMember(@PathVariable Long id,
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        Member admin = (Member) request.getAttribute("currentUser");
        if (admin.getId().equals(id)) {
            redirectAttributes.addFlashAttribute("errorMessage", "You cannot suspend your own active admin account.");
            return "redirect:/admin/members";
        }
        libraryOpsService.toggleMemberStatus(id, admin.getFullName());
        redirectAttributes.addFlashAttribute("successMessage", "Member account status updated.");
        return "redirect:/admin/members";
    }

    @GetMapping("/audit")
    public String auditLogs(@RequestParam(required = false, defaultValue = "ALL") String category, Model model) {
        model.addAttribute("logs", libraryOpsService.getAllActivity(category));
        model.addAttribute("selectedCategory", category.toUpperCase());
        model.addAttribute("adminSection", "audit");
        model.addAttribute("pageTitle", "System Audit Log");
        return "admin/audit";
    }
}

