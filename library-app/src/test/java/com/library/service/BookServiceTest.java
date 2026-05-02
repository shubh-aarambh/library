package com.library.service;

import com.library.exception.ResourceNotFoundException;
import com.library.model.Author;
import com.library.model.Book;
import com.library.repository.AuthorRepository;
import com.library.repository.BookRepository;
import com.library.service.impl.BookServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("BookService Unit Tests")
class BookServiceTest {

    @Mock
    private BookRepository bookRepository;

    @Mock
    private AuthorRepository authorRepository;

    @InjectMocks
    private BookServiceImpl bookService;

    private Author author;
    private Book book;

    @BeforeEach
    void setUp() {
        author = new Author("Virginia Woolf", "British", 1882, "Modernist novelist.");
        author.setId(1L);

        book = new Book("Mrs Dalloway", "Modernist", 1925, "ISBN-W01", "A day in the life of Clarissa Dalloway.",
                author);
        book.setId(1L);
    }

    @Test
    @DisplayName("getAllBooks returns list of books")
    void testGetAllBooks() {
        when(bookRepository.findAll()).thenReturn(Arrays.asList(book, new Book()));
        List<Book> result = bookService.getAllBooks();
        assertThat(result).hasSize(2);
        verify(bookRepository, times(1)).findAll();
    }

    @Test
    @DisplayName("getBookById returns book when found")
    void testGetBookById_Found() {
        when(bookRepository.findById(1L)).thenReturn(Optional.of(book));
        Book result = bookService.getBookById(1L);
        assertThat(result.getTitle()).isEqualTo("Mrs Dalloway");
    }

    @Test
    @DisplayName("getBookById throws ResourceNotFoundException when missing")
    void testGetBookById_NotFound() {
        when(bookRepository.findById(99L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> bookService.getBookById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Book not found with id: 99");
    }

    @Test
    @DisplayName("saveBook resolves author and saves book")
    void testSaveBook() {
        when(authorRepository.findById(1L)).thenReturn(Optional.of(author));
        when(bookRepository.save(any(Book.class))).thenReturn(book);

        Book saved = bookService.saveBook(book);
        assertThat(saved.getTitle()).isEqualTo("Mrs Dalloway");
        verify(bookRepository, times(1)).save(book);
    }

    @Test
    @DisplayName("saveBook throws when author not found")
    void testSaveBook_AuthorNotFound() {
        when(authorRepository.findById(1L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> bookService.saveBook(book))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Author not found");
    }

    @Test
    @DisplayName("updateBook updates fields on existing book")
    void testUpdateBook() {
        Book updated = new Book("To the Lighthouse", "Modernist", 1927, "ISBN-W02", "A seaside family.", author);
        updated.setAuthor(author);

        when(bookRepository.findById(1L)).thenReturn(Optional.of(book));
        when(authorRepository.findById(1L)).thenReturn(Optional.of(author));
        when(bookRepository.save(any(Book.class))).thenAnswer(inv -> inv.getArgument(0));

        Book result = bookService.updateBook(1L, updated);
        assertThat(result.getTitle()).isEqualTo("To the Lighthouse");
        assertThat(result.getIsbn()).isEqualTo("ISBN-W02");
    }

    @Test
    @DisplayName("deleteBook calls repository delete")
    void testDeleteBook() {
        when(bookRepository.findById(1L)).thenReturn(Optional.of(book));
        doNothing().when(bookRepository).delete(book);

        bookService.deleteBook(1L);
        verify(bookRepository, times(1)).delete(book);
    }

    @Test
    @DisplayName("getAllBooksWithAuthorDetails returns joined rows")
    void testGetAllBooksWithAuthorDetails() {
        Object[] row = { "Mrs Dalloway", "Modernist", "ISBN-W01", 1925, "Virginia Woolf" };
        List<Object[]> joinedRows = new java.util.ArrayList<>();
        joinedRows.add(row);
        when(bookRepository.findAllBooksWithAuthorDetails()).thenReturn(joinedRows);

        List<Object[]> result = bookService.getAllBooksWithAuthorDetails();
        assertThat(result).hasSize(1);
        assertThat(result.get(0)[4]).isEqualTo("Virginia Woolf");
    }

    @Test
    @DisplayName("getBooksByAuthorId returns correct books")
    void testGetBooksByAuthorId() {
        when(bookRepository.findByAuthorId(1L)).thenReturn(List.of(book));
        List<Book> result = bookService.getBooksByAuthorId(1L);
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getIsbn()).isEqualTo("ISBN-W01");
    }
}
