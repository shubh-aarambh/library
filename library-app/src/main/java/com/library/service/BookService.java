package com.library.service;

import com.library.model.Book;

import java.util.List;

public interface BookService {
    List<Book> getAllBooks();

    Book getBookById(Long id);

    Book saveBook(Book book);

    Book updateBook(Long id, Book book);

    void deleteBook(Long id);

    List<Object[]> getAllBooksWithAuthorDetails();

    List<Book> getBooksByAuthorId(Long authorId);

    boolean bookExists(Long id);

    List<String> getAllGenres();

    List<Book> getFeaturedBooks();

    List<Book> getTopRatedBooks();

    List<Book> getQuickReads();

    List<Book> filterBooks(String query, String genre, String availability, String sort);

    Book toggleFeatured(Long id);

    Book adjustCopies(Long id, int delta);

    List<Object[]> getGenreBreakdown();
}
