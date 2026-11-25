package com.library.controller;

import com.library.model.Author;
import com.library.model.Book;
import com.library.service.AuthorService;
import com.library.service.BookService;
import com.library.service.LibraryOpsService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;
import java.util.stream.Collectors;

@Controller
public class HomeController {

    private final BookService bookService;
    private final AuthorService authorService;
    private final LibraryOpsService libraryOpsService;

    public HomeController(BookService bookService,
                          AuthorService authorService,
                          LibraryOpsService libraryOpsService) {
        this.bookService = bookService;
        this.authorService = authorService;
        this.libraryOpsService = libraryOpsService;
    }

    @GetMapping("/")
    public String home(Model model) {
        List<Book> featuredBooks = bookService.getFeaturedBooks().stream().limit(6).collect(Collectors.toList());
        List<Author> spotlightAuthors = authorService.getAuthorsWithAtLeastOneBook().stream().limit(6).collect(Collectors.toList());
        model.addAttribute("stats", libraryOpsService.getLibraryStats());
        model.addAttribute("featuredBooks", featuredBooks);
        model.addAttribute("spotlightAuthors", spotlightAuthors);
        model.addAttribute("genres", bookService.getAllGenres());
        model.addAttribute("genreBreakdown", bookService.getGenreBreakdown());
        return "index";
    }
}
