package com.library.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "reading_list", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"member_id", "book_id"}, name = "uk_reading_list_member_book")
})
public class ReadingListItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "member_id", nullable = false, foreignKey = @ForeignKey(name = "fk_reading_list_member"))
    private Member member;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_id", nullable = false, foreignKey = @ForeignKey(name = "fk_reading_list_book"))
    private Book book;

    @Column(name = "added_at", nullable = false)
    private LocalDateTime addedAt = LocalDateTime.now();

    public ReadingListItem() {
    }

    public ReadingListItem(Member member, Book book) {
        this.member = member;
        this.book = book;
        this.addedAt = LocalDateTime.now();
    }

    public String getFormattedAddedDate() {
        return addedAt != null ? addedAt.format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) : "";
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Member getMember() {
        return member;
    }

    public void setMember(Member member) {
        this.member = member;
    }

    public Book getBook() {
        return book;
    }

    public void setBook(Book book) {
        this.book = book;
    }

    public LocalDateTime getAddedAt() {
        return addedAt;
    }

    public void setAddedAt(LocalDateTime addedAt) {
        this.addedAt = addedAt;
    }
}

