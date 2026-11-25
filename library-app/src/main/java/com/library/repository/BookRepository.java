package com.library.repository;

import com.library.model.Book;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookRepository extends JpaRepository<Book, Long> {

    /**
     * Custom JPQL query: INNER JOIN between Book and Author,
     * returning a flat projection of book title, genre, isbn, published year, and
     * author name.
     */
    @Query("SELECT b.title, b.genre, b.isbn, b.publishedYear, a.name " +
            "FROM Book b INNER JOIN b.author a " +
            "ORDER BY a.name, b.title")
    List<Object[]> findAllBooksWithAuthorDetails();

    /**
     * Find all books belonging to a specific author.
     */
    List<Book> findByAuthorId(Long authorId);

    /**
     * Find books by genre (case-insensitive).
     */
    List<Book> findByGenreIgnoreCase(String genre);

    /**
     * Check if a book with the given ISBN already exists.
     */
    boolean existsByIsbn(String isbn);

    /**
     * Find books published in a given year.
     */
    List<Book> findByPublishedYear(Integer year);

    /**
     * Find books by author id that also use a custom JPQL inner join.
     */
    @Query("SELECT b FROM Book b INNER JOIN b.author a WHERE a.id = :authorId")
    List<Book> findBooksByAuthorIdJoined(@Param("authorId") Long authorId);

    @Query("SELECT DISTINCT b.genre FROM Book b ORDER BY b.genre ASC")
    List<String> findDistinctGenres();

    List<Book> findByFeaturedTrueOrderByRatingDesc();

    List<Book> findTop6ByOrderByRatingDesc();

    @Query("SELECT b.genre, COUNT(b) FROM Book b GROUP BY b.genre ORDER BY COUNT(b) DESC")
    List<Object[]> countBooksByGenre();

    @Query("SELECT b FROM Book b INNER JOIN b.author a " +
           "WHERE LOWER(b.title) LIKE LOWER(CONCAT('%', :q, '%')) " +
           "OR LOWER(b.genre) LIKE LOWER(CONCAT('%', :q, '%')) " +
           "OR LOWER(b.isbn) LIKE LOWER(CONCAT('%', :q, '%')) " +
           "OR LOWER(a.name) LIKE LOWER(CONCAT('%', :q, '%')) " +
           "ORDER BY b.title ASC")
    List<Book> searchBooks(@Param("q") String q);
}
