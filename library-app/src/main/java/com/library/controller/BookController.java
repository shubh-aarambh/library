package com.library.controller;

import com.library.model.Author;
import com.library.model.Book;
import com.library.service.AuthorService;
import com.library.service.BookService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;
import java.util.List;

@Controller
@RequestMapping("/books")
public class BookController {

    private final BookService bookService;
    private final AuthorService authorService;

    public BookController(BookService bookService, AuthorService authorService) {
        this.bookService = bookService;
        this.authorService = authorService;
    }

    // READ - List all books
    @GetMapping
    public String listBooks(Model model) {
        List<Book> books = bookService.getAllBooks();
        model.addAttribute("books", books);
        model.addAttribute("pageTitle", "All Books");
        return "books/list";
    }

    // READ - Inner join view: all books with author details
    @GetMapping("/joined")
    public String listBooksJoined(Model model) {
        List<Object[]> rows = bookService.getAllBooksWithAuthorDetails();
        model.addAttribute("rows", rows);
        model.addAttribute("pageTitle", "Books with Author Details (Inner Join)");
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
            Model model,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("authors", authorService.getAllAuthors());
            model.addAttribute("pageTitle", "Add New Book");
            model.addAttribute("formAction", "/books/save");
            model.addAttribute("buttonLabel", "Save Book");
            return "books/form";
        }
        bookService.saveBook(book);
        redirectAttributes.addFlashAttribute("successMessage", "Book \"" + book.getTitle() + "\" saved successfully!");
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
            Model model,
            RedirectAttributes redirectAttributes) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("authors", authorService.getAllAuthors());
            model.addAttribute("pageTitle", "Edit Book");
            model.addAttribute("formAction", "/books/update/" + id);
            model.addAttribute("buttonLabel", "Update Book");
            return "books/form";
        }
        bookService.updateBook(id, book);
        redirectAttributes.addFlashAttribute("successMessage", "Book updated successfully!");
        return "redirect:/books";
    }

    // DELETE
    @GetMapping("/delete/{id}")
    public String deleteBook(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        bookService.deleteBook(id);
        redirectAttributes.addFlashAttribute("successMessage", "Book deleted successfully!");
        return "redirect:/books";
    }
}
