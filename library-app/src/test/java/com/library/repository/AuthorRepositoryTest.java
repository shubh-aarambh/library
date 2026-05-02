package com.library.repository;

import com.library.model.Author;
import com.library.model.Book;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@DisplayName("AuthorRepository Unit Tests")
class AuthorRepositoryTest {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private AuthorRepository authorRepository;

    private Author author1;
    private Author author2;

    @BeforeEach
    void setUp() {
        author1 = new Author("Jane Austen", "British", 1775, "English novelist known for romance.");
        author2 = new Author("Leo Tolstoy", "Russian", 1828, "Russian novelist of War and Peace.");
        entityManager.persistAndFlush(author1);
        entityManager.persistAndFlush(author2);
    }

    @Test
    @DisplayName("Save and find author by ID")
    void testSaveAndFindById() {
        Optional<Author> found = authorRepository.findById(author1.getId());
        assertThat(found).isPresent();
        assertThat(found.get().getName()).isEqualTo("Jane Austen");
    }

    @Test
    @DisplayName("Find all authors")
    void testFindAll() {
        List<Author> authors = authorRepository.findAll();
        assertThat(authors).hasSize(2);
    }

    @Test
    @DisplayName("Find authors by nationality - case insensitive")
    void testFindByNationalityIgnoreCase() {
        List<Author> british = authorRepository.findByNationalityIgnoreCase("british");
        assertThat(british).hasSize(1);
        assertThat(british.get(0).getName()).isEqualTo("Jane Austen");
    }

    @Test
    @DisplayName("existsByNameIgnoreCase returns true for existing author")
    void testExistsByName() {
        assertThat(authorRepository.existsByNameIgnoreCase("jane austen")).isTrue();
        assertThat(authorRepository.existsByNameIgnoreCase("unknown person")).isFalse();
    }

    @Test
    @DisplayName("Delete author removes from database")
    void testDeleteAuthor() {
        authorRepository.delete(author1);
        Optional<Author> found = authorRepository.findById(author1.getId());
        assertThat(found).isEmpty();
    }

    @Test
    @DisplayName("Inner join — authors with at least one book")
    void testFindAuthorsWithAtLeastOneBook() {
        // author1 has a book, author2 has none
        Book book = new Book("Pride and Prejudice", "Romance", 1813, "ISBN-001-TEST", "Classic romance.", author1);
        entityManager.persistAndFlush(book);

        List<Author> authorsWithBooks = authorRepository.findAuthorsWithAtLeastOneBook();
        assertThat(authorsWithBooks).hasSize(1);
        assertThat(authorsWithBooks.get(0).getName()).isEqualTo("Jane Austen");
    }

    @Test
    @DisplayName("Update author name and save")
    void testUpdateAuthor() {
        author1.setName("Jane Austen Updated");
        authorRepository.save(author1);
        entityManager.flush();
        entityManager.clear();

        Author updated = authorRepository.findById(author1.getId()).orElseThrow();
        assertThat(updated.getName()).isEqualTo("Jane Austen Updated");
    }
}
