package com.consulea.service;

import com.consulea.dao.UserDAO;
import com.consulea.entity.User;
import com.consulea.enums.Role;
import org.mindrot.jbcrypt.BCrypt;

import java.util.Optional;

public class AuthenticationService {

    private final UserDAO userDAO;

    public AuthenticationService() {
        this.userDAO = new UserDAO();
    }

    public Optional<User> login(String email, String password) {
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            return Optional.empty();
        }
        return userDAO.authenticate(email.trim().toLowerCase(), password);
    }

    public User register(String email, String password, String lastName, String firstName, Role role) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be empty");
        }
        if (password == null || password.length() < 6) {
            throw new IllegalArgumentException("Password must be at least 6 characters");
        }
        if (lastName == null || lastName.trim().isEmpty()) {
            throw new IllegalArgumentException("Last name cannot be empty");
        }
        if (firstName == null || firstName.trim().isEmpty()) {
            throw new IllegalArgumentException("First name cannot be empty");
        }
        if (role == null) {
            throw new IllegalArgumentException("Role cannot be null");
        }

        String normalizedEmail = email.trim().toLowerCase();

        if (userDAO.existsByEmail(normalizedEmail)) {
            throw new IllegalArgumentException("Email already exists");
        }

        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        User user = new User(normalizedEmail, hashedPassword, lastName.trim(), firstName.trim(), role);
        return userDAO.save(user);
    }

    public boolean isEmailAvailable(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return !userDAO.existsByEmail(email.trim().toLowerCase());
    }
}