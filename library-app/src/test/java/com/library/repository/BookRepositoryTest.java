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
@DisplayName("BookRepository Unit Tests")
class BookRepositoryTest {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private BookRepository bookRepository;

    private Author author;
    private Book book1;
    private Book book2;

    @BeforeEach
    void setUp() {
        author = new Author("Ernest Hemingway", "American", 1899, "A Nobel Prize author.");
        entityManager.persistAndFlush(author);

        book1 = new Book("The Old Man and the Sea", "Fiction", 1952, "ISBN-T01-001", "A fisherman's struggle.", author);
        book2 = new Book("A Farewell to Arms", "Fiction", 1929, "ISBN-T02-002", "A wartime love story.", author);
        entityManager.persistAndFlush(book1);
        entityManager.persistAndFlush(book2);
    }

    @Test
    @DisplayName("Save and find book by ID")
    void testSaveAndFindById() {
        Optional<Book> found = bookRepository.findById(book1.getId());
        assertThat(found).isPresent();
        assertThat(found.get().getTitle()).isEqualTo("The Old Man and the Sea");
    }

    @Test
    @DisplayName("Find all books")
    void testFindAll() {
        List<Book> books = bookRepository.findAll();
        assertThat(books).hasSize(2);
    }

    @Test
    @DisplayName("Find books by author ID")
    void testFindByAuthorId() {
        List<Book> books = bookRepository.findByAuthorId(author.getId());
        assertThat(books).hasSize(2);
    }

    @Test
    @DisplayName("Find books by genre - case insensitive")
    void testFindByGenreIgnoreCase() {
        List<Book> fiction = bookRepository.findByGenreIgnoreCase("fiction");
        assertThat(fiction).hasSize(2);
    }

    @Test
    @DisplayName("existsByIsbn returns true for existing ISBN")
    void testExistsByIsbn() {
        assertThat(bookRepository.existsByIsbn("ISBN-T01-001")).isTrue();
        assertThat(bookRepository.existsByIsbn("UNKNOWN-ISBN")).isFalse();
    }

    @Test
    @DisplayName("Find books by published year")
    void testFindByPublishedYear() {
        List<Book> books1952 = bookRepository.findByPublishedYear(1952);
        assertThat(books1952).hasSize(1);
        assertThat(books1952.get(0).getTitle()).isEqualTo("The Old Man and the Sea");
    }

    @Test
    @DisplayName("Inner join query returns books with author details")
    void testFindAllBooksWithAuthorDetails() {
        List<Object[]> rows = bookRepository.findAllBooksWithAuthorDetails();
        assertThat(rows).hasSize(2);
        // row[4] is author name
        assertThat(rows.get(0)[4]).isEqualTo("Ernest Hemingway");
    }

    @Test
    @DisplayName("Delete book removes from database")
    void testDeleteBook() {
        bookRepository.delete(book1);
        assertThat(bookRepository.findById(book1.getId())).isEmpty();
    }

    @Test
    @DisplayName("findBooksByAuthorIdJoined returns correct books")
    void testFindBooksByAuthorIdJoined() {
        List<Book> books = bookRepository.findBooksByAuthorIdJoined(author.getId());
        assertThat(books).hasSize(2);
    }
}
