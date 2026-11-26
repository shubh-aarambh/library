package com.library.controller;

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
import javax.validation.Valid;
import java.util.List;

@Controller
@RequestMapping("/books")
public class BookController {

    private final BookService bookService;
    private final AuthorService authorService;
    private final LibraryOpsService libraryOpsService;

    public BookController(BookService bookService,
                          AuthorService authorService,
                          LibraryOpsService libraryOpsService) {
        this.bookService = bookService;
        this.authorService = authorService;
        this.libraryOpsService = libraryOpsService;
    }

    // READ - Catalog with search, genre, availability, sort, and grid/table view
    @GetMapping
    public String listBooks(@RequestParam(required = false) String q,
                            @RequestParam(required = false) String genre,
                            @RequestParam(required = false, defaultValue = "ALL") String availability,
                            @RequestParam(required = false, defaultValue = "rating") String sort,
                            @RequestParam(required = false, defaultValue = "grid") String view,
                            Model model) {
        List<Book> books = bookService.filterBooks(q, genre, availability, sort);
        model.addAttribute("books", books);
        model.addAttribute("genres", bookService.getAllGenres());
        model.addAttribute("query", q != null ? q : "");
        model.addAttribute("selectedGenre", genre != null ? genre : "ALL");
        model.addAttribute("selectedAvailability", availability);
        model.addAttribute("selectedSort", sort);
        model.addAttribute("viewMode", view);
        model.addAttribute("stats", libraryOpsService.getLibraryStats());
        model.addAttribute("pageTitle", "Library Catalog");
        return "books/list";
    }

    // READ - Book Detail page with borrow, waitlist hold, preview guide, reading list, and reviews
    @GetMapping("/{id}")
    public String viewBook(@PathVariable Long id, HttpServletRequest request, Model model) {
        Book book = bookService.getBookById(id);
        Member currentUser = (Member) request.getAttribute("currentUser");
        model.addAttribute("book", book);
        model.addAttribute("reviews", libraryOpsService.getReviewsForBook(id));
        model.addAttribute("moreByAuthor", bookService.getBooksByAuthorId(book.getAuthor().getId()));
        model.addAttribute("waitlistCount", libraryOpsService.getWaitingCountForBook(id));
        if (currentUser != null) {
            model.addAttribute("inReadingList", libraryOpsService.isInReadingList(currentUser.getId(), id));
            model.addAttribute("hasActiveLoan", libraryOpsService.hasActiveLoanForBook(currentUser.getId(), id));
            model.addAttribute("hasActiveHold", libraryOpsService.hasActiveHoldForBook(currentUser.getId(), id));
        }
        model.addAttribute("pageTitle", book.getTitle());
        return "books/detail";
    }

    // MEMBER ACTION - Borrow a book
    @PostMapping("/{id}/borrow")
    public String borrowBook(@PathVariable Long id,
                             @RequestParam(required = false, defaultValue = "14") Integer days,
                             HttpServletRequest request,
                             RedirectAttributes redirectAttributes) {
        Member currentUser = (Member) request.getAttribute("currentUser");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("infoMessage", "Sign in (or click 1-Click Demo Reader) to borrow this book.");
            return "redirect:/login?next=/books/" + id;
        }
        try {
            var loan = libraryOpsService.borrowBook(id, currentUser.getId(), days,
                    "Self-service checkout via catalog", currentUser.getFullName());
            redirectAttributes.addFlashAttribute("successMessage",
                    "Checked out! Pickup Pass: " + loan.getPickupCode() + " · View your QR pass & reading tracker in My Library.");
        } catch (IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/books/" + id;
    }

