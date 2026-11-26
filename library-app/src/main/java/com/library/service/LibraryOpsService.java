package com.library.service;

import com.library.exception.ResourceNotFoundException;
import com.library.model.*;
import com.library.repository.*;
import com.library.security.PasswordUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

@Service
@Transactional
public class LibraryOpsService {

    private final BookRepository bookRepository;
    private final AuthorRepository authorRepository;
    private final MemberRepository memberRepository;
    private final LoanRepository loanRepository;
    private final BookReviewRepository reviewRepository;
    private final ReadingListRepository readingListRepository;
    private final HoldRequestRepository holdRequestRepository;
    private final ActivityLogRepository activityLogRepository;

    public LibraryOpsService(BookRepository bookRepository,
                             AuthorRepository authorRepository,
                             MemberRepository memberRepository,
                             LoanRepository loanRepository,
                             BookReviewRepository reviewRepository,
                             ReadingListRepository readingListRepository,
                             HoldRequestRepository holdRequestRepository,
                             ActivityLogRepository activityLogRepository) {
        this.bookRepository = bookRepository;
        this.authorRepository = authorRepository;
        this.memberRepository = memberRepository;
        this.loanRepository = loanRepository;
        this.reviewRepository = reviewRepository;
        this.readingListRepository = readingListRepository;
        this.holdRequestRepository = holdRequestRepository;
        this.activityLogRepository = activityLogRepository;
    }

    // =====================================================
    // Authentication & Member Management
    // =====================================================

    @Transactional(readOnly = true)
    public Optional<Member> authenticate(String email, String rawPassword) {
        if (email == null || rawPassword == null) return Optional.empty();
        return memberRepository.findByEmailIgnoreCase(email.trim())
                .filter(Member::getActive)
                .filter(m -> PasswordUtil.matches(rawPassword, m.getPasswordHash()));
    }

    public Member registerMember(String fullName, String email, String rawPassword, String tier) {
        String normalizedEmail = email.trim().toLowerCase();
        if (memberRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new IllegalArgumentException("An account with email " + normalizedEmail + " already exists.");
        }
        String validTier = ("SCHOLAR".equalsIgnoreCase(tier) || "VIP".equalsIgnoreCase(tier))
                ? tier.toUpperCase() : "STANDARD";
        Member member = new Member(fullName.trim(), normalizedEmail, PasswordUtil.hash(rawPassword), "MEMBER", validTier);
        Member saved = memberRepository.save(member);
        logActivity("MEMBER_REGISTERED", "MEMBER", saved.getFullName(),
                "New " + saved.getMembershipTier() + " member registered (" + saved.getEmail() + ")");
        return saved;
    }

    @Transactional(readOnly = true)
    public Member getMemberById(Long id) {
        return memberRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Member not found with id: " + id));
    }

    @Transactional(readOnly = true)
    public Optional<Member> findMemberByEmail(String email) {
        return memberRepository.findByEmailIgnoreCase(email);
    }

    @Transactional(readOnly = true)
    public List<Member> getAllMembers() {
        return memberRepository.findAllByOrderByJoinedAtDesc();
    }

    public Member updateMemberTierAndRole(Long memberId, String tier, String role, String adminName) {
        Member member = getMemberById(memberId);
        if (tier != null && !tier.isBlank()) {
            member.setMembershipTier(tier.toUpperCase());
        }
        if (role != null && !role.isBlank()) {
            member.setRole(role.toUpperCase());
        }
        Member saved = memberRepository.save(member);
        logActivity("MEMBER_UPDATED", "MEMBER", adminName,
                "Updated " + saved.getFullName() + " → role=" + saved.getRole() + ", tier=" + saved.getMembershipTier());
        return saved;
    }

    public Member updateReadingGoal(Long memberId, int goal) {
        Member member = getMemberById(memberId);
        member.setAnnualReadingGoal(goal);
        return memberRepository.save(member);
    }

