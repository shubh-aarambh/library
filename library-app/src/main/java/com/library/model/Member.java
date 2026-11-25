package com.library.model;

import javax.persistence.*;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotBlank;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Entity
@Table(name = "members", uniqueConstraints = {
        @UniqueConstraint(columnNames = "email", name = "uk_members_email")
})
public class Member {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Full name is required")
    @Column(name = "full_name", nullable = false, length = 150)
    private String fullName;

    @NotBlank(message = "Email is required")
    @Email(message = "Please enter a valid email address")
    @Column(nullable = false, unique = true, length = 180)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 256)
    private String passwordHash;

    @Column(nullable = false, length = 20)
    private String role = "MEMBER"; // MEMBER or ADMIN

    @Column(name = "membership_tier", nullable = false, length = 30)
    private String membershipTier = "STANDARD"; // STANDARD, SCHOLAR, VIP

    @Column(nullable = false)
    private Boolean active = true;

    @Column(name = "joined_at", nullable = false)
    private LocalDateTime joinedAt = LocalDateTime.now();

    public Member() {
    }

    public Member(String fullName, String email, String passwordHash, String role, String membershipTier) {
        this.fullName = fullName;
        this.email = email;
        this.passwordHash = passwordHash;
        this.role = role != null ? role : "MEMBER";
        this.membershipTier = membershipTier != null ? membershipTier : "STANDARD";
        this.active = true;
        this.joinedAt = LocalDateTime.now();
    }

    public boolean isAdmin() {
        return "ADMIN".equalsIgnoreCase(this.role);
    }

    public String getInitials() {
        if (fullName == null || fullName.isBlank()) {
            return "U";
        }
        String[] parts = fullName.trim().split("\\s+");
        if (parts.length == 1) {
            return parts[0].substring(0, Math.min(2, parts[0].length())).toUpperCase();
        }
        return (parts[0].substring(0, 1) + parts[parts.length - 1].substring(0, 1)).toUpperCase();
    }

    public String getFormattedJoinedDate() {
        if (joinedAt == null) return "";
        return joinedAt.format(DateTimeFormatter.ofPattern("MMM dd, yyyy"));
    }

    public int getBorrowLimit() {
        if ("VIP".equalsIgnoreCase(membershipTier)) return 10;
        if ("SCHOLAR".equalsIgnoreCase(membershipTier)) return 6;
        return 3;
    }

    // ---- Getters & Setters ----

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getMembershipTier() {
        return membershipTier;
    }

    public void setMembershipTier(String membershipTier) {
        this.membershipTier = membershipTier;
    }

    public Boolean getActive() {
        return active != null && active;
    }

    public void setActive(Boolean active) {
        this.active = active != null && active;
    }

    public LocalDateTime getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(LocalDateTime joinedAt) {
        this.joinedAt = joinedAt;
    }
}

