package com.ReSourcesRelationnelles.prod.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.ReSourcesRelationnelles.prod.dto.UserByIdDTO;
import com.ReSourcesRelationnelles.prod.dto.UserDTO;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import com.ReSourcesRelationnelles.prod.entity.User;
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
        List<User> users = userRepository.findAll();

        List<UserDTO> userDTOList = new ArrayList<>();

        for (User user : users) {
            userDTOList.add(new UserDTO(user));
        }

        return userDTOList;
    }

    @GetMapping("/userById")
    public Optional<User> getUserById(@RequestBody UserByIdDTO ) {
        return userRepository.findById(id);
    }

    @PostMapping("/register")
    public ResponseEntity<UserDTO> createUser(@RequestBody CreateUserRequestDTO request) {
        User createdUser = userService.createUser(request);

        UserDTO userDTO = new UserDTO(createdUser);

        return ResponseEntity.status(HttpStatus.OK).body(userDTO);
    }
}
