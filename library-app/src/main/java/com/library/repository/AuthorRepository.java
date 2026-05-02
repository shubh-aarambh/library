package com.library.repository;

import com.library.model.Author;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
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
}
