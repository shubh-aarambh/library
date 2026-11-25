package com.library;

import com.library.model.*;
import com.library.repository.*;
import com.library.security.PasswordUtil;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;

@Component
public class DataInitializer implements CommandLineRunner {

    private final AuthorRepository authorRepository;
    private final BookRepository bookRepository;
    private final MemberRepository memberRepository;
    private final LoanRepository loanRepository;
    private final BookReviewRepository reviewRepository;
    private final ReadingListRepository readingListRepository;
    private final ActivityLogRepository activityLogRepository;

    public DataInitializer(AuthorRepository authorRepository,
                           BookRepository bookRepository,
                           MemberRepository memberRepository,
                           LoanRepository loanRepository,
                           BookReviewRepository reviewRepository,
                           ReadingListRepository readingListRepository,
                           ActivityLogRepository activityLogRepository) {
        this.authorRepository = authorRepository;
        this.bookRepository = bookRepository;
        this.memberRepository = memberRepository;
        this.loanRepository = loanRepository;
        this.reviewRepository = reviewRepository;
        this.readingListRepository = readingListRepository;
        this.activityLogRepository = activityLogRepository;
    }

    @Override
    public void run(String... args) {
        if (authorRepository.count() > 0) {
            return; // Already seeded
        }

        // ---- Seed 12 Curated Literary Authors ----
        Author tolkien = new Author("J.R.R. Tolkien", "British", 1892,
                "Philologist and fantasy pioneer who architected Middle-earth and reshaped modern high fantasy.",
                "Commander of the Order of the British Empire", "#b45309");
        Author orwell = new Author("George Orwell", "British", 1903,
                "Essayist, journalist, and novelist renowned for incisive political allegory and dystopian realism.",
                "Prometheus Hall of Fame Award", "#dc2626");
        Author rowling = new Author("J.K. Rowling", "British", 1965,
                "Contemporary British author whose Wizarding World inspired a generation of readers worldwide.",
                "Hugo Award for Best Novel", "#7c3aed");
        Author camus = new Author("Albert Camus", "French", 1913,
                "French-Algerian philosopher and novelist who explored absurdism, revolt, and human solidarity.",
                "Nobel Prize in Literature (1957)", "#0284c7");
        Author austen = new Author("Jane Austen", "British", 1775,
                "Master of Regency social commentary whose wit and irony defined the modern realist novel.",
                "Canonical Literary Classicist", "#db2777");
        Author kafka = new Author("Franz Kafka", "Czech", 1883,
                "Prague-born modernist who fused bureaucracy, alienation, and surreal metaphor into unforgettable parables.",
                "Modernist Literary Icon", "#475569");
        Author fitzgerald = new Author("F. Scott Fitzgerald", "American", 1896,
                "Chronicler of the Jazz Age, capturing ambition, glamour, and the fragility of the American Dream.",
                "American Classic Laureate", "#ca8a04");
        Author morrison = new Author("Toni Morrison", "American", 1931,
                "Pulitzer and Nobel laureate whose lyrical prose illuminated memory, heritage, and Black American history.",
                "Nobel Prize in Literature (1993)", "#059669");
        Author garcia = new Author("Gabriel García Márquez", "Colombian", 1927,
                "Colombian master of Magical Realism who wove Latin American history into mythic family sagas.",
                "Nobel Prize in Literature (1982)", "#ea580c");
        Author dostoevsky = new Author("Fyodor Dostoevsky", "Russian", 1821,
                "Russian philosophical novelist exploring conscience, existential dread, and spiritual redemption.",
                "Master of Psychological Realism", "#4f46e5");
        Author herbert = new Author("Frank Herbert", "American", 1920,
                "Visionary science-fiction architect who blended ecology, geopolitics, and myth in the Dune Chronicles.",
                "Hugo & Nebula Award Winner", "#d97706");
        Author murakami = new Author("Haruki Murakami", "Japanese", 1949,
                "Contemporary Japanese novelist celebrated for dreamlike urban solitude, jazz motifs, and surreal mystery.",
                "Franz Kafka Prize", "#0d9488");

        authorRepository.saveAll(Arrays.asList(
                tolkien, orwell, rowling, camus, austen, kafka,
                fitzgerald, morrison, garcia, dostoevsky, herbert, murakami));

        // ---- Seed 16 Curated Books with Inventory & Editorial Covers ----
        Book fellowship = new Book("The Fellowship of the Ring", "Fantasy", 1954, "ISBN-9780261102354",
                "In the quiet Shire, Frodo Baggins inherits a ring of dark power and embarks on a perilous fellowship across Middle-earth.",
                tolkien, 5, 4, 4.9, 432, "English", "F-101",
                "linear-gradient(145deg, #1b4332 0%, #081c15 100%)", true);
        Book hobbit = new Book("The Hobbit", "Fantasy", 1937, "ISBN-9780547928227",
                "Bilbo Baggins is swept from his comfortable hobbit-hole into an epic quest to reclaim Erebor from the dragon Smaug.",
                tolkien, 4, 4, 4.8, 310, "English", "F-102",
                "linear-gradient(145deg, #78350f 0%, #291408 100%)", false);
        Book nineteen84 = new Book("Nineteen Eighty-Four", "Dystopian", 1949, "ISBN-9780451524935",
                "Beneath the unblinking gaze of Big Brother, Winston Smith dares to question the Ministry of Truth and reclaim his mind.",
                orwell, 6, 5, 4.9, 328, "English", "D-201",
                "linear-gradient(145deg, #7f1d1d 0%, #1c0a0a 100%)", true);
        Book animalFarm = new Book("Animal Farm", "Dystopian", 1945, "ISBN-9780451526342",
                "A biting allegorical fable in which barnyard revolutionaries discover how easily idealism mutates into tyranny.",
                orwell, 4, 4, 4.7, 144, "English", "D-202",
                "linear-gradient(145deg, #991b1b 0%, #271212 100%)", false);
        Book harryPotter = new Book("Harry Potter and the Philosopher's Stone", "Fantasy", 1997, "ISBN-9780747532699",
                "An orphaned boy discovers a hidden magical world at Hogwarts School of Witchcraft and Wizardry.",
                rowling, 5, 5, 4.8, 309, "English", "F-108",
                "linear-gradient(145deg, #3b0764 0%, #1e1b4b 100%)", true);
        Book stranger = new Book("The Stranger", "Philosophical", 1942, "ISBN-9780679720201",
                "Meursault's detached confrontation with grief, heat, and justice exposes the stark beauty of an indifferent universe.",
                camus, 3, 2, 4.6, 159, "French / English", "P-304",
                "linear-gradient(145deg, #0c4a6e 0%, #082f49 100%)", false);
        Book pride = new Book("Pride and Prejudice", "Romance", 1813, "ISBN-9780141439518",
                "Elizabeth Bennet and Mr. Darcy navigate class expectations, sharp wit, and mistaken first impressions in Regency England.",
                austen, 4, 4, 4.8, 432, "English", "R-112",
                "linear-gradient(145deg, #831843 0%, #3b0724 100%)", false);
        Book metamorphosis = new Book("The Metamorphosis", "Surrealism", 1915, "ISBN-9780393956398",
                "Gregor Samsa wakes one morning transformed into a monstrous insect, unraveling his family's fragile bourgeois facade.",
                kafka, 3, 3, 4.5, 112, "German / English", "S-405",
                "linear-gradient(145deg, #334155 0%, #0f172a 100%)", false);
        Book gatsby = new Book("The Great Gatsby", "Classic", 1925, "ISBN-9780743273565",
                "Across the glittering estates of Long Island, Jay Gatsby pursues an unattainable green light and the illusion of reinvention.",
                fitzgerald, 5, 5, 4.7, 180, "English", "C-105",
                "linear-gradient(145deg, #854d0e 0%, #1c1917 100%)", true);
        Book beloved = new Book("Beloved", "Historical", 1987, "ISBN-9781400033416",
                "Set after the American Civil War, Sethe confronts the haunting spectral memory of slavery and ferocious maternal love.",
                morrison, 3, 3, 4.7, 324, "English", "H-210",
                "linear-gradient(145deg, #065f46 0%, #022c22 100%)", false);
        Book solitude = new Book("One Hundred Years of Solitude", "Magical Realism", 1967, "ISBN-9780060883287",
                "Seven generations of the Buendía dynasty rise and fall inside the mythic, rain-drenched town of Macondo.",
                garcia, 4, 3, 4.9, 417, "Spanish / English", "M-118",
                "linear-gradient(145deg, #9a3412 0%, #27130a 100%)", true);
        Book crime = new Book("Crime and Punishment", "Psychological", 1866, "ISBN-9780140449136",
                "Impoverished scholar Raskolnikov tests a ruthless theory of moral superiority in the shadowy alleys of St. Petersburg.",
                dostoevsky, 4, 4, 4.8, 671, "Russian / English", "P-312",
                "linear-gradient(145deg, #312e81 0%, #111827 100%)", false);
        Book karamazov = new Book("The Brothers Karamazov", "Psychological", 1880, "ISBN-9780374528379",
                "A towering philosophical murder mystery probing faith, doubt, free will, and family rivalry in nineteenth-century Russia.",
                dostoevsky, 3, 3, 4.9, 824, "Russian / English", "P-313",
                "linear-gradient(145deg, #1e1b4b 0%, #0f172a 100%)", false);
        Book dune = new Book("Dune", "Sci-Fi", 1965, "ISBN-9780441172719",
                "On the desert planet Arrakis, young Paul Atreides navigates imperial betrayal, giant sandworms, and prophetic destiny.",
                herbert, 5, 4, 4.9, 688, "English", "SF-501",
                "linear-gradient(145deg, #b45309 0%, #451a03 100%)", true);
        Book kafkaShore = new Book("Kafka on the Shore", "Magical Realism", 2002, "ISBN-9781400079278",
                "A runaway teenager and an elderly man who talks to cats traverse parallel dreamscapes across modern Japan.",
                murakami, 4, 4, 4.6, 480, "Japanese / English", "M-122",
                "linear-gradient(145deg, #115e59 0%, #042f2e 100%)", false);
        Book norwegianWood = new Book("Norwegian Wood", "Classic", 1987, "ISBN-9780375704024",
                "A nostalgic coming-of-age meditation on loss, music, and first love set in late-1960s Tokyo.",
                murakami, 3, 3, 4.5, 296, "Japanese / English", "C-119",
                "linear-gradient(145deg, #0f766e 0%, #134e4a 100%)", false);

        List<Book> books = bookRepository.saveAll(Arrays.asList(
                fellowship, hobbit, nineteen84, animalFarm, harryPotter, stranger,
                pride, metamorphosis, gatsby, beloved, solitude, crime,
                karamazov, dune, kafkaShore, norwegianWood));

        // ---- Seed Members (Admin + Demo Reader + Community Members) ----
        Member admin = new Member("Shubh Shukla", "admin@library.dev",
                PasswordUtil.hash("admin123"), "ADMIN", "VIP");
        Member demoReader = new Member("Aarav Mehta", "reader@library.dev",
                PasswordUtil.hash("reader123"), "MEMBER", "SCHOLAR");
        Member elena = new Member("Elena Rostova", "elena@library.dev",
                PasswordUtil.hash("reader123"), "MEMBER", "VIP");
        Member marcus = new Member("Marcus Vance", "marcus@library.dev",
                PasswordUtil.hash("reader123"), "MEMBER", "STANDARD");

        memberRepository.saveAll(Arrays.asList(admin, demoReader, elena, marcus));

        // ---- Seed Sample Loans (Active, Overdue, Returned) ----
        Loan active1 = new Loan(dune, demoReader, LocalDate.now().plusDays(9), "Picked up from Science Fiction wing");
        active1.setBorrowedAt(LocalDateTime.now().minusDays(5));

        Loan active2 = new Loan(fellowship, elena, LocalDate.now().plusDays(12), "Collector's hardcover edition");
        active2.setBorrowedAt(LocalDateTime.now().minusDays(2));

        Loan overdue1 = new Loan(stranger, marcus, LocalDate.now().minusDays(4), "Reminder sent via email");
        overdue1.setBorrowedAt(LocalDateTime.now().minusDays(18));
        overdue1.setStatus("OVERDUE");
        overdue1.setFineAmount(6.00);

        Loan active3 = new Loan(nineteen84, demoReader, LocalDate.now().plusDays(6), "Research reading");
        active3.setBorrowedAt(LocalDateTime.now().minusDays(8));

        Loan active4 = new Loan(solitude, elena, LocalDate.now().plusDays(11), "World Literature seminar");
        active4.setBorrowedAt(LocalDateTime.now().minusDays(3));

        Loan returned1 = new Loan(gatsby, demoReader, LocalDate.now().minusDays(10), "Returned in pristine condition");
        returned1.setBorrowedAt(LocalDateTime.now().minusDays(24));
        returned1.setReturnedAt(LocalDateTime.now().minusDays(12));
        returned1.setStatus("RETURNED");

        Loan returned2 = new Loan(pride, elena, LocalDate.now().minusDays(6), "Returned on time");
        returned2.setBorrowedAt(LocalDateTime.now().minusDays(20));
        returned2.setReturnedAt(LocalDateTime.now().minusDays(7));
        returned2.setStatus("RETURNED");

        loanRepository.saveAll(Arrays.asList(active1, active2, overdue1, active3, active4, returned1, returned2));

        // ---- Seed Reviews ----
        reviewRepository.saveAll(Arrays.asList(
                new BookReview(fellowship, elena, 5, "Unmatched world-building and poetic prose. Every reread reveals new depth in Tolkien's mythos."),
                new BookReview(nineteen84, demoReader, 5, "Terrifyingly prescient and razor-sharp. Essential reading for understanding language and power."),
                new BookReview(dune, demoReader, 5, "A monumental fusion of ecological science, political intrigue, and mythic storytelling."),
                new BookReview(solitude, elena, 5, "Macondo feels alive on every single page. Pure literary magic from opening sentence to finale."),
                new BookReview(gatsby, marcus, 4, "Luminous prose and unforgettable symbolism packed into a compact masterpiece."),
                new BookReview(crime, demoReader, 5, "A relentless psychological descent that holds you captive until the final chapter.")
        ));

        // ---- Seed Reading List Bookmarks for Demo Reader ----
        readingListRepository.saveAll(Arrays.asList(
                new ReadingListItem(demoReader, solitude),
                new ReadingListItem(demoReader, karamazov),
                new ReadingListItem(demoReader, kafkaShore)
        ));

        // ---- Seed Activity Audit Logs ----
        activityLogRepository.saveAll(Arrays.asList(
                new ActivityLog("SYSTEM_SEED", "SYSTEM", "System",
                        "Initialized Athenaeum catalog with 12 authors, " + books.size() + " books, and 4 member accounts"),
                new ActivityLog("BOOK_BORROWED", "CIRCULATION", demoReader.getFullName(),
                        "Borrowed \"Dune\" (Shelf SF-501)"),
                new ActivityLog("BOOK_BORROWED", "CIRCULATION", elena.getFullName(),
                        "Borrowed \"The Fellowship of the Ring\" (Shelf F-101)"),
                new ActivityLog("LOAN_OVERDUE", "CIRCULATION", "System",
                        "Flagged \"The Stranger\" loaned to Marcus Vance as 4 days overdue ($6.00 fine)"),
                new ActivityLog("REVIEW_POSTED", "CATALOG", elena.getFullName(),
                        "Published 5/5 review for \"One Hundred Years of Solitude\"")
        ));

        System.out.println("Athenaeum Library initialized with 12 authors, " + books.size() + " books, 4 members, and live circulation data.");
    }
}
