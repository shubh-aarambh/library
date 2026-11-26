package com.library.repository;

import com.library.model.HoldRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HoldRequestRepository extends JpaRepository<HoldRequest, Long> {

    List<HoldRequest> findAllByOrderByRequestedAtDesc();

    List<HoldRequest> findByStatusOrderByRequestedAtAsc(String status);

    @Query("SELECT h FROM HoldRequest h WHERE h.member.id = :memberId AND h.status IN ('WAITING', 'READY') ORDER BY h.requestedAt ASC")
    List<HoldRequest> findActiveHoldsByMemberId(@Param("memberId") Long memberId);

    @Query("SELECT h FROM HoldRequest h WHERE h.book.id = :bookId AND h.status = 'WAITING' ORDER BY h.requestedAt ASC")
    List<HoldRequest> findWaitingQueueForBook(@Param("bookId") Long bookId);

    @Query("SELECT COUNT(h) FROM HoldRequest h WHERE h.member.id = :memberId AND h.book.id = :bookId AND h.status IN ('WAITING', 'READY')")
    long countActiveHoldForMemberAndBook(@Param("memberId") Long memberId, @Param("bookId") Long bookId);

    long countByStatus(String status);
}

