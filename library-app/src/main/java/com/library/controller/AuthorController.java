package com.library.controller;

import com.library.model.Author;
import com.library.service.AuthorService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;
import java.util.List;

@Controller
@RequestMapping("/authors")
public class AuthorController {

    private final AuthorService authorService;

    public AuthorController(AuthorService authorService) {
        this.authorService = authorService;
    }

    // READ - List all authors
    @GetMapping
    public String listAuthors(Model model) {
        List<Author> authors = authorService.getAllAuthors();
        model.addAttribute("authors", authors);
        model.addAttribute("pageTitle", "All Authors");
        return "authors/list";
    }

    // READ - Show authors who have at least one book (inner join)
    @GetMapping("/with-books")
    public String listAuthorsWithBooks(Model model) {
        List<Author> authors = authorService.getAuthorsWithAtLeastOneBook();
        model.addAttribute("authors", authors);
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
            Model model,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Add New Author");
            model.addAttribute("formAction", "/authors/save");
            model.addAttribute("buttonLabel", "Save Author");
            return "authors/form";
        }
        authorService.saveAuthor(author);
        redirectAttributes.addFlashAttribute("successMessage",
                "Author \"" + author.getName() + "\" saved successfully!");
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
            Model model,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("pageTitle", "Edit Author");
            model.addAttribute("formAction", "/authors/update/" + id);
            model.addAttribute("buttonLabel", "Update Author");
            return "authors/form";
        }
        authorService.updateAuthor(id, author);
        redirectAttributes.addFlashAttribute("successMessage", "Author updated successfully!");
        return "redirect:/authors";
    }

    // DELETE
    @GetMapping("/delete/{id}")
    public String deleteAuthor(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        authorService.deleteAuthor(id);
        redirectAttributes.addFlashAttribute("successMessage", "Author deleted successfully!");
        return "redirect:/authors";
    }
}