    // MEMBER ACTION - Join Waitlist / Place Hold when copies are out
    @PostMapping("/{id}/hold")
    public String placeHold(@PathVariable Long id,
                            HttpServletRequest request,
                            RedirectAttributes redirectAttributes) {
        Member currentUser = (Member) request.getAttribute("currentUser");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("infoMessage", "Sign in (or use Demo Reader) to join the waitlist.");
            return "redirect:/login?next=/books/" + id;
        }
        try {
            var hold = libraryOpsService.placeHold(id, currentUser.getId());
            redirectAttributes.addFlashAttribute("successMessage",
                    "Hold placed! You're in the waitlist queue (Status: " + hold.getStatus() + "). Track it in My Library.");
        } catch (IllegalStateException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        }
        return "redirect:/books/" + id;
    }

    // MEMBER ACTION - Toggle Reading List bookmark
    @PostMapping("/{id}/reading-list")
    public String toggleReadingList(@PathVariable Long id,
                                    HttpServletRequest request,
                                    RedirectAttributes redirectAttributes) {
        Member currentUser = (Member) request.getAttribute("currentUser");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("infoMessage", "Sign in to bookmark titles to your Reading List.");
            return "redirect:/login?next=/books/" + id;
        }
        boolean added = libraryOpsService.toggleReadingList(currentUser.getId(), id);
        redirectAttributes.addFlashAttribute("successMessage",
                added ? "Saved to your Reading List!" : "Removed from your Reading List.");
        return "redirect:/books/" + id;
    }

    // MEMBER ACTION - Post a review & rating
    @PostMapping("/{id}/reviews")
    public String addReview(@PathVariable Long id,
                            @RequestParam Integer rating,
                            @RequestParam String comment,
                            HttpServletRequest request,
                            RedirectAttributes redirectAttributes) {
        Member currentUser = (Member) request.getAttribute("currentUser");
        if (currentUser == null) {
            redirectAttributes.addFlashAttribute("infoMessage", "Sign in to publish a reader review.");
            return "redirect:/login?next=/books/" + id;
        }
        if (comment == null || comment.trim().length() < 5) {
            redirectAttributes.addFlashAttribute("errorMessage", "Please write at least 5 characters for your review.");
            return "redirect:/books/" + id;
        }
        libraryOpsService.addReview(id, currentUser.getId(), rating, comment);
        redirectAttributes.addFlashAttribute("successMessage", "Thank you! Your review has been published.");
        return "redirect:/books/" + id;
    }

    // READ - Inner join view: all books with author details
    @GetMapping("/joined")
    public String listBooksJoined(@RequestParam(required = false) String q, Model model) {
        List<Object[]> rows = bookService.getAllBooksWithAuthorDetails();
        if (q != null && !q.isBlank()) {
            String term = q.trim().toLowerCase();
            rows = rows.stream()
                    .filter(r -> String.valueOf(r[0]).toLowerCase().contains(term)
                            || String.valueOf(r[1]).toLowerCase().contains(term)
                            || String.valueOf(r[2]).toLowerCase().contains(term)
                            || String.valueOf(r[4]).toLowerCase().contains(term))
                    .collect(java.util.stream.Collectors.toList());
        }
        model.addAttribute("rows", rows);
        model.addAttribute("query", q != null ? q : "");
        model.addAttribute("pageTitle", "JPQL Inner Join Explorer");
        return "books/joinedView";
    }

    // CREATE - Show blank form
    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("book", new Book());
        model.addAttribute("authors", authorService.getAllAuthors());
        model.addAttribute("pageTitle", "Add New Book");
        model.addAttribute("formAction", "/books/save");
        model.addAttribute("buttonLabel", "Save Book");
        return "books/form";
    }

    // CREATE - Handle form submission
    @PostMapping("/save")
    public String saveBook(@Valid @ModelAttribute("book") Book book,
                           BindingResult bindingResult,
                           HttpServletRequest request,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("authors", authorService.getAllAuthors());
            model.addAttribute("pageTitle", "Add New Book");
            model.addAttribute("formAction", "/books/save");
            model.addAttribute("buttonLabel", "Save Book");
            return "books/form";
        }
        Book saved = bookService.saveBook(book);
        Member currentUser = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("BOOK_CREATED", "CATALOG",
                currentUser != null ? currentUser.getFullName() : "Librarian",
                "Added \"" + saved.getTitle() + "\" (" + saved.getIsbn() + ")");
        redirectAttributes.addFlashAttribute("successMessage", "Book \"" + saved.getTitle() + "\" saved successfully!");
        return "redirect:/books";
    }

    // UPDATE - Show populated edit form
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Book book = bookService.getBookById(id);
        model.addAttribute("book", book);
        model.addAttribute("authors", authorService.getAllAuthors());
        model.addAttribute("pageTitle", "Edit Book");
        model.addAttribute("formAction", "/books/update/" + id);
        model.addAttribute("buttonLabel", "Update Book");
        return "books/form";
    }

    // UPDATE - Handle update request
    @PostMapping("/update/{id}")
    public String updateBook(@PathVariable Long id,
                             @Valid @ModelAttribute("book") Book book,
                             BindingResult bindingResult,
                             HttpServletRequest request,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("authors", authorService.getAllAuthors());
            model.addAttribute("pageTitle", "Edit Book");
            model.addAttribute("formAction", "/books/update/" + id);
            model.addAttribute("buttonLabel", "Update Book");
            return "books/form";
        }
        Book updated = bookService.updateBook(id, book);
        Member currentUser = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("BOOK_UPDATED", "CATALOG",
                currentUser != null ? currentUser.getFullName() : "Librarian",
                "Updated \"" + updated.getTitle() + "\"");
        redirectAttributes.addFlashAttribute("successMessage", "Book \"" + updated.getTitle() + "\" updated successfully!");
        return "redirect:/books";
    }

    // DELETE
    @GetMapping("/delete/{id}")
    public String deleteBook(@PathVariable Long id,
                             HttpServletRequest request,
                             RedirectAttributes redirectAttributes) {
        Book book = bookService.getBookById(id);
        bookService.deleteBook(id);
        Member currentUser = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("BOOK_DELETED", "CATALOG",
                currentUser != null ? currentUser.getFullName() : "Librarian",
                "Removed \"" + book.getTitle() + "\" from catalog");
        redirectAttributes.addFlashAttribute("successMessage", "Book deleted successfully!");
        return "redirect:/books";
    }
}
