package com.consulea.dao;

import com.consulea.entity.User;
import com.consulea.enums.Role;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.MockedStatic;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mindrot.jbcrypt.BCrypt;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UserDAO Login Tests")
class UserDAOTest {

    @Mock
    private UserDAO userDAO;

    private User testUser;
    private String hashedPassword;

    @BeforeEach
    void setUp() {
        // Create a test user with hashed password
        hashedPassword = BCrypt.hashpw("password123", BCrypt.gensalt());
        testUser = new User("test@example.com", hashedPassword, "Doe", "John", Role.MEDECIN_GENERALISTE);
        testUser.setId(1L);
    }

    @Test
    @DisplayName("authenticate should return user when email and password are correct")
    void authenticate_shouldReturnUser_whenCredentialsAreCorrect() {
        // Given
        String email = "test@example.com";
        String password = "password123";
        when(userDAO.authenticate(email, password)).thenReturn(Optional.of(testUser));

        // When
        Optional<User> result = userDAO.authenticate(email, password);

        // Then
        assertTrue(result.isPresent());
        assertEquals(testUser.getEmail(), result.get().getEmail());
        assertEquals(testUser.getRole(), result.get().getRole());
        verify(userDAO).authenticate(email, password);
    }

    @Test
    @DisplayName("authenticate should return empty when email does not exist")
    void authenticate_shouldReturnEmpty_whenEmailDoesNotExist() {
        // Given
        String email = "notfound@example.com";
        String password = "password123";
        when(userDAO.authenticate(email, password)).thenReturn(Optional.empty());

        // When
        Optional<User> result = userDAO.authenticate(email, password);

        // Then
        assertFalse(result.isPresent());
        verify(userDAO).authenticate(email, password);
    }

    @Test
    @DisplayName("authenticate should return empty when password is incorrect")
    void authenticate_shouldReturnEmpty_whenPasswordIsIncorrect() {
        // Given
        String email = "test@example.com";
        String wrongPassword = "wrongpassword";
        when(userDAO.authenticate(email, wrongPassword)).thenReturn(Optional.empty());

        // When
        Optional<User> result = userDAO.authenticate(email, wrongPassword);

        // Then
        assertFalse(result.isPresent());
        verify(userDAO).authenticate(email, wrongPassword);
    }

    @Test
    @DisplayName("findByEmail should return user when email exists")
    void findByEmail_shouldReturnUser_whenEmailExists() {
        // Given
        String email = "test@example.com";
        when(userDAO.findByEmail(email)).thenReturn(Optional.of(testUser));

        // When
        Optional<User> result = userDAO.findByEmail(email);

        // Then
        assertTrue(result.isPresent());
        assertEquals(testUser.getEmail(), result.get().getEmail());
        verify(userDAO).findByEmail(email);
    }

    @Test
    @DisplayName("findByEmail should return empty when email does not exist")
    void findByEmail_shouldReturnEmpty_whenEmailDoesNotExist() {
        // Given
        String email = "notfound@example.com";
        when(userDAO.findByEmail(email)).thenReturn(Optional.empty());

        // When
        Optional<User> result = userDAO.findByEmail(email);

        // Then
        assertFalse(result.isPresent());
        verify(userDAO).findByEmail(email);
    }

    @Test
    @DisplayName("existsByEmail should return true when email exists")
    void existsByEmail_shouldReturnTrue_whenEmailExists() {
        // Given
        String email = "test@example.com";
        when(userDAO.existsByEmail(email)).thenReturn(true);

        // When
        boolean result = userDAO.existsByEmail(email);

        // Then
        assertTrue(result);
        verify(userDAO).existsByEmail(email);
    }

    @Test
    @DisplayName("existsByEmail should return false when email does not exist")
    void existsByEmail_shouldReturnFalse_whenEmailDoesNotExist() {
        // Given
        String email = "notfound@example.com";
        when(userDAO.existsByEmail(email)).thenReturn(false);

        // When
        boolean result = userDAO.existsByEmail(email);

        // Then
        assertFalse(result);
        verify(userDAO).existsByEmail(email);
    }

    @Test
    @DisplayName("BCrypt password hashing should work correctly")
    void bcrypt_shouldHashAndVerifyPasswordCorrectly() {
        // Given
        String plainPassword = "mySecretPassword";
        
        // When
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
        boolean isCorrect = BCrypt.checkpw(plainPassword, hashedPassword);
        boolean isIncorrect = BCrypt.checkpw("wrongPassword", hashedPassword);
        
        // Then
        assertNotNull(hashedPassword);
        assertNotEquals(plainPassword, hashedPassword);
        assertTrue(isCorrect);
        assertFalse(isIncorrect);
    }
}