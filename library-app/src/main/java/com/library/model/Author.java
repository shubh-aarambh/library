package com.library.model;

import javax.persistence.*;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Min;
import javax.validation.constraints.Max;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "authors")
public class Author {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Name is required")
    @Column(nullable = false, length = 150)
    private String name;

    @NotBlank(message = "Nationality is required")
    @Column(nullable = false, length = 100)
    private String nationality;

    @NotNull(message = "Birth year is required")
    @Min(value = 1000, message = "Birth year must be after 1000")
    @Max(value = 2020, message = "Birth year cannot be in the future")
    @Column(name = "birth_year", nullable = false)
    private Integer birthYear;

    @Column(length = 1000)
    private String biography;

    @Column(name = "notable_award", length = 150)
    private String notableAward;

    @Column(name = "avatar_color", length = 40)
    private String avatarColor = "#d97706";

    @OneToMany(mappedBy = "author", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Book> books = new ArrayList<>();

    // ---- Constructors ----

    public Author() {
    }

    public Author(String name, String nationality, Integer birthYear, String biography) {
        this.name = name;
        this.nationality = nationality;
        this.birthYear = birthYear;
        this.biography = biography;
    }

    public Author(String name, String nationality, Integer birthYear, String biography,
                  String notableAward, String avatarColor) {
        this(name, nationality, birthYear, biography);
        this.notableAward = notableAward;
        this.avatarColor = avatarColor != null ? avatarColor : "#d97706";
    }

    // ---- Helpers ----

    public String getInitials() {
        if (name == null || name.isBlank()) {
            return "AU";
        }
        String[] parts = name.trim().split("\\s+");
        if (parts.length == 1) {
            return parts[0].substring(0, Math.min(2, parts[0].length())).toUpperCase();
        }
        return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }

    // ---- Getters & Setters ----

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNationality() {
        return nationality;
    }

    public void setNationality(String nationality) {
        this.nationality = nationality;
    }

    public Integer getBirthYear() {
        return birthYear;
    }

    public void setBirthYear(Integer birthYear) {
        this.birthYear = birthYear;
    }

    public String getBiography() {
        return biography;
    }

    public void setBiography(String biography) {
        this.biography = biography;
    }

    public String getNotableAward() {
        return notableAward;
    }

    public void setNotableAward(String notableAward) {
        this.notableAward = notableAward;
    }

    public String getAvatarColor() {
        return avatarColor != null ? avatarColor : "#d97706";
    }

    public void setAvatarColor(String avatarColor) {
        this.avatarColor = avatarColor;
    }

    public List<Book> getBooks() {
        return books;
    }

    public void setBooks(List<Book> books) {
        this.books = books;
    }

    @Override
    public String toString() {
        return "Author{id=" + id + ", name='" + name + "', nationality='" + nationality + "', birthYear=" + birthYear
                + "}";
    }
}
