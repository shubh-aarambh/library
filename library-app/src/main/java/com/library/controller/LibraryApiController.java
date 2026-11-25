package com.library.controller;

import com.library.model.Author;
import com.library.model.Book;
import com.library.service.AuthorService;
import com.library.service.BookService;
import com.library.service.LibraryOpsService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@RestController
public class LibraryApiController {

    private final BookService bookService;
    private final AuthorService authorService;
    private final LibraryOpsService libraryOpsService;

    public LibraryApiController(BookService bookService,
                                AuthorService authorService,
                                LibraryOpsService libraryOpsService) {
        this.bookService = bookService;
        this.authorService = authorService;
        this.libraryOpsService = libraryOpsService;
    }

    @GetMapping("/health")
    public Map<String, Object> health() {
        Map<String, Object> payload = new LinkedHashMap<>();
        payload.put("status", "UP");
        payload.put("service", "Athenaeum Library Platform");
        payload.put("timestamp", Instant.now().toString());
        payload.put("stats", libraryOpsService.getLibraryStats());
        return payload;
    }

    @GetMapping("/api/stats")
    public Map<String, Object> stats() {
        Map<String, Object> result = new LinkedHashMap<>(libraryOpsService.getLibraryStats());
        List<Map<String, Object>> genres = bookService.getGenreBreakdown().stream().map(row -> {
            Map<String, Object> entry = new LinkedHashMap<>();
            entry.put("genre", row[0]);
            entry.put("count", row[1]);
            return entry;
        }).collect(Collectors.toList());
        result.put("genres", genres);
        return result;
    }

    @GetMapping("/api/books")
    public List<Map<String, Object>> booksApi() {
        return bookService.getAllBooks().stream().map(b -> {
            Map<String, Object> dto = new LinkedHashMap<>();
            dto.put("id", b.getId());
            dto.put("title", b.getTitle());
            dto.put("genre", b.getGenre());
            dto.put("publishedYear", b.getPublishedYear());
            dto.put("isbn", b.getIsbn());
            dto.put("rating", b.getRating());
            dto.put("pages", b.getPages());
            dto.put("shelfLocation", b.getShelfLocation());
            dto.put("totalCopies", b.getTotalCopies());
            dto.put("availableCopies", b.getAvailableCopies());
            dto.put("featured", b.getFeatured());
            dto.put("authorId", b.getAuthor() != null ? b.getAuthor().getId() : null);
            dto.put("authorName", b.getAuthor() != null ? b.getAuthor().getName() : null);
            return dto;
        }).collect(Collectors.toList());
    }

    @GetMapping("/api/authors")
    public List<Map<String, Object>> authorsApi() {
        return authorService.getAllAuthors().stream().map(a -> {
            Map<String, Object> dto = new LinkedHashMap<>();
            dto.put("id", a.getId());
            dto.put("name", a.getName());
            dto.put("nationality", a.getNationality());
            dto.put("birthYear", a.getBirthYear());
            dto.put("notableAward", a.getNotableAward());
            dto.put("bookCount", a.getBooks() != null ? a.getBooks().size() : 0);
            return dto;
        }).collect(Collectors.toList());
    }

    @GetMapping(value = "/api/books/export.csv", produces = "text/csv")
    public ResponseEntity<String> exportBooksCsv() {
        StringBuilder sb = new StringBuilder();
        sb.append("ID,Title,Author,Genre,PublishedYear,ISBN,Shelf,TotalCopies,AvailableCopies,Rating\n");
        for (Book b : bookService.getAllBooks()) {
            sb.append(b.getId()).append(",")
                    .append(escapeCsv(b.getTitle())).append(",")
                    .append(escapeCsv(b.getAuthor() != null ? b.getAuthor().getName() : "")).append(",")
                    .append(escapeCsv(b.getGenre())).append(",")
                    .append(b.getPublishedYear()).append(",")
                    .append(escapeCsv(b.getIsbn())).append(",")
                    .append(escapeCsv(b.getShelfLocation())).append(",")
                    .append(b.getTotalCopies()).append(",")
                    .append(b.getAvailableCopies()).append(",")
                    .append(b.getRating()).append("\n");
        }
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"athenaeum-catalog.csv\"")
                .contentType(MediaType.parseMediaType("text/csv"))
                .body(sb.toString());
    }

    private String escapeCsv(String value) {
        if (value == null) return "\"\"";
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }
}

