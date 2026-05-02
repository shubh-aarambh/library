package com.library.service;

import com.library.exception.ResourceNotFoundException;
import com.library.model.Author;
import com.library.repository.AuthorRepository;
import com.library.service.impl.AuthorServiceImpl;
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
@DisplayName("AuthorService Unit Tests")
class AuthorServiceTest {

    @Mock
    private AuthorRepository authorRepository;

    @InjectMocks
    private AuthorServiceImpl authorService;

    private Author author;

    @BeforeEach
    void setUp() {
        author = new Author("Mark Twain", "American", 1835, "Father of American literature.");
        author.setId(1L);
    }

    @Test
    @DisplayName("getAllAuthors returns list of authors")
    void testGetAllAuthors() {
        when(authorRepository.findAll()).thenReturn(Arrays.asList(author, new Author()));
        List<Author> result = authorService.getAllAuthors();
        assertThat(result).hasSize(2);
        verify(authorRepository, times(1)).findAll();
    }

    @Test
    @DisplayName("getAuthorById returns author when exists")
    void testGetAuthorById_Found() {
        when(authorRepository.findById(1L)).thenReturn(Optional.of(author));
        Author result = authorService.getAuthorById(1L);
        assertThat(result.getName()).isEqualTo("Mark Twain");
    }

    @Test
    @DisplayName("getAuthorById throws ResourceNotFoundException when not found")
    void testGetAuthorById_NotFound() {
        when(authorRepository.findById(99L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> authorService.getAuthorById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Author not found with id: 99");
    }

    @Test
    @DisplayName("saveAuthor persists and returns author")
    void testSaveAuthor() {
        when(authorRepository.save(any(Author.class))).thenReturn(author);
        Author saved = authorService.saveAuthor(author);
        assertThat(saved.getName()).isEqualTo("Mark Twain");
        verify(authorRepository, times(1)).save(author);
    }

    @Test
    @DisplayName("updateAuthor updates fields on existing author")
    void testUpdateAuthor() {
        Author updated = new Author("Mark Twain Jr.", "American", 1860, "Updated bio.");
        when(authorRepository.findById(1L)).thenReturn(Optional.of(author));
        when(authorRepository.save(any(Author.class))).thenAnswer(inv -> inv.getArgument(0));

        Author result = authorService.updateAuthor(1L, updated);
        assertThat(result.getName()).isEqualTo("Mark Twain Jr.");
        assertThat(result.getBirthYear()).isEqualTo(1860);
    }

    @Test
    @DisplayName("deleteAuthor calls repository delete")
    void testDeleteAuthor() {
        when(authorRepository.findById(1L)).thenReturn(Optional.of(author));
        doNothing().when(authorRepository).delete(author);

        authorService.deleteAuthor(1L);
        verify(authorRepository, times(1)).delete(author);
    }

    @Test
    @DisplayName("getAuthorsWithAtLeastOneBook returns inner join result")
    void testGetAuthorsWithAtLeastOneBook() {
        when(authorRepository.findAuthorsWithAtLeastOneBook()).thenReturn(List.of(author));
        List<Author> result = authorService.getAuthorsWithAtLeastOneBook();
        assertThat(result).hasSize(1);
        assertThat(result.get(0).getName()).isEqualTo("Mark Twain");
    }

    @Test
    @DisplayName("authorExists returns true for known id")
    void testAuthorExists() {
        when(authorRepository.existsById(1L)).thenReturn(true);
        assertThat(authorService.authorExists(1L)).isTrue();
        verify(authorRepository, times(1)).existsById(1L);
    }
}
