package com.library.model;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Min;
import javax.validation.constraints.Max;
import javax.validation.constraints.Size;

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

    @Column(length = 1000)
    private String description;

    @NotNull(message = "Author is required")
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "author_id", nullable = false, foreignKey = @ForeignKey(name = "fk_books_author"))
    private Author author;

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

    public Author getAuthor() {
        return author;
    }

    public void setAuthor(Author author) {
        this.author = author;
    }

    @Override
    public String toString() {
        return "Book{id=" + id + ", title='" + title + "', genre='" + genre + "', isbn='" + isbn + "'}";
    }
}
