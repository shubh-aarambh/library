package com.library.service;

import com.library.model.*;
import com.library.repository.*;
import com.library.security.PasswordUtil;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@Transactional
@DisplayName("LibraryOpsService Integration Tests")
class LibraryOpsServiceTest {

    @Autowired
    private LibraryOpsService libraryOpsService;

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Test
    @DisplayName("PasswordUtil hashes and verifies passwords with salted PBKDF2")
    void testPasswordHashing() {
        String hash = PasswordUtil.hash("secret123");
        assertThat(hash).contains(":");
        assertThat(PasswordUtil.matches("secret123", hash)).isTrue();
        assertThat(PasswordUtil.matches("wrongpass", hash)).isFalse();
    }

    @Test
    @DisplayName("Seeded admin and demo reader authenticate properly")
    void testSeededAuthentication() {
        Optional<Member> admin = libraryOpsService.authenticate("admin@library.dev", "admin123");
        assertThat(admin).isPresent();
        assertThat(admin.get().isAdmin()).isTrue();

        Optional<Member> reader = libraryOpsService.authenticate("reader@library.dev", "reader123");
        assertThat(reader).isPresent();
        assertThat(reader.get().isAdmin()).isFalse();

        assertThat(libraryOpsService.authenticate("admin@library.dev", "badpass")).isEmpty();
    }

    @Test
    @DisplayName("Member registration creates active member and prevents duplicates")
    void testRegisterMember() {
        Member created = libraryOpsService.registerMember("Test Scholar", "scholar@test.dev", "pass1234", "SCHOLAR");
        assertThat(created.getId()).isNotNull();
        assertThat(created.getMembershipTier()).isEqualTo("SCHOLAR");
        assertThat(created.getBorrowLimit()).isEqualTo(6);

        assertThatThrownBy(() -> libraryOpsService.registerMember("Dup", "scholar@test.dev", "pass1234", "STANDARD"))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    @DisplayName("Borrow, reading progress, renew, and return workflow updates inventory accurately")
    void testBorrowRenewReturnLifecycle() {
        Member member = libraryOpsService.registerMember("Circulation Tester", "circ@test.dev", "pass1234", "STANDARD");
        Book book = bookRepository.findAll().stream().filter(Book::isAvailable).findFirst().orElseThrow();
        int copiesBefore = book.getAvailableCopies();

        Loan loan = libraryOpsService.borrowBook(book.getId(), member.getId(), 14, "Test loan", member.getFullName());
        assertThat(loan.getStatus()).isEqualTo("ACTIVE");
        assertThat(loan.getPickupCode()).startsWith("ATH-");
        assertThat(bookRepository.findById(book.getId()).orElseThrow().getAvailableCopies()).isEqualTo(copiesBefore - 1);

        Loan progressed = libraryOpsService.updateLoanProgress(loan.getId(), member.getId(), 75);
        assertThat(progressed.getReadingProgress()).isEqualTo(75);

        Loan renewed = libraryOpsService.renewLoan(loan.getId(), 7, member.getFullName());
        assertThat(renewed.getDueDate()).isAfter(loan.getBorrowedAt().toLocalDate().plusDays(14));

        Loan returned = libraryOpsService.returnBook(loan.getId(), member.getFullName());
        assertThat(returned.getStatus()).isEqualTo("RETURNED");
        assertThat(bookRepository.findById(book.getId()).orElseThrow().getAvailableCopies()).isEqualTo(copiesBefore);
    }

    @Test
    @DisplayName("Waitlist hold queues when copies are unavailable and promotes cleanly")
    void testWaitlistHoldFlow() {
        Member member = libraryOpsService.registerMember("Waitlist Tester", "wait@test.dev", "pass1234", "STANDARD");
        Book checkedOutBook = bookRepository.findAll().stream()
                .filter(b -> !b.isAvailable())
                .findFirst()
                .orElseThrow();

        HoldRequest hold = libraryOpsService.placeHold(checkedOutBook.getId(), member.getId());
        assertThat(hold.getStatus()).isEqualTo("WAITING");
        assertThat(libraryOpsService.hasActiveHoldForBook(member.getId(), checkedOutBook.getId())).isTrue();

        libraryOpsService.cancelHold(hold.getId(), member.getId(), false, member.getFullName());
        assertThat(libraryOpsService.hasActiveHoldForBook(member.getId(), checkedOutBook.getId())).isFalse();
    }

    @Test
    @DisplayName("Adding reviews recalculates average rating and reading list toggles cleanly")
    void testReviewsAndReadingList() {
        Member member = memberRepository.findByEmailIgnoreCase("reader@library.dev").orElseThrow();
        Book book = bookRepository.findAll().get(0);

        BookReview review = libraryOpsService.addReview(book.getId(), member.getId(), 5, "Incredible literary depth.");
        assertThat(review.getId()).isNotNull();
        List<BookReview> reviews = libraryOpsService.getReviewsForBook(book.getId());
        assertThat(reviews).isNotEmpty();

        boolean added = libraryOpsService.toggleReadingList(member.getId(), book.getId());
        assertThat(libraryOpsService.isInReadingList(member.getId(), book.getId())).isEqualTo(added);
    }

    @Test
    @DisplayName("Dashboard stats report accurate library telemetry including holds")
    void testLibraryStats() {
        Map<String, Object> stats = libraryOpsService.getLibraryStats();
        assertThat((Long) stats.get("totalBooks")).isGreaterThanOrEqualTo(10L);
        assertThat((Long) stats.get("totalAuthors")).isGreaterThanOrEqualTo(10L);
        assertThat((Long) stats.get("totalMembers")).isGreaterThanOrEqualTo(4L);
        assertThat((Long) stats.get("openHolds")).isGreaterThanOrEqualTo(1L);
    }
}
