package com.ReSourcesRelationnelles.prod.controller;

import java.util.List;

import com.ReSourcesRelationnelles.prod.dto.RegisterDTO;
import com.ReSourcesRelationnelles.prod.dto.UpdateUserDTO;
import com.ReSourcesRelationnelles.prod.dto.UserDTO;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
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
    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    public List<UserDTO> getAllUsers() {
        return userService.getAllUsers();
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @GetMapping("/users/{id}")
    public ResponseEntity<Object> getUserById(@PathVariable Long id) {
        return userService.getUserById(id);
    }

    @GetMapping("/users/me")
    public ResponseEntity<?> getCurrentUser(Authentication authentication) {
        return userService.getCurrentUser(authentication);
    }

    @PostMapping("/register")
    public ResponseEntity<Object> createUser(@RequestBody RegisterDTO request) {
        return userService.createUser(request);
    }

    @PostMapping("/login")
    public ResponseEntity<Object> loginUser(@RequestBody LoginDTO request) {
        return userService.loginUser(request);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @PatchMapping("/users/{id}")
    public ResponseEntity<Object> updateUser(@PathVariable Long id, @RequestBody UpdateUserDTO request) {
        return userService.updateUser(id, request);
    }

    @PatchMapping("/users/me")
    public ResponseEntity<Object> updateCurrentUser(@RequestBody UpdateUserDTO request, Authentication authentication) {
        return userService.updateCurrentUser(authentication, request);
    }
}
