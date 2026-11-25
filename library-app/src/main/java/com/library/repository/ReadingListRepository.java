package com.library.repository;

import com.library.model.ReadingListItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReadingListRepository extends JpaRepository<ReadingListItem, Long> {
    List<ReadingListItem> findByMemberIdOrderByAddedAtDesc(Long memberId);

    Optional<ReadingListItem> findByMemberIdAndBookId(Long memberId, Long bookId);

    boolean existsByMemberIdAndBookId(Long memberId, Long bookId);
}

