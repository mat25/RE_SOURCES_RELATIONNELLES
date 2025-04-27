package com.ReSourcesRelationnelles.prod.controller;

import java.util.List;

import com.ReSourcesRelationnelles.prod.dto.UserDTO;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

import com.ReSourcesRelationnelles.prod.repository.UserRepository;
import com.ReSourcesRelationnelles.prod.service.UserService;
import com.ReSourcesRelationnelles.prod.dto.CreateUserRequestDTO;

@RestController
public class UserController {

    private final UserRepository userRepository;
    private final UserService userService;

    public UserController(UserRepository userRepository, UserService userService) {
        this.userRepository = userRepository;
        this.userService = userService;
    }

    @GetMapping("/users")
    public List<UserDTO> getAllUsers() {
        return userService.getAllUsers();
    }

    @GetMapping("/user/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Long id) {
        return userService.getUserById(id);
    }

    @PostMapping("/register")
    public ResponseEntity<Object> createUser(@RequestBody CreateUserRequestDTO request) {
        return userService.createUser(request);
    }
}
