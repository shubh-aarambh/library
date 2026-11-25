package com.library.service.impl;

import com.library.exception.ResourceNotFoundException;
import com.library.model.Author;
import com.library.repository.AuthorRepository;
import com.library.service.AuthorService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class AuthorServiceImpl implements AuthorService {

    private final AuthorRepository authorRepository;

    public AuthorServiceImpl(AuthorRepository authorRepository) {
        this.authorRepository = authorRepository;
    }

    @Override
    @Transactional(readOnly = true)
    public List<Author> getAllAuthors() {
        return authorRepository.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public Author getAuthorById(Long id) {
        return authorRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Author not found with id: " + id));
    }

    @Override
    public Author saveAuthor(Author author) {
        if (author.getAvatarColor() == null || author.getAvatarColor().isBlank()) {
            author.setAvatarColor("#d97706");
        }
        return authorRepository.save(author);
    }

    @Override
    public Author updateAuthor(Long id, Author updatedAuthor) {
        Author existing = getAuthorById(id);
        existing.setName(updatedAuthor.getName());
        existing.setNationality(updatedAuthor.getNationality());
        existing.setBirthYear(updatedAuthor.getBirthYear());
        existing.setBiography(updatedAuthor.getBiography());
        if (updatedAuthor.getNotableAward() != null) {
            existing.setNotableAward(updatedAuthor.getNotableAward());
        }
        if (updatedAuthor.getAvatarColor() != null && !updatedAuthor.getAvatarColor().isBlank()) {
            existing.setAvatarColor(updatedAuthor.getAvatarColor());
        }
        return authorRepository.save(existing);
    }

    @Override
    public void deleteAuthor(Long id) {
        Author author = getAuthorById(id);
        authorRepository.delete(author);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Author> getAuthorsWithAtLeastOneBook() {
        return authorRepository.findAuthorsWithAtLeastOneBook();
    }

    @Override
    @Transactional(readOnly = true)
    public boolean authorExists(Long id) {
        return authorRepository.existsById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<String> getAllNationalities() {
        return authorRepository.findDistinctNationalities();
    }

    @Override
    @Transactional(readOnly = true)
    public List<Author> filterAuthors(String query, String nationality, boolean onlyWithBooks) {
        List<Author> source = onlyWithBooks ? authorRepository.findAuthorsWithAtLeastOneBook() : authorRepository.findAll();
        String q = query != null ? query.trim().toLowerCase() : "";
        String nat = nationality != null ? nationality.trim() : "";

        return source.stream()
                .filter(a -> q.isEmpty()
                        || (a.getName() != null && a.getName().toLowerCase().contains(q))
                        || (a.getNationality() != null && a.getNationality().toLowerCase().contains(q))
                        || (a.getNotableAward() != null && a.getNotableAward().toLowerCase().contains(q))
                        || (a.getBiography() != null && a.getBiography().toLowerCase().contains(q)))
                .filter(a -> nat.isEmpty() || nat.equalsIgnoreCase("ALL")
                        || (a.getNationality() != null && a.getNationality().equalsIgnoreCase(nat)))
                .sorted(Comparator.comparing(Author::getName, String.CASE_INSENSITIVE_ORDER))
                .collect(Collectors.toList());
    }
}
