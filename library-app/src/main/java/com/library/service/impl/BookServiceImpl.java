package com.library.service.impl;

import com.library.exception.ResourceNotFoundException;
import com.library.model.Author;
import com.library.model.Book;
import com.library.repository.AuthorRepository;
import com.library.repository.BookRepository;
import com.library.service.BookService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class BookServiceImpl implements BookService {

    private final BookRepository bookRepository;
    private final AuthorRepository authorRepository;

    public BookServiceImpl(BookRepository bookRepository, AuthorRepository authorRepository) {
        this.bookRepository = bookRepository;
        this.authorRepository = authorRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Book getBookById(Long id) {
        return bookRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + id));
    }

    @Override
    public Book saveBook(Book book) {
        if (book.getAuthor() != null && book.getAuthor().getId() != null) {
            Author author = authorRepository.findById(book.getAuthor().getId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "Author not found with id: " + book.getAuthor().getId()));
            book.setAuthor(author);
        }
        if (book.getTotalCopies() == null || book.getTotalCopies() < 1) {
            book.setTotalCopies(3);
        }
        if (book.getAvailableCopies() == null) {
            book.setAvailableCopies(book.getTotalCopies());
        } else if (book.getAvailableCopies() > book.getTotalCopies()) {
            book.setAvailableCopies(book.getTotalCopies());
        }
        if (book.getRating() == null) {
            book.setRating(4.5);
        }
        if (book.getCoverColor() == null || book.getCoverColor().isBlank()) {
            book.setCoverColor("linear-gradient(145deg, #1e3a5f 0%, #0f172a 100%)");
        }
        if (book.getFormat() == null || book.getFormat().isBlank()) {
            book.setFormat("BOTH");
        }
        return bookRepository.save(book);
    }

    @Override
    public Book updateBook(Long id, Book updatedBook) {
        Book existing = getBookById(id);
        existing.setTitle(updatedBook.getTitle());
        existing.setGenre(updatedBook.getGenre());
        existing.setPublishedYear(updatedBook.getPublishedYear());
        existing.setIsbn(updatedBook.getIsbn());
        existing.setDescription(updatedBook.getDescription());

        if (updatedBook.getTotalCopies() != null && updatedBook.getTotalCopies() >= 1) {
            int borrowed = existing.getBorrowedCopies();
            existing.setTotalCopies(updatedBook.getTotalCopies());
            if (updatedBook.getAvailableCopies() != null) {
                existing.setAvailableCopies(Math.min(updatedBook.getTotalCopies(), Math.max(0, updatedBook.getAvailableCopies())));
            } else {
                existing.setAvailableCopies(Math.max(0, updatedBook.getTotalCopies() - borrowed));
            }
        }
        if (updatedBook.getPages() != null) {
            existing.setPages(updatedBook.getPages());
        }
        if (updatedBook.getLanguage() != null && !updatedBook.getLanguage().isBlank()) {
            existing.setLanguage(updatedBook.getLanguage());
        }
        if (updatedBook.getShelfLocation() != null && !updatedBook.getShelfLocation().isBlank()) {
            existing.setShelfLocation(updatedBook.getShelfLocation());
        }
        if (updatedBook.getFormat() != null && !updatedBook.getFormat().isBlank()) {
            existing.setFormat(updatedBook.getFormat());
        }
        if (updatedBook.getCoverColor() != null && !updatedBook.getCoverColor().isBlank()) {
            existing.setCoverColor(updatedBook.getCoverColor());
        }
        if (updatedBook.getCoverImageUrl() != null) {
            existing.setCoverImageUrl(updatedBook.getCoverImageUrl());
        }
        if (updatedBook.getLibrarianNote() != null) {
            existing.setLibrarianNote(updatedBook.getLibrarianNote());
        }
        if (updatedBook.getPreviewGuide() != null) {
            existing.setPreviewGuide(updatedBook.getPreviewGuide());
        }
        if (updatedBook.getFeatured() != null) {
            existing.setFeatured(updatedBook.getFeatured());
        }

        if (updatedBook.getAuthor() != null && updatedBook.getAuthor().getId() != null) {
            Author author = authorRepository.findById(updatedBook.getAuthor().getId())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "Author not found with id: " + updatedBook.getAuthor().getId()));
            existing.setAuthor(author);
        }
        return bookRepository.save(existing);
    }

    @Override
    public void deleteBook(Long id) {
        Book book = getBookById(id);
        bookRepository.delete(book);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> getAllBooksWithAuthorDetails() {
        return bookRepository.findAllBooksWithAuthorDetails();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Book> getBooksByAuthorId(Long authorId) {
        return bookRepository.findByAuthorId(authorId);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean bookExists(Long id) {
        return bookRepository.existsById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> getAllGenres() {
        return bookRepository.findDistinctGenres();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Book> getFeaturedBooks() {
        List<Book> featured = bookRepository.findByFeaturedTrueOrderByRatingDesc();
        return featured.isEmpty() ? bookRepository.findTop6ByOrderByRatingDesc() : featured;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Book> getTopRatedBooks() {
        return bookRepository.findTop6ByOrderByRatingDesc();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Book> getQuickReads() {
        return bookRepository.findAll().stream()
                .filter(b -> b.getPages() != null && b.getPages() <= 315)
                .sorted(Comparator.comparing(Book::getPages))
                .limit(6)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<Book> filterBooks(String query, String genre, String availability, String sort) {
        String q = query != null ? query.trim().toLowerCase() : "";
        String g = genre != null ? genre.trim() : "";
        String avail = availability != null ? availability.trim().toUpperCase() : "ALL";
        String sortKey = sort != null ? sort.trim().toLowerCase() : "title";

        Comparator<Book> comparator;
        switch (sortKey) {
            case "rating":
                comparator = Comparator.comparing(Book::getRating, Comparator.reverseOrder())
                        .thenComparing(Book::getTitle, String.CASE_INSENSITIVE_ORDER);
                break;
            case "year_desc":
                comparator = Comparator.comparing(Book::getPublishedYear, Comparator.reverseOrder());
                break;
            case "year_asc":
                comparator = Comparator.comparing(Book::getPublishedYear);
                break;
            case "available":
                comparator = Comparator.comparing(Book::getAvailableCopies, Comparator.reverseOrder())
                        .thenComparing(Book::getTitle, String.CASE_INSENSITIVE_ORDER);
                break;
            case "pages_asc":
                comparator = Comparator.comparing(Book::getPages);
                break;
            default:
                comparator = Comparator.comparing(Book::getTitle, String.CASE_INSENSITIVE_ORDER);
                break;
        }

        return bookRepository.findAll().stream()
                .filter(b -> q.isEmpty()
                        || (b.getTitle() != null && b.getTitle().toLowerCase().contains(q))
                        || (b.getGenre() != null && b.getGenre().toLowerCase().contains(q))
                        || (b.getIsbn() != null && b.getIsbn().toLowerCase().contains(q))
                        || (b.getAuthor() != null && b.getAuthor().getName() != null
                            && b.getAuthor().getName().toLowerCase().contains(q)))
                .filter(b -> g.isEmpty() || g.equalsIgnoreCase("ALL")
                        || (b.getGenre() != null && b.getGenre().equalsIgnoreCase(g)))
                .filter(b -> {
                    if ("AVAILABLE".equals(avail)) return b.isAvailable();
                    if ("UNAVAILABLE".equals(avail)) return !b.isAvailable();
                    return true;
                })
                .sorted(comparator)
                .collect(Collectors.toList());
    }

    @Override
    public Book toggleFeatured(Long id) {
        Book book = getBookById(id);
        book.setFeatured(!book.getFeatured());
        return bookRepository.save(book);
    }

    @Override
    public Book adjustCopies(Long id, int delta) {
        Book book = getBookById(id);
        int newTotal = Math.max(1, book.getTotalCopies() + delta);
        int newAvail = Math.min(newTotal, Math.max(0, book.getAvailableCopies() + delta));
        book.setTotalCopies(newTotal);
        book.setAvailableCopies(newAvail);
        return bookRepository.save(book);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Object[]> getGenreBreakdown() {
        return bookRepository.countBooksByGenre();
    }
}
