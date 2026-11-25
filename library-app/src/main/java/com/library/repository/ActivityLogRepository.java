package com.library.repository;

import com.library.model.ActivityLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ActivityLogRepository extends JpaRepository<ActivityLog, Long> {
    List<ActivityLog> findTop15ByOrderByCreatedAtDesc();

    List<ActivityLog> findAllByOrderByCreatedAtDesc();

    List<ActivityLog> findByCategoryOrderByCreatedAtDesc(String category);
}

