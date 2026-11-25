package com.library.repository;

import com.library.model.Author;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AuthorRepository extends JpaRepository<Author, Long> {

    /**
     * Custom JPQL query performing an INNER JOIN between Author and Book,
     * returning authors who have at least one book.
     */
    @Query("SELECT DISTINCT a FROM Author a INNER JOIN a.books b")
    List<Author> findAuthorsWithAtLeastOneBook();

    /**
     * Find authors by nationality (case-insensitive).
     */
    List<Author> findByNationalityIgnoreCase(String nationality);

    /**
     * Check if an author with given name already exists.
     */
    boolean existsByNameIgnoreCase(String name);

    @Query("SELECT DISTINCT a.nationality FROM Author a ORDER BY a.nationality ASC")
    List<String> findDistinctNationalities();

    @Query("SELECT a FROM Author a WHERE LOWER(a.name) LIKE LOWER(CONCAT('%', :q, '%')) " +
           "OR LOWER(a.nationality) LIKE LOWER(CONCAT('%', :q, '%')) " +
           "OR LOWER(COALESCE(a.notableAward, '')) LIKE LOWER(CONCAT('%', :q, '%')) " +
           "ORDER BY a.name ASC")
    List<Author> searchAuthors(@Param("q") String q);
}
