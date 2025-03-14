package com.ReSourcesRelationnelles.prod.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;

@RestController
public class UserController {
    
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/users")
    // Sérialisation automatique grace a Jackson pour renvoyer du JSON
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }
    @GetMapping("/user")
    public List<User> getUserByName() {
        return userRepository.findByEmail("test@email.fr");
    }
}