    public Member toggleMemberStatus(Long memberId, String adminName) {
        Member member = getMemberById(memberId);
        member.setActive(!member.getActive());
        Member saved = memberRepository.save(member);
        logActivity("MEMBER_STATUS_CHANGED", "MEMBER", adminName,
                (saved.getActive() ? "Activated" : "Suspended") + " member account: " + saved.getFullName());
        return saved;
    }

    // =====================================================
    // Circulation & Loans
    // =====================================================

    public Loan borrowBook(Long bookId, Long memberId, Integer loanDays, String notes, String actorName) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + bookId));
        Member member = getMemberById(memberId);

        if (!member.getActive()) {
            throw new IllegalStateException("Member account is suspended and cannot borrow books.");
        }
        if (!book.isAvailable()) {
            throw new IllegalStateException("All copies of \"" + book.getTitle() + "\" are checked out. Join the waitlist instead!");
        }
        if (loanRepository.countActiveLoanForMemberAndBook(memberId, bookId) > 0) {
            throw new IllegalStateException(member.getFullName() + " already has an active loan for \"" + book.getTitle() + "\".");
        }
        List<Loan> activeLoans = loanRepository.findActiveLoansByMemberId(memberId);
        if (activeLoans.size() >= member.getBorrowLimit()) {
            throw new IllegalStateException(member.getFullName() + " reached the borrow limit (" + member.getBorrowLimit() + " books for " + member.getMembershipTier() + " tier).");
        }

        int days = (loanDays != null && loanDays >= 1 && loanDays <= 60) ? loanDays : 14;
        book.setAvailableCopies(book.getAvailableCopies() - 1);
        bookRepository.save(book);

        Loan loan = new Loan(book, member, LocalDate.now().plusDays(days), notes);
        Loan saved = loanRepository.save(loan);
        logActivity("BOOK_BORROWED", "CIRCULATION", actorName,
                member.getFullName() + " borrowed \"" + book.getTitle() + "\" (Pass " + saved.getPickupCode() + ", Due " + saved.getFormattedDueDate() + ")");
        return saved;
    }

    public Loan returnBook(Long loanId, String actorName) {
        Loan loan = loanRepository.findById(loanId)
                .orElseThrow(() -> new ResourceNotFoundException("Loan not found with id: " + loanId));
        if ("RETURNED".equalsIgnoreCase(loan.getStatus())) {
            return loan;
        }
        loan.setReturnedAt(LocalDateTime.now());
        loan.setStatus("RETURNED");
        double fine = loan.getComputedFine();
        loan.setFineAmount(fine);

        Book book = loan.getBook();
        if (book.getAvailableCopies() < book.getTotalCopies()) {
            book.setAvailableCopies(book.getAvailableCopies() + 1);
            bookRepository.save(book);
        }
        Loan saved = loanRepository.save(loan);
        logActivity("BOOK_RETURNED", "CIRCULATION", actorName,
                "\"" + book.getTitle() + "\" returned by " + loan.getMember().getFullName()
                        + (fine > 0 ? String.format(" (Fine: $%.2f)", fine) : ""));

        // Auto-promote next member in Waitlist Hold Queue if someone is waiting!
        List<HoldRequest> queue = holdRequestRepository.findWaitingQueueForBook(book.getId());
        if (!queue.isEmpty()) {
            HoldRequest nextHold = queue.get(0);
            nextHold.setStatus("READY");
            nextHold.setNotifiedAt(LocalDateTime.now());
            holdRequestRepository.save(nextHold);
            logActivity("HOLD_READY", "CIRCULATION", "System",
                    "Notified " + nextHold.getMember().getFullName() + " that \"" + book.getTitle() + "\" is ready for pickup!");
        }
        return saved;
    }

    public Loan renewLoan(Long loanId, int extraDays, String actorName) {
        Loan loan = loanRepository.findById(loanId)
                .orElseThrow(() -> new ResourceNotFoundException("Loan not found with id: " + loanId));
        if ("RETURNED".equalsIgnoreCase(loan.getStatus())) {
            throw new IllegalStateException("Cannot renew a returned loan.");
        }
        LocalDate baseDate = loan.getDueDate().isBefore(LocalDate.now()) ? LocalDate.now() : loan.getDueDate();
        loan.setDueDate(baseDate.plusDays(extraDays));
        loan.setStatus("ACTIVE");
        Loan saved = loanRepository.save(loan);
        logActivity("LOAN_RENEWED", "CIRCULATION", actorName,
                "Extended \"" + loan.getBook().getTitle() + "\" for " + loan.getMember().getFullName()
                        + " until " + saved.getFormattedDueDate());
        return saved;
    }

    public Loan updateLoanProgress(Long loanId, Long memberId, int progress) {
        Loan loan = loanRepository.findById(loanId)
                .orElseThrow(() -> new ResourceNotFoundException("Loan not found with id: " + loanId));
        if (!loan.getMember().getId().equals(memberId)) {
            throw new IllegalStateException("You can only update reading progress on your own loans.");
        }
        loan.setReadingProgress(progress);
        return loanRepository.save(loan);
    }

    public Loan markFinePaid(Long loanId, String adminName) {
        Loan loan = loanRepository.findById(loanId)
                .orElseThrow(() -> new ResourceNotFoundException("Loan not found with id: " + loanId));
        loan.setFinePaid(true);
        Loan saved = loanRepository.save(loan);
        logActivity("FINE_SETTLED", "CIRCULATION", adminName,
                String.format("Settled $%.2f fine for %s (\"%s\")", loan.getFineAmount(),
                        loan.getMember().getFullName(), loan.getBook().getTitle()));
        return saved;
    }

    public int refreshOverdueLoans() {
        List<Loan> allLoans = loanRepository.findAll();
        int updated = 0;
        for (Loan loan : allLoans) {
            if (!"RETURNED".equalsIgnoreCase(loan.getStatus()) && loan.isOverdueNow()) {
                loan.setStatus("OVERDUE");
                loan.setFineAmount(loan.getComputedFine());
                loanRepository.save(loan);
                updated++;
            }
        }
        return updated;
    }

    // =====================================================
    // Waitlist / Hold Queue
    // =====================================================

    public HoldRequest placeHold(Long bookId, Long memberId) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + bookId));
        Member member = getMemberById(memberId);

        if (loanRepository.countActiveLoanForMemberAndBook(memberId, bookId) > 0) {
            throw new IllegalStateException("You already have this book checked out.");
        }
        if (holdRequestRepository.countActiveHoldForMemberAndBook(memberId, bookId) > 0) {
            throw new IllegalStateException("You already have an active hold on \"" + book.getTitle() + "\".");
        }
        HoldRequest hold = new HoldRequest(book, member);
        if (book.isAvailable()) {
            hold.setStatus("READY");
            hold.setNotifiedAt(LocalDateTime.now());
        }
        HoldRequest saved = holdRequestRepository.save(hold);
        logActivity("HOLD_PLACED", "CIRCULATION", member.getFullName(),
                "Joined waitlist for \"" + book.getTitle() + "\" (Status: " + saved.getStatus() + ")");
        return saved;
    }

    public void cancelHold(Long holdId, Long memberId, boolean isAdmin, String actorName) {
        HoldRequest hold = holdRequestRepository.findById(holdId)
                .orElseThrow(() -> new ResourceNotFoundException("Hold request not found with id: " + holdId));
        if (!isAdmin && !hold.getMember().getId().equals(memberId)) {
            throw new IllegalStateException("Cannot cancel another member's hold.");
        }
        hold.setStatus("CANCELLED");
        holdRequestRepository.save(hold);
        logActivity("HOLD_CANCELLED", "CIRCULATION", actorName,
                "Cancelled waitlist hold for \"" + hold.getBook().getTitle() + "\"");
    }

    public Loan fulfillHold(Long holdId, String adminName) {
        HoldRequest hold = holdRequestRepository.findById(holdId)
                .orElseThrow(() -> new ResourceNotFoundException("Hold request not found with id: " + holdId));
        Loan loan = borrowBook(hold.getBook().getId(), hold.getMember().getId(), 14,
                "Fulfilled from Waitlist Hold #" + hold.getId(), adminName);
        hold.setStatus("FULFILLED");
        holdRequestRepository.save(hold);
        return loan;
    }

    @Transactional(readOnly = true)
    public List<HoldRequest> getActiveHoldsForMember(Long memberId) {
        return holdRequestRepository.findActiveHoldsByMemberId(memberId);
    }

    @Transactional(readOnly = true)
    public List<HoldRequest> getAllHolds(String status) {
        if (status == null || status.isBlank() || "ALL".equalsIgnoreCase(status)) {
            return holdRequestRepository.findAllByOrderByRequestedAtDesc();
        }
        return holdRequestRepository.findByStatusOrderByRequestedAtAsc(status.toUpperCase());
    }

    @Transactional(readOnly = true)
    public boolean hasActiveHoldForBook(Long memberId, Long bookId) {
        return holdRequestRepository.countActiveHoldForMemberAndBook(memberId, bookId) > 0;
    }

    @Transactional(readOnly = true)
    public int getWaitingCountForBook(Long bookId) {
        return holdRequestRepository.findWaitingQueueForBook(bookId).size();
    }

    @Transactional(readOnly = true)
    public List<Loan> getAllLoans(String statusFilter) {
        if (statusFilter == null || statusFilter.isBlank() || "ALL".equalsIgnoreCase(statusFilter)) {
            return loanRepository.findAllByOrderByBorrowedAtDesc();
        }
        return loanRepository.findByStatusOrderByDueDateAsc(statusFilter.toUpperCase());
    }

    @Transactional(readOnly = true)
    public List<Loan> getLoansForMember(Long memberId) {
        return loanRepository.findByMemberIdOrderByBorrowedAtDesc(memberId);
    }

    @Transactional(readOnly = true)
    public List<Loan> getActiveLoansForMember(Long memberId) {
        return loanRepository.findActiveLoansByMemberId(memberId);
    }

    @Transactional(readOnly = true)
    public boolean hasActiveLoanForBook(Long memberId, Long bookId) {
        return loanRepository.countActiveLoanForMemberAndBook(memberId, bookId) > 0;
    }

    // =====================================================
    // Reviews & Reading List
    // =====================================================

    public BookReview addReview(Long bookId, Long memberId, Integer rating, String comment) {
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + bookId));
        Member member = getMemberById(memberId);
        int clampedRating = Math.min(5, Math.max(1, rating != null ? rating : 5));
        BookReview review = new BookReview(book, member, clampedRating, comment.trim());
        BookReview saved = reviewRepository.save(review);

        Double avg = reviewRepository.findAverageRatingByBookId(bookId);
        if (avg != null) {
            book.setRating(Math.round(avg * 10.0) / 10.0);
            bookRepository.save(book);
        }
        logActivity("REVIEW_POSTED", "CATALOG", member.getFullName(),
                "Rated \"" + book.getTitle() + "\" " + clampedRating + "/5 stars");
        return saved;
    }

    @Transactional(readOnly = true)
    public List<BookReview> getReviewsForBook(Long bookId) {
        return reviewRepository.findByBookIdOrderByCreatedAtDesc(bookId);
    }

    public boolean toggleReadingList(Long memberId, Long bookId) {
        Optional<ReadingListItem> existing = readingListRepository.findByMemberIdAndBookId(memberId, bookId);
        if (existing.isPresent()) {
            readingListRepository.delete(existing.get());
            return false;
        }
        Member member = getMemberById(memberId);
        Book book = bookRepository.findById(bookId)
                .orElseThrow(() -> new ResourceNotFoundException("Book not found with id: " + bookId));
        readingListRepository.save(new ReadingListItem(member, book));
        return true;
    }

    @Transactional(readOnly = true)
    public boolean isInReadingList(Long memberId, Long bookId) {
        return readingListRepository.existsByMemberIdAndBookId(memberId, bookId);
    }

    @Transactional(readOnly = true)
    public List<ReadingListItem> getReadingList(Long memberId) {
        return readingListRepository.findByMemberIdOrderByAddedAtDesc(memberId);
    }

    // =====================================================
    // Activity Logs & Dashboard Metrics
    // =====================================================

    public void logActivity(String action, String category, String actorName, String details) {
        activityLogRepository.save(new ActivityLog(action, category,
                actorName != null ? actorName : "System", details));
    }

    @Transactional(readOnly = true)
    public List<ActivityLog> getRecentActivity() {
        return activityLogRepository.findTop15ByOrderByCreatedAtDesc();
    }

    @Transactional(readOnly = true)
    public List<ActivityLog> getAllActivity(String category) {
        if (category == null || category.isBlank() || "ALL".equalsIgnoreCase(category)) {
            return activityLogRepository.findAllByOrderByCreatedAtDesc();
        }
        return activityLogRepository.findByCategoryOrderByCreatedAtDesc(category.toUpperCase());
    }

    @Transactional(readOnly = true)
    public Map<String, Object> getLibraryStats() {
        List<Book> books = bookRepository.findAll();
        long totalBooks = books.size();
        int totalCopies = books.stream().mapToInt(Book::getTotalCopies).sum();
        int availableCopies = books.stream().mapToInt(Book::getAvailableCopies).sum();
        int checkedOutCopies = Math.max(0, totalCopies - availableCopies);
        int utilizationPct = totalCopies > 0 ? (int) Math.round((checkedOutCopies * 100.0) / totalCopies) : 0;
        double avgRating = books.isEmpty() ? 0.0
                : Math.round(books.stream().mapToDouble(Book::getRating).average().orElse(0.0) * 10.0) / 10.0;

        long totalAuthors = authorRepository.count();
        long totalMembers = memberRepository.count();
        long activeMembers = memberRepository.countByActiveTrue();
        long activeLoans = loanRepository.countByStatus("ACTIVE");
        long overdueLoans = loanRepository.countByStatus("OVERDUE");
        long returnedLoans = loanRepository.countByStatus("RETURNED");
        long waitingHolds = holdRequestRepository.countByStatus("WAITING");
        long readyHolds = holdRequestRepository.countByStatus("READY");
        Double unpaidFines = loanRepository.sumUnpaidFines();

        Map<String, Object> stats = new LinkedHashMap<>();
        stats.put("totalBooks", totalBooks);
        stats.put("totalCopies", totalCopies);
        stats.put("availableCopies", availableCopies);
        stats.put("checkedOutCopies", checkedOutCopies);
        stats.put("utilizationPct", utilizationPct);
        stats.put("avgRating", avgRating);
        stats.put("totalAuthors", totalAuthors);
        stats.put("totalMembers", totalMembers);
        stats.put("activeMembers", activeMembers);
        stats.put("activeLoans", activeLoans);
        stats.put("overdueLoans", overdueLoans);
        stats.put("openLoans", activeLoans + overdueLoans);
        stats.put("returnedLoans", returnedLoans);
        stats.put("waitingHolds", waitingHolds);
        stats.put("readyHolds", readyHolds);
        stats.put("openHolds", waitingHolds + readyHolds);
        stats.put("unpaidFines", unpaidFines != null ? Math.round(unpaidFines * 100.0) / 100.0 : 0.0);
        stats.put("totalGenres", bookRepository.findDistinctGenres().size());
        return stats;
    }
}
