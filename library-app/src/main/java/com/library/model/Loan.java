package com.library.model;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;

@Entity
@Table(name = "loans")
public class Loan {

    public static final double DAILY_FINE_RATE = 1.50;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "book_id", nullable = false, foreignKey = @ForeignKey(name = "fk_loans_book"))
    private Book book;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "member_id", nullable = false, foreignKey = @ForeignKey(name = "fk_loans_member"))
    private Member member;

    @Column(name = "borrowed_at", nullable = false)
    private LocalDateTime borrowedAt = LocalDateTime.now();

    @Column(name = "due_date", nullable = false)
    private LocalDate dueDate;

    @Column(name = "returned_at")
    private LocalDateTime returnedAt;

    @Column(nullable = false, length = 20)
    private String status = "ACTIVE"; // ACTIVE, RETURNED, OVERDUE

    @Column(name = "fine_amount", nullable = false)
    private Double fineAmount = 0.0;

    @Column(name = "fine_paid", nullable = false)
    private Boolean finePaid = false;

    @Column(name = "reading_progress", nullable = false)
    private Integer readingProgress = 0;

    @Column(name = "pickup_code", length = 24)
    private String pickupCode;

    @Column(length = 300)
    private String notes;

    public Loan() {
    }

    public Loan(Book book, Member member, LocalDate dueDate, String notes) {
        this.book = book;
        this.member = member;
        this.borrowedAt = LocalDateTime.now();
        this.dueDate = dueDate != null ? dueDate : LocalDate.now().plusDays(14);
        this.status = "ACTIVE";
        this.fineAmount = 0.0;
        this.finePaid = false;
        this.readingProgress = 0;
        this.pickupCode = generatePickupCode();
        this.notes = notes;
    }

    private static String generatePickupCode() {
        int code = 1000 + (int) (Math.random() * 9000);
        return "ATH-" + code;
    }

    public boolean isOverdueNow() {
        return !"RETURNED".equalsIgnoreCase(status) && dueDate != null && LocalDate.now().isAfter(dueDate);
    }

    public long getDaysRemaining() {
        if (dueDate == null) return 0;
        return ChronoUnit.DAYS.between(LocalDate.now(), dueDate);
    }

    public long getDaysOverdue() {
        if (dueDate == null) return 0;
        LocalDate ref = returnedAt != null ? returnedAt.toLocalDate() : LocalDate.now();
        long diff = ChronoUnit.DAYS.between(dueDate, ref);
        return Math.max(0, diff);
    }

    public double getComputedFine() {
        if (fineAmount != null && fineAmount > 0) {
            return fineAmount;
        }
        long overdueDays = getDaysOverdue();
        return overdueDays > 0 ? Math.round(overdueDays * DAILY_FINE_RATE * 100.0) / 100.0 : 0.0;
    }

    public String getFormattedBorrowedDate() {
        return borrowedAt != null ? borrowedAt.format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) : "";
    }

    public String getFormattedDueDate() {
        return dueDate != null ? dueDate.format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) : "";
    }

    public String getFormattedReturnedDate() {
        return returnedAt != null ? returnedAt.format(DateTimeFormatter.ofPattern("MMM dd, yyyy")) : "—";
    }

    // ---- Getters & Setters ----

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

    public LocalDateTime getBorrowedAt() {
        return borrowedAt;
    }

    public void setBorrowedAt(LocalDateTime borrowedAt) {
        this.borrowedAt = borrowedAt;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    public LocalDateTime getReturnedAt() {
        return returnedAt;
    }

    public void setReturnedAt(LocalDateTime returnedAt) {
        this.returnedAt = returnedAt;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Double getFineAmount() {
        return fineAmount != null ? fineAmount : 0.0;
    }

    public void setFineAmount(Double fineAmount) {
        this.fineAmount = fineAmount != null ? fineAmount : 0.0;
    }

    public Boolean getFinePaid() {
        return finePaid != null && finePaid;
    }

    public void setFinePaid(Boolean finePaid) {
        this.finePaid = finePaid != null && finePaid;
    }

    public Integer getReadingProgress() {
        return readingProgress != null ? readingProgress : 0;
    }

    public void setReadingProgress(Integer readingProgress) {
        this.readingProgress = readingProgress != null ? Math.min(100, Math.max(0, readingProgress)) : 0;
    }

    public String getPickupCode() {
        return pickupCode != null ? pickupCode : "ATH-1024";
    }

    public void setPickupCode(String pickupCode) {
        this.pickupCode = pickupCode;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }
}
