package com.library.service;

import com.library.model.Author;

import java.util.List;

public interface AuthorService {
    List<Author> getAllAuthors();

    Author getAuthorById(Long id);

    Author saveAuthor(Author author);

    Author updateAuthor(Long id, Author author);

    void deleteAuthor(Long id);

    List<Author> getAuthorsWithAtLeastOneBook();

    boolean authorExists(Long id);

    List<String> getAllNationalities();

    List<Author> filterAuthors(String query, String nationality, boolean onlyWithBooks);
}
