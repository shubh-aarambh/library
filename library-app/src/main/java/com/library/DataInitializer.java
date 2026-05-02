package com.library;

import com.library.model.Author;
import com.library.model.Book;
import com.library.repository.AuthorRepository;
import com.library.repository.BookRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.Arrays;
import java.util.List;

@Component
public class DataInitializer implements CommandLineRunner {

    private final AuthorRepository authorRepository;
    private final BookRepository bookRepository;

    public DataInitializer(AuthorRepository authorRepository, BookRepository bookRepository) {
        this.authorRepository = authorRepository;
        this.bookRepository = bookRepository;
    }

    @Override
    public void run(String... args) {
        if (authorRepository.count() > 0) {
            return; // Already seeded
        }

        // ---- Seed 10 Authors ----
        Author tolkien = new Author("J.R.R. Tolkien", "British", 1892, "Author of The Lord of the Rings.");
        Author orwell = new Author("George Orwell", "British", 1903, "Known for dystopian novels.");
        Author rowling = new Author("J.K. Rowling", "British", 1965, "Creator of Harry Potter.");
        Author camus = new Author("Albert Camus", "French", 1913, "French Nobel Prize novelist.");
        Author austen = new Author("Jane Austen", "British", 1775, "Renowned for Pride and Prejudice.");
        Author kafka = new Author("Franz Kafka", "Czech", 1883, "Known for surreal fiction.");
        Author fitzgerald = new Author("F. Scott Fitzgerald", "American", 1896, "Author of The Great Gatsby.");
        Author morrison = new Author("Toni Morrison", "American", 1931, "Nobel laureate fiction writer.");
        Author garcia = new Author("Gabriel García Márquez", "Colombian", 1927, "Father of Magical Realism.");
        Author dostoevsky = new Author("Fyodor Dostoevsky", "Russian", 1821, "Author of Crime and Punishment.");

        List<Author> authors = authorRepository.saveAll(Arrays.asList(
                tolkien, orwell, rowling, camus, austen,
                kafka, fitzgerald, morrison, garcia, dostoevsky));

        // ---- Seed 10 Books ----
        List<Book> books = Arrays.asList(
                new Book("The Fellowship of the Ring", "Fantasy", 1954, "ISBN-9780261102354",
                        "First part of The Lord of the Rings.", tolkien),
                new Book("Nineteen Eighty-Four", "Dystopian", 1949, "ISBN-9780451524935",
                        "A totalitarian society under Big Brother.", orwell),
                new Book("Harry Potter and the Philosopher's Stone", "Fantasy", 1997, "ISBN-9780747532699",
                        "A boy discovers he is a wizard.", rowling),
                new Book("The Stranger", "Philosophical", 1942, "ISBN-9780679720201",
                        "An absurdist tale of an indifferent man.", camus),
                new Book("Pride and Prejudice", "Romance", 1813, "ISBN-9780141439518",
                        "A comedy of manners about marriage.", austen),
                new Book("The Metamorphosis", "Surrealism", 1915, "ISBN-9780393956398",
                        "A man wakes up transformed into an insect.", kafka),
                new Book("The Great Gatsby", "Classic", 1925, "ISBN-9780743273565",
                        "The Jazz Age and the American Dream.", fitzgerald),
                new Book("Beloved", "Historical", 1987, "ISBN-9781400033416",
                        "A haunting story of slavery's aftermath.", morrison),
                new Book("One Hundred Years of Solitude", "Magical Realism", 1967, "ISBN-9780060883287",
                        "The Buendía family saga over six generations.", garcia),
                new Book("Crime and Punishment", "Psychological", 1866, "ISBN-9780140449136",
                        "A student's moral crisis after committing murder.", dostoevsky));

        bookRepository.saveAll(books);

        System.out.println("✅ Database seeded with 10 authors and 10 books.");
    }
}
