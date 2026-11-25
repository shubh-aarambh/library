package com.library.repository;

import com.library.model.Loan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LoanRepository extends JpaRepository<Loan, Long> {
    List<Loan> findAllByOrderByBorrowedAtDesc();

    List<Loan> findByMemberIdOrderByBorrowedAtDesc(Long memberId);

    List<Loan> findByStatusOrderByDueDateAsc(String status);

    @Query("SELECT l FROM Loan l WHERE l.member.id = :memberId AND l.status <> 'RETURNED' ORDER BY l.dueDate ASC")
    List<Loan> findActiveLoansByMemberId(@Param("memberId") Long memberId);

    @Query("SELECT COUNT(l) FROM Loan l WHERE l.member.id = :memberId AND l.book.id = :bookId AND l.status <> 'RETURNED'")
    long countActiveLoanForMemberAndBook(@Param("memberId") Long memberId, @Param("bookId") Long bookId);

    @Query("SELECT COUNT(l) FROM Loan l WHERE l.status = 'ACTIVE' OR l.status = 'OVERDUE'")
    long countAllOpenLoans();

    long countByStatus(String status);

    @Query("SELECT COALESCE(SUM(l.fineAmount), 0.0) FROM Loan l WHERE l.finePaid = false")
    Double sumUnpaidFines();
}

