package com.library.model;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Min;
import javax.validation.constraints.Max;
import javax.validation.constraints.Size;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "books", uniqueConstraints = {
        @UniqueConstraint(columnNames = "isbn", name = "uk_books_isbn")
})
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Title is required")
    @Column(nullable = false, length = 200)
    private String title;

    @NotBlank(message = "Genre is required")
    @Column(nullable = false, length = 100)
    private String genre;

    @NotNull(message = "Published year is required")
    @Min(value = 1000, message = "Published year must be after 1000")
    @Max(value = 2030, message = "Published year is too far in the future")
    @Column(name = "published_year", nullable = false)
    private Integer publishedYear;

    @NotBlank(message = "ISBN is required")
    @Size(min = 10, max = 20, message = "ISBN must be between 10 and 20 characters")
    @Column(nullable = false, unique = true, length = 20)
    private String isbn;

    @Column(length = 1200)
    private String description;

    @Min(value = 1, message = "Total copies must be at least 1")
    @Max(value = 500, message = "Total copies cannot exceed 500")
    @Column(name = "total_copies", nullable = false)
    private Integer totalCopies = 3;

    @Min(value = 0, message = "Available copies cannot be negative")
    @Column(name = "available_copies", nullable = false)
    private Integer availableCopies = 3;

    @Column(nullable = false)
    private Double rating = 4.5;

    @Column
    private Integer pages = 320;

    @Column(length = 60)
    private String language = "English";

    @Column(name = "shelf_location", length = 40)
    private String shelfLocation = "A-01";

    @Column(name = "cover_color", length = 180)
    private String coverColor = "linear-gradient(145deg, #1e3a5f 0%, #0f172a 100%)";

    @Column(nullable = false)
    private Boolean featured = false;

    @NotNull(message = "Author is required")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "author_id", nullable = false, foreignKey = @ForeignKey(name = "fk_books_author"))
    private Author author;

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<Loan> loans = new ArrayList<>();

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<BookReview> reviews = new ArrayList<>();

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<ReadingListItem> readingListItems = new ArrayList<>();

    // ---- Constructors ----

    public Book() {
    }

    public Book(String title, String genre, Integer publishedYear, String isbn, String description, Author author) {
        this.title = title;
        this.genre = genre;
        this.publishedYear = publishedYear;
        this.isbn = isbn;
        this.description = description;
        this.author = author;
    }

    public Book(String title, String genre, Integer publishedYear, String isbn, String description, Author author,
                Integer totalCopies, Integer availableCopies, Double rating, Integer pages,
                String language, String shelfLocation, String coverColor, Boolean featured) {
        this(title, genre, publishedYear, isbn, description, author);
        this.totalCopies = totalCopies != null ? totalCopies : 3;
        this.availableCopies = availableCopies != null ? availableCopies : this.totalCopies;
        this.rating = rating != null ? rating : 4.5;
        this.pages = pages != null ? pages : 320;
        this.language = language != null ? language : "English";
        this.shelfLocation = shelfLocation != null ? shelfLocation : "A-01";
        this.coverColor = coverColor != null ? coverColor : "linear-gradient(145deg, #1e3a5f 0%, #0f172a 100%)";
        this.featured = featured != null && featured;
    }

    // ---- Helpers ----

    public boolean isAvailable() {
        return availableCopies != null && availableCopies > 0;
    }

    public int getBorrowedCopies() {
        int total = totalCopies != null ? totalCopies : 0;
        int avail = availableCopies != null ? availableCopies : 0;
        return Math.max(0, total - avail);
    }

    public int getAvailabilityPercent() {
        int total = totalCopies != null && totalCopies > 0 ? totalCopies : 1;
        int avail = availableCopies != null ? availableCopies : 0;
        return Math.min(100, Math.max(0, (int) Math.round((avail * 100.0) / total)));
    }

    // ---- Getters & Setters ----

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public Integer getPublishedYear() {
        return publishedYear;
    }

    public void setPublishedYear(Integer publishedYear) {
        this.publishedYear = publishedYear;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getTotalCopies() {
        return totalCopies != null ? totalCopies : 3;
    }

    public void setTotalCopies(Integer totalCopies) {
        this.totalCopies = totalCopies != null ? totalCopies : 3;
    }

    public Integer getAvailableCopies() {
        return availableCopies != null ? availableCopies : 0;
    }

    public void setAvailableCopies(Integer availableCopies) {
        this.availableCopies = availableCopies != null ? availableCopies : 0;
    }

    public Double getRating() {
        return rating != null ? rating : 4.5;
    }

    public void setRating(Double rating) {
        this.rating = rating != null ? rating : 4.5;
    }

    public Integer getPages() {
        return pages != null ? pages : 320;
    }

    public void setPages(Integer pages) {
        this.pages = pages;
    }

    public String getLanguage() {
        return language != null ? language : "English";
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getShelfLocation() {
        return shelfLocation != null ? shelfLocation : "A-01";
    }

    public void setShelfLocation(String shelfLocation) {
        this.shelfLocation = shelfLocation;
    }

    public String getCoverColor() {
        return coverColor != null ? coverColor : "linear-gradient(145deg, #1e3a5f 0%, #0f172a 100%)";
    }

    public void setCoverColor(String coverColor) {
        this.coverColor = coverColor;
    }

    public Boolean getFeatured() {
        return featured != null && featured;
    }

    public void setFeatured(Boolean featured) {
        this.featured = featured != null && featured;
    }

    public Author getAuthor() {
        return author;
    }

    public void setAuthor(Author author) {
        this.author = author;
    }

    public List<Loan> getLoans() {
        return loans;
    }

    public void setLoans(List<Loan> loans) {
        this.loans = loans;
    }

    public List<BookReview> getReviews() {
        return reviews;
    }

    public void setReviews(List<BookReview> reviews) {
        this.reviews = reviews;
    }

    public List<ReadingListItem> getReadingListItems() {
        return readingListItems;
    }

    public void setReadingListItems(List<ReadingListItem> readingListItems) {
        this.readingListItems = readingListItems;
    }

    @Override
    public String toString() {
        return "Book{id=" + id + ", title='" + title + "', genre='" + genre + "', isbn='" + isbn + "'}";
    }
}
