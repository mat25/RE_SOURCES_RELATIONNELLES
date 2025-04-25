package com.ReSourcesRelationnelles.prod.utility;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

public class PasswordHasher {

    private static final PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public static String hash(String plainPassword) {
        return passwordEncoder.encode(plainPassword);
    }

    public static boolean verify(String plainPassword, String hashedPassword) {
        return passwordEncoder.matches(plainPassword, hashedPassword);
    }
}