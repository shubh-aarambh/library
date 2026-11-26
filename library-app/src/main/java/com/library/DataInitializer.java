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
    private final HoldRequestRepository holdRequestRepository;
    private final ActivityLogRepository activityLogRepository;

    public DataInitializer(AuthorRepository authorRepository,
                           BookRepository bookRepository,
                           MemberRepository memberRepository,
                           LoanRepository loanRepository,
                           BookReviewRepository reviewRepository,
                           ReadingListRepository readingListRepository,
                           HoldRequestRepository holdRequestRepository,
                           ActivityLogRepository activityLogRepository) {
        this.authorRepository = authorRepository;
        this.bookRepository = bookRepository;
        this.memberRepository = memberRepository;
        this.loanRepository = loanRepository;
        this.reviewRepository = reviewRepository;
        this.readingListRepository = readingListRepository;
        this.holdRequestRepository = holdRequestRepository;
        this.activityLogRepository = activityLogRepository;
    }

    @Override
    public void run(String... args) {
        if (authorRepository.count() > 0) {
            return; // Already seeded
        }

        // ---- Seed 12 Curated Literary Authors ----
        Author tolkien = new Author("J.R.R. Tolkien", "British", 1892,
                "Philologist and fantasy pioneer who architected Middle-earth and reshaped modern speculative storytelling.",
                "Commander of the Order of the British Empire", "#b45309");
        Author orwell = new Author("George Orwell", "British", 1903,
                "Essayist, journalist, and novelist renowned for incisive political allegory and dystopian realism.",
                "Prometheus Hall of Fame Award", "#dc2626");
        Author rowling = new Author("J.K. Rowling", "British", 1965,
                "Contemporary British novelist whose serialized fantasy saga became a global reading phenomenon.",
                "Hugo Award for Best Novel", "#7c3aed");
        Author camus = new Author("Albert Camus", "French", 1913,
                "French-Algerian philosopher and novelist who explored absurdism, moral clarity, and human solidarity.",
                "Nobel Prize in Literature (1957)", "#0284c7");
        Author austen = new Author("Jane Austen", "British", 1775,
                "Master of Regency social commentary whose wit and irony defined the modern realist novel.",
                "Canonical Literary Classicist", "#be185d");
        Author kafka = new Author("Franz Kafka", "Czech", 1883,
                "Prague-born modernist who blended bureaucracy, alienation, and surreal metaphor into enduring parables.",
                "Modernist Literary Icon", "#475569");
        Author fitzgerald = new Author("F. Scott Fitzgerald", "American", 1896,
                "Chronicler of the Jazz Age, capturing ambition, glamour, and the fragility of the American Dream.",
                "American Classic Laureate", "#a16207");
        Author morrison = new Author("Toni Morrison", "American", 1931,
                "Pulitzer and Nobel laureate whose lyrical prose illuminated memory, heritage, and Black American history.",
                "Nobel Prize in Literature (1993)", "#047857");
        Author garcia = new Author("Gabriel García Márquez", "Colombian", 1927,
                "Colombian pioneer of Magical Realism who wove Latin American history into mythic multi-generational sagas.",
                "Nobel Prize in Literature (1982)", "#c2410c");
        Author dostoevsky = new Author("Fyodor Dostoevsky", "Russian", 1821,
                "Russian philosophical novelist exploring conscience, existential tension, and spiritual redemption.",
                "Master of Psychological Realism", "#4338ca");
        Author herbert = new Author("Frank Herbert", "American", 1920,
                "Visionary science-fiction architect who blended planetary ecology, politics, and myth.",
                "Hugo & Nebula Award Winner", "#d97706");
        Author murakami = new Author("Haruki Murakami", "Japanese", 1949,
                "Contemporary Japanese novelist celebrated for atmospheric urban solitude, jazz motifs, and quiet mystery.",
                "Franz Kafka Prize", "#0f766e");

        authorRepository.saveAll(Arrays.asList(
                tolkien, orwell, rowling, camus, austen, kafka,
                fitzgerald, morrison, garcia, dostoevsky, herbert, murakami));

        // ---- Seed 16 Curated Books with Inventory, Editorial Guides & Formats ----
        Book fellowship = enrich(new Book("The Fellowship of the Ring", "Fantasy", 1954, "ISBN-9780261102354",
                "An unlikely band of travelers sets out across ancient realms to safeguard a dangerous heirloom and resist rising darkness.",
                tolkien, 5, 4, 4.9, 432, "English", "F-101",
                "linear-gradient(145deg, #1b4332 0%, #081c15 100%)", true),
                "BOTH",
                "Ideal for readers who love immersive maps, linguistic depth, and quiet camaraderie before epic conflict.",
                "READER ORIENTATION\n\nWhy this edition belongs on your desk: Written over more than a decade, this opening volume transforms quiet pastoral rhythms into high-stakes mythic adventure.\n\nKEY THEMES TO WATCH\n• Power & Restraint — Why humble stewards resist temptation better than conquerors.\n• Fellowship Across Cultures — How trust bridges ancient rivalries.\n• Environmental Memory — Landscapes act as living historical records.\n\nDISCUSSION PROMPTS\n1. How does the leisurely opening pace prepare the emotional weight of the journey ahead?\n2. What role do songs, folklore, and maps play in making an invented world feel lived-in?");

        Book hobbit = enrich(new Book("The Hobbit", "Fantasy", 1937, "ISBN-9780547928227",
                "A comfort-loving homebody is swept into an expedition across mountains and forests to reclaim a lost kingdom.",
                tolkien, 4, 4, 4.8, 310, "English", "F-102",
                "linear-gradient(145deg, #78350f 0%, #291408 100%)", false),
                "BOTH",
                "Brisk, witty, and fireside-warm — our most popular weekend fantasy recommendation.",
                "READER ORIENTATION\n\nConceived originally as a fireside tale, this compact adventure balances folklore humor with genuine moral growth.\n\nKEY THEMES TO WATCH\n• Unexpected Courage — Resourcefulness and empathy triumph over brute strength.\n• Greed vs. Stewardship — How treasure tests character.\n\nDISCUSSION PROMPTS\n1. At which turning point does the protagonist stop longing for home and embrace leadership?\n2. How does the narrator's conversational voice shape the tone?");

        Book nineteen84 = enrich(new Book("Nineteen Eighty-Four", "Dystopian", 1949, "ISBN-9780451524935",
                "Inside a surveillance state that rewrites history daily, a low-ranking archivist risks everything for private thought and memory.",
                orwell, 6, 5, 4.9, 328, "English", "D-201",
                "linear-gradient(145deg, #7f1d1d 0%, #1c0a0a 100%)", true),
                "BOTH",
                "Essential reading for anyone studying media literacy, language design, and civic resilience.",
                "READER ORIENTATION\n\nOne of the twentieth century's sharpest political warnings, examining how narrowing vocabulary narrows independent thought.\n\nKEY THEMES TO WATCH\n• Language & Reality — How official slogans reshape public memory.\n• Surveillance & Privacy — The psychological cost of permanent observation.\n• Historical Truth — Why independent archives matter.\n\nDISCUSSION PROMPTS\n1. Why is editing historical archives treated as more powerful than military force?\n2. Which architectural or sensory details make the setting feel claustrophobic?");

        Book animalFarm = enrich(new Book("Animal Farm", "Dystopian", 1945, "ISBN-9780451526342",
                "A razor-sharp allegorical novella tracing how revolutionary ideals slowly erode under unchecked authority.",
                orwell, 4, 4, 4.7, 144, "English", "D-202",
                "linear-gradient(145deg, #991b1b 0%, #271212 100%)", false),
                "BOTH",
                "A crisp 2-hour read that pairs brilliantly with civic history seminars.",
                "READER ORIENTATION\n\nStructured as a deceptively simple fable, every character and rule change mirrors real mechanisms of institutional capture.\n\nKEY THEMES TO WATCH\n• Incremental Rule Drift — Watch how foundational principles are quietly revised.\n• Rhetoric & Persuasion — How jargon silences reasonable questions.\n\nDISCUSSION PROMPTS\n1. Why does the fable form sharpen rather than soften the political critique?\n2. How does literacy determine power inside the community?");

        Book harryPotter = enrich(new Book("Harry Potter and the Philosopher's Stone", "Fantasy", 1997, "ISBN-9780747532699",
                "A young orphan receives an unexpected invitation to a hidden boarding school where curiosity, friendship, and mystery await.",
                rowling, 5, 5, 4.8, 309, "English", "F-108",
                "linear-gradient(145deg, #3b0764 0%, #1e1b4b 100%)", true),
                "BOTH",
                "Beloved cross-generational comfort read with classic boarding-school mystery pacing.",
                "READER ORIENTATION\n\nCombining classic British school-story warmth with a tightly plotted mystery box, this opener invites readers of all ages.\n\nKEY THEMES TO WATCH\n• Chosen Family — Loyalty and belonging built through shared trials.\n• Choices Over Destiny — Identity shaped by decisions rather than labels.\n\nDISCUSSION PROMPTS\n1. How does alternating between ordinary suburban scenes and fantastical spaces heighten wonder?\n2. Which clues planted early pay off in the final chapters?");

        Book stranger = enrich(new Book("The Stranger", "Philosophical", 1942, "ISBN-9780679720201",
                "A spare, sun-drenched meditation on detachment, societal expectations, and finding clarity in an indifferent world.",
                camus, 2, 0, 4.6, 159, "French / English", "P-304",
                "linear-gradient(145deg, #0c4a6e 0%, #082f49 100%)", false),
                "PHYSICAL",
                "Currently all copies are checked out — join the Waitlist Queue to receive an instant hold notification when returned!",
                "READER ORIENTATION\n\nWritten in stripped-down, journalistic sentences, this philosophical classic challenges readers to separate honesty from social performance.\n\nKEY THEMES TO WATCH\n• Radical Honesty — Refusing to feign emotion for social approval.\n• Sensory Immediacy — Sun, sea, and physical heat anchor the narrative.\n\nDISCUSSION PROMPTS\n1. Does the unadorned sentence structure create distance or unusual intimacy?\n2. How does the courtroom scene shift focus from actions to personality?");

        Book pride = enrich(new Book("Pride and Prejudice", "Romance", 1813, "ISBN-9780141439518",
                "Sparkling dialogue and keen social observation trace two strong-willed minds overcoming hasty judgments in Regency England.",
                austen, 4, 4, 4.8, 432, "English", "R-112",
                "linear-gradient(145deg, #831843 0%, #3b0724 100%)", false),
                "BOTH",
                "Timeless comedy of manners — razor-sharp irony that feels remarkably modern.",
                "READER ORIENTATION\n\nFar more than a romance, this novel dissects economics, reputation, and self-knowledge with effortless comedic timing.\n\nKEY THEMES TO WATCH\n• First Impressions — How pride and snap judgments blind intelligent observers.\n• Independent Judgment — Balancing family pressures with personal integrity.\n\nDISCUSSION PROMPTS\n1. How do letters serve as turning points that reveal hidden character?\n2. Which secondary characters provide the sharpest satire of social status?");

        Book metamorphosis = enrich(new Book("The Metamorphosis", "Surrealism", 1915, "ISBN-9780393956398",
                "An overnight surreal transformation forces a hardworking clerk and his household to confront duty, isolation, and identity.",
                kafka, 3, 3, 4.5, 112, "German / English", "S-405",
                "linear-gradient(145deg, #334155 0%, #0f172a 100%)", false),
                "DIGITAL",
                "Our shortest modernist masterpiece (~2.5 hours). Instant digital & shelf access.",
                "READER ORIENTATION\n\nBeginning abruptly with an impossible premise treated in matter-of-fact prose, this novella examines burnout and conditional belonging.\n\nKEY THEMES TO WATCH\n• Economic Identity — When a person's value is tied solely to productivity.\n• Domestic Space — How a bedroom shrinks from sanctuary to boundary.\n\nDISCUSSION PROMPTS\n1. Why is the protagonist more worried about missing work than about his physical state?\n2. How does the family's dynamic evolve across the three parts?");

        Book gatsby = enrich(new Book("The Great Gatsby", "Classic", 1925, "ISBN-9780743273565",
                "Across glittering summer estates on Long Island, ambition, nostalgia, and reinvention collide beneath the surface of the Jazz Age.",
                fitzgerald, 5, 5, 4.7, 180, "English", "C-105",
                "linear-gradient(145deg, #854d0e 0%, #1c1917 100%)", true),
                "BOTH",
                "Luminous prose and compact structure — easy to finish in a single weekend.",
                "READER ORIENTATION\n\nNarrated from the periphery of high society, every lavish gathering hides deeper questions about class mobility and memory.\n\nKEY THEMES TO WATCH\n• Reinvention & Nostalgia — The lure of rewriting the past.\n• Color & Light Symbolism — Recurring visual motifs frame hope and disillusionment.\n\nDISCUSSION PROMPTS\n1. How reliable is the narrator's claim to reserve judgment?\n2. What distinguishes inherited wealth from self-made ambition in the story?");

        Book beloved = enrich(new Book("Beloved", "Historical", 1987, "ISBN-9781400033416",
                "Set in post-Civil War Ohio, a fiercely lyrical portrait of memory, maternal devotion, and reckoning with an unhealed past.",
                morrison, 3, 3, 4.7, 324, "English", "H-210",
                "linear-gradient(145deg, #065f46 0%, #022c22 100%)", false),
                "BOTH",
                "Pulitzer Prize winner with poetic cadence — best read slowly with book-club notes.",
                "READER ORIENTATION\n\nUnfolding in layered fragments of recollection, the narrative mirrors how memory surfaces piece by piece.\n\nKEY THEMES TO WATCH\n• Collective Memory — Moving from silence toward community healing.\n• Home & Reclamation — Turning a haunted house into a place of agency.\n\nDISCUSSION PROMPTS\n1. How does the nonlinear structure mirror the emotional experience of remembrance?\n2. What role does community solidarity play in the closing section?");

        Book solitude = enrich(new Book("One Hundred Years of Solitude", "Magical Realism", 1967, "ISBN-9780060883287",
                "Seven generations rise, dream, and echo through the mythic town of Macondo in a landmark tapestry of Latin American storytelling.",
                garcia, 2, 0, 4.9, 417, "Spanish / English", "M-118",
                "linear-gradient(145deg, #9a3412 0%, #27130a 100%)", true),
                "PHYSICAL",
                "High demand title! Currently checked out — place a Waitlist Hold to reserve the next returned copy.",
                "READER ORIENTATION\n\nKeep a small family-tree bookmark handy as names repeat across generations, revealing cyclical patterns of passion and history.\n\nKEY THEMES TO WATCH\n• Cyclical Time — History repeating itself in subtle variations.\n• Wonder Inside the Everyday — Extraordinary occurrences narrated calmly.\n\nDISCUSSION PROMPTS\n1. Why do recurring names strengthen the novel's meditation on memory and destiny?\n2. How does the town's isolation transform as outside inventions arrive?");

        Book crime = enrich(new Book("Crime and Punishment", "Psychological", 1866, "ISBN-9780140449136",
                "In the humid summer alleys of St. Petersburg, an impoverished student tests a dangerous theory and faces the relentless weight of conscience.",
                dostoevsky, 4, 4, 4.8, 671, "Russian / English", "P-312",
                "linear-gradient(145deg, #312e81 0%, #111827 100%)", false),
                "BOTH",
                "Reads like a gripping psychological thriller driven by cat-and-mouse dialogue.",
                "READER ORIENTATION\n\nRather than asking who committed the act, this masterpiece probes the feverish inner aftermath and the path back toward empathy.\n\nKEY THEMES TO WATCH\n• Rationalization vs. Conscience — Abstract theory colliding with human feeling.\n• Urban Atmosphere — Crowded stairwells and city streets mirror mental tension.\n\nDISCUSSION PROMPTS\n1. How do the investigative dialogues build suspense without relying on physical chases?\n2. Which relationships challenge the protagonist's isolation?");

        Book karamazov = enrich(new Book("The Brothers Karamazov", "Psychological", 1880, "ISBN-9780374528379",
                "A sweeping philosophical family drama weaving ethics, doubt, courtroom suspense, and unconditional compassion.",
                dostoevsky, 3, 3, 4.9, 824, "Russian / English", "P-313",
                "linear-gradient(145deg, #1e1b4b 0%, #0f172a 100%)", false),
                "PHYSICAL",
                "A rewarding long-form winter read — one of literature's highest-rated achievements.",
                "READER ORIENTATION\n\nStructured around three contrasting brothers, each voice embodies a distinct worldview on intellect, passion, and compassion.\n\nKEY THEMES TO WATCH\n• Moral Responsibility — How individuals answer for one another.\n• Reason & Empathy — Competing frameworks for navigating suffering.\n\nDISCUSSION PROMPTS\n1. How do the contrasting temperaments of the three brothers illuminate the central conflict?\n2. Why does the courtroom finale remain compelling today?");

        Book dune = enrich(new Book("Dune", "Sci-Fi", 1965, "ISBN-9780441172719",
                "On an arid desert world prized for a rare resource, political strategy, ecological mastery, and mythic destiny intertwine.",
                herbert, 5, 4, 4.9, 688, "English", "SF-501",
                "linear-gradient(145deg, #b45309 0%, #451a03 100%)", true),
                "BOTH",
                "Our #1 Sci-Fi checkout — combines ecological world-building with high-stakes statecraft.",
                "READER ORIENTATION\n\nTreat the desert planet itself as the central character: water discipline, wind patterns, and ecology govern every political move.\n\nKEY THEMES TO WATCH\n• Planetary Ecology — Scarcity shaping culture, engineering, and survival.\n• Power & Foresight — The unintended consequences of charismatic authority.\n\nDISCUSSION PROMPTS\n1. How do chapter epigraphs create dramatic irony before key scenes unfold?\n2. Why does ecological knowledge prove more decisive than conventional weaponry?");

        Book kafkaShore = enrich(new Book("Kafka on the Shore", "Magical Realism", 2002, "ISBN-9781400079278",
                "Two alternating journeys — a teenager seeking refuge in a quiet library and a gentle wanderer — converge across dreamlike modern Japan.",
                murakami, 4, 4, 4.6, 480, "Japanese / English", "M-122",
                "linear-gradient(145deg, #115e59 0%, #042f2e 100%)", false),
                "BOTH",
                "Atmospheric, musical, and hypnotic — features one of fiction's coziest private libraries!",
                "READER ORIENTATION\n\nAlternating odd and even chapters braid two seemingly separate lives together with quiet humor, classical music, and surreal mystery.\n\nKEY THEMES TO WATCH\n• Libraries as Sanctuaries — Books and quiet spaces offering shelter during upheaval.\n• Metaphor & Memory — Navigating grief through dreamlike symbols.\n\nDISCUSSION PROMPTS\n1. How do the two parallel storylines echo each other before intersecting?\n2. What effect do music references have on the pacing?");

        Book norwegianWood = enrich(new Book("Norwegian Wood", "Classic", 1987, "ISBN-9780375704024",
                "A tender, nostalgic coming-of-age portrait of friendship, music, and growing up in late-1960s Tokyo.",
                murakami, 3, 3, 4.5, 296, "Japanese / English", "C-119",
                "linear-gradient(145deg, #0f766e 0%, #134e4a 100%)", false),
                "BOTH",
                "Grounded, intimate, and deeply evocative — an accessible entry point to Murakami.",
                "READER ORIENTATION\n\nUnlike Murakami's surrealist works, this novel stays firmly in realistic memory, capturing university life, letters, and quiet resilience.\n\nKEY THEMES TO WATCH\n• Grief & Renewal — Carrying memory while stepping into adulthood.\n• Music as Time Capsule — Songs unlocking distant seasons.\n\nDISCUSSION PROMPTS\n1. How does framing the entire novel around a memory triggered years later affect its tone?\n2. How do seasonal settings reflect inner emotional shifts?");

        List<Book> books = bookRepository.saveAll(Arrays.asList(
                fellowship, hobbit, nineteen84, animalFarm, harryPotter, stranger,
                pride, metamorphosis, gatsby, beloved, solitude, crime,
                karamazov, dune, kafkaShore, norwegianWood));

        // ---- Seed Members (Admin + Demo Reader + Community Members) ----
        Member admin = new Member("Shubh Shukla", "admin@library.dev",
                PasswordUtil.hash("admin123"), "ADMIN", "VIP");
        Member demoReader = new Member("Aarav Mehta", "reader@library.dev",
                PasswordUtil.hash("reader123"), "MEMBER", "SCHOLAR");
        demoReader.setAnnualReadingGoal(12);
        Member elena = new Member("Elena Rostova", "elena@library.dev",
                PasswordUtil.hash("reader123"), "MEMBER", "VIP");
        Member marcus = new Member("Marcus Vance", "marcus@library.dev",
                PasswordUtil.hash("reader123"), "MEMBER", "STANDARD");

        memberRepository.saveAll(Arrays.asList(admin, demoReader, elena, marcus));

        // ---- Seed Sample Loans (Active with Reading Progress, Overdue, Returned) ----
        Loan active1 = new Loan(dune, demoReader, LocalDate.now().plusDays(9), "Picked up from Science Fiction wing");
        active1.setBorrowedAt(LocalDateTime.now().minusDays(5));
        active1.setReadingProgress(68);
        active1.setPickupCode("ATH-4821");

        Loan active2 = new Loan(fellowship, elena, LocalDate.now().plusDays(12), "Collector's hardcover edition");
        active2.setBorrowedAt(LocalDateTime.now().minusDays(2));
        active2.setReadingProgress(24);
        active2.setPickupCode("ATH-5190");

        Loan overdue1 = new Loan(stranger, marcus, LocalDate.now().minusDays(4), "Reminder sent via email");
        overdue1.setBorrowedAt(LocalDateTime.now().minusDays(18));
        overdue1.setStatus("OVERDUE");
        overdue1.setFineAmount(6.00);
        overdue1.setReadingProgress(85);
        overdue1.setPickupCode("ATH-3318");

        Loan active3 = new Loan(nineteen84, demoReader, LocalDate.now().plusDays(6), "Seminar reading copy");
        active3.setBorrowedAt(LocalDateTime.now().minusDays(8));
        active3.setReadingProgress(42);
        active3.setPickupCode("ATH-6042");

        Loan active4 = new Loan(solitude, elena, LocalDate.now().plusDays(11), "World Literature seminar");
        active4.setBorrowedAt(LocalDateTime.now().minusDays(3));
        active4.setReadingProgress(50);
        active4.setPickupCode("ATH-7725");

        Loan returned1 = new Loan(gatsby, demoReader, LocalDate.now().minusDays(10), "Returned in pristine condition");
        returned1.setBorrowedAt(LocalDateTime.now().minusDays(24));
        returned1.setReturnedAt(LocalDateTime.now().minusDays(12));
        returned1.setStatus("RETURNED");
        returned1.setReadingProgress(100);

        Loan returned2 = new Loan(pride, elena, LocalDate.now().minusDays(6), "Returned on time");
        returned2.setBorrowedAt(LocalDateTime.now().minusDays(20));
        returned2.setReturnedAt(LocalDateTime.now().minusDays(7));
        returned2.setStatus("RETURNED");
        returned2.setReadingProgress(100);

        Loan returned3 = new Loan(hobbit, demoReader, LocalDate.now().minusDays(28), "Finished over weekend");
        returned3.setBorrowedAt(LocalDateTime.now().minusDays(40));
        returned3.setReturnedAt(LocalDateTime.now().minusDays(30));
        returned3.setStatus("RETURNED");
        returned3.setReadingProgress(100);

        loanRepository.saveAll(Arrays.asList(active1, active2, overdue1, active3, active4, returned1, returned2, returned3));

        // ---- Seed Waitlist Hold Requests ----
        HoldRequest hold1 = new HoldRequest(solitude, demoReader);
        hold1.setRequestedAt(LocalDateTime.now().minusDays(2));

        HoldRequest hold2 = new HoldRequest(stranger, elena);
        hold2.setRequestedAt(LocalDateTime.now().minusDays(1));

        holdRequestRepository.saveAll(Arrays.asList(hold1, hold2));

        // ---- Seed Reviews ----
        reviewRepository.saveAll(Arrays.asList(
                new BookReview(fellowship, elena, 5, "Unmatched world-building and poetic prose. Every reread reveals new depth."),
                new BookReview(nineteen84, demoReader, 5, "Razor-sharp and unforgettable. Essential reading for understanding language and power."),
                new BookReview(dune, demoReader, 5, "A monumental fusion of ecological science, political intrigue, and mythic storytelling."),
                new BookReview(solitude, elena, 5, "Pure literary magic from opening chapter to finale."),
                new BookReview(gatsby, marcus, 4, "Luminous prose and sharp symbolism packed into a compact weekend read."),
                new BookReview(crime, demoReader, 5, "A relentless psychological study that holds you captive until the final chapter.")
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
                        "Initialized Athenaeum Smart Library with 12 authors, " + books.size() + " books, 4 members, and live waitlist holds"),
                new ActivityLog("BOOK_BORROWED", "CIRCULATION", demoReader.getFullName(),
                        "Checked out \"Dune\" (Pickup Pass ATH-4821 · Shelf SF-501)"),
                new ActivityLog("HOLD_PLACED", "CIRCULATION", demoReader.getFullName(),
                        "Joined Waitlist Queue #1 for \"One Hundred Years of Solitude\""),
                new ActivityLog("LOAN_OVERDUE", "CIRCULATION", "System",
                        "Flagged \"The Stranger\" loaned to Marcus Vance as 4 days overdue ($6.00 fine)"),
                new ActivityLog("REVIEW_POSTED", "CATALOG", elena.getFullName(),
                        "Published 5/5 review for \"One Hundred Years of Solitude\"")
        ));

        System.out.println("Athenaeum Smart Library initialized with 12 authors, " + books.size() + " books, 4 members, holds & guides.");
    }

    private Book enrich(Book book, String format, String note, String guide) {
        book.setFormat(format);
        book.setLibrarianNote(note);
        book.setPreviewGuide(guide);
        return book;
    }
}
