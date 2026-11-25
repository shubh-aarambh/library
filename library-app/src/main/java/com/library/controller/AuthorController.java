package com.library.controller;

import com.library.model.Author;
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
@RequestMapping("/authors")
public class AuthorController {

    private final AuthorService authorService;
    private final BookService bookService;
    private final LibraryOpsService libraryOpsService;

    public AuthorController(AuthorService authorService,
                            BookService bookService,
                            LibraryOpsService libraryOpsService) {
        this.authorService = authorService;
        this.bookService = bookService;
        this.libraryOpsService = libraryOpsService;
    }

    // READ - List all authors with search & nationality filter
    @GetMapping
    public String listAuthors(@RequestParam(required = false) String q,
                              @RequestParam(required = false, defaultValue = "ALL") String nationality,
                              Model model) {
        List<Author> authors = authorService.filterAuthors(q, nationality, false);
        model.addAttribute("authors", authors);
        model.addAttribute("nationalities", authorService.getAllNationalities());
        model.addAttribute("query", q != null ? q : "");
        model.addAttribute("selectedNationality", nationality);
        model.addAttribute("pageTitle", "Authors Directory");
        return "authors/list";
    }

    // READ - Author profile with full bibliography
    @GetMapping("/{id}")
    public String viewAuthor(@PathVariable Long id, Model model) {
        Author author = authorService.getAuthorById(id);
        model.addAttribute("author", author);
        model.addAttribute("authorBooks", bookService.getBooksByAuthorId(id));
        model.addAttribute("pageTitle", author.getName());
        return "authors/detail";
    }

    // READ - Show authors who have at least one book (inner join)
    @GetMapping("/with-books")
    public String listAuthorsWithBooks(@RequestParam(required = false) String q,
                                       @RequestParam(required = false, defaultValue = "ALL") String nationality,
                                       Model model) {
        List<Author> authors = authorService.filterAuthors(q, nationality, true);
        model.addAttribute("authors", authors);
        model.addAttribute("nationalities", authorService.getAllNationalities());
        model.addAttribute("query", q != null ? q : "");
        model.addAttribute("selectedNationality", nationality);
        model.addAttribute("pageTitle", "Authors With Books (Inner Join)");
        model.addAttribute("joinedView", true);
        return "authors/list";
    }

    // CREATE - Show blank form
    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("author", new Author());
        model.addAttribute("pageTitle", "Add New Author");
        model.addAttribute("formAction", "/authors/save");
        model.addAttribute("buttonLabel", "Save Author");
        return "authors/form";
    }

    // CREATE - Handle form submission
    @PostMapping("/save")
    public String saveAuthor(@Valid @ModelAttribute("author") Author author,
                             BindingResult bindingResult,
                             HttpServletRequest request,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Add New Author");
            model.addAttribute("formAction", "/authors/save");
            model.addAttribute("buttonLabel", "Save Author");
            return "authors/form";
        }
        Author saved = authorService.saveAuthor(author);
        Member currentUser = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("AUTHOR_CREATED", "CATALOG",
                currentUser != null ? currentUser.getFullName() : "Librarian",
                "Added author \"" + saved.getName() + "\" (" + saved.getNationality() + ")");
        redirectAttributes.addFlashAttribute("successMessage",
                "Author \"" + saved.getName() + "\" saved successfully!");
        return "redirect:/authors";
    }

    // UPDATE - Show populated edit form
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model) {
        Author author = authorService.getAuthorById(id);
        model.addAttribute("author", author);
        model.addAttribute("pageTitle", "Edit Author");
        model.addAttribute("formAction", "/authors/update/" + id);
        model.addAttribute("buttonLabel", "Update Author");
        return "authors/form";
    }

    // UPDATE - Handle update request
    @PostMapping("/update/{id}")
    public String updateAuthor(@PathVariable Long id,
                               @Valid @ModelAttribute("author") Author author,
                               BindingResult bindingResult,
                               HttpServletRequest request,
                               Model model,
                               RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Edit Author");
            model.addAttribute("formAction", "/authors/update/" + id);
            model.addAttribute("buttonLabel", "Update Author");
            return "authors/form";
        }
        Author updated = authorService.updateAuthor(id, author);
        Member currentUser = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("AUTHOR_UPDATED", "CATALOG",
                currentUser != null ? currentUser.getFullName() : "Librarian",
                "Updated author profile for \"" + updated.getName() + "\"");
        redirectAttributes.addFlashAttribute("successMessage", "Author updated successfully!");
        return "redirect:/authors";
    }

    // DELETE
    @GetMapping("/delete/{id}")
    public String deleteAuthor(@PathVariable Long id,
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        Author author = authorService.getAuthorById(id);
        authorService.deleteAuthor(id);
        Member currentUser = (Member) request.getAttribute("currentUser");
        libraryOpsService.logActivity("AUTHOR_DELETED", "CATALOG",
                currentUser != null ? currentUser.getFullName() : "Librarian",
                "Removed author \"" + author.getName() + "\" and associated books");
        redirectAttributes.addFlashAttribute("successMessage", "Author deleted successfully!");
        return "redirect:/authors";
    }
}
