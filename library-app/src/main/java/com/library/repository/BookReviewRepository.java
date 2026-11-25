package com.library.repository;

import com.library.model.BookReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookReviewRepository extends JpaRepository<BookReview, Long> {
    List<BookReview> findByBookIdOrderByCreatedAtDesc(Long bookId);

    @Query("SELECT AVG(r.rating) FROM BookReview r WHERE r.book.id = :bookId")
    Double findAverageRatingByBookId(@Param("bookId") Long bookId);

    long countByBookId(Long bookId);
}

