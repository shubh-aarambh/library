package com.library.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "hold_requests")
public class HoldRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_id", nullable = false, foreignKey = @ForeignKey(name = "fk_holds_book"))
    private Book book;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "member_id", nullable = false, foreignKey = @ForeignKey(name = "fk_holds_member"))
    private Member member;

    @Column(nullable = false, length = 20)
    private String status = "WAITING"; // WAITING, READY, FULFILLED, CANCELLED

    @Column(name = "requested_at", nullable = false)
    private LocalDateTime requestedAt = LocalDateTime.now();

    @Column(name = "notified_at")
    private LocalDateTime notifiedAt;

    public HoldRequest() {
    }

    public HoldRequest(Book book, Member member) {
        this.book = book;
        this.member = member;
        this.status = "WAITING";
        this.requestedAt = LocalDateTime.now();
    }

    public String getFormattedRequestedDate() {
        return requestedAt != null ? requestedAt.format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) : "";
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public Member getMember() {
        return member;
    }

    public void setMember(Member member) {
        this.member = member;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getRequestedAt() {
        return requestedAt;
    }

    public void setRequestedAt(LocalDateTime requestedAt) {
        this.requestedAt = requestedAt;
    }

    public LocalDateTime getNotifiedAt() {
        return notifiedAt;
    }

    public void setNotifiedAt(LocalDateTime notifiedAt) {
        this.notifiedAt = notifiedAt;
    }
}

