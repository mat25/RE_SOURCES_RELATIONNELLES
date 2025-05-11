package com.ReSourcesRelationnelles.prod.controller;

import java.util.List;

import com.ReSourcesRelationnelles.prod.dto.RegisterDTO;
import com.ReSourcesRelationnelles.prod.dto.UserDTO;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

import com.ReSourcesRelationnelles.prod.service.UserService;
import com.ReSourcesRelationnelles.prod.dto.LoginDTO;

@RestController
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/users")
    @PreAuthorize("hasRole('USER')")
    public List<UserDTO> getAllUsers() {
        return userService.getAllUsers();
    }

    @GetMapping("/user/{id}")
    public ResponseEntity<Object> getUserById(@PathVariable Long id) {
        return userService.getUserById(id);
    }

    @PostMapping("/register")
    public ResponseEntity<Object> createUser(@RequestBody RegisterDTO request) {
        return userService.createUser(request);
    }

    @PostMapping("/login")
    public ResponseEntity<Object> loginUser(@RequestBody LoginDTO request) {
        return userService.loginUser(request);
    }
}
