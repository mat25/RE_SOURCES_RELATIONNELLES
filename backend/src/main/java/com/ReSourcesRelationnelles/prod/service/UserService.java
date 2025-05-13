package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.*;
import com.ReSourcesRelationnelles.prod.entity.Role;
import com.ReSourcesRelationnelles.prod.entity.RoleEnum;
import com.ReSourcesRelationnelles.prod.security.JwtUtil;
import com.ReSourcesRelationnelles.prod.utility.PasswordHasher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private RoleService roleService;
    @Autowired
    AuthenticationManager authenticationManager;
    @Autowired
    JwtUtil jwtUtils;
    @Autowired
    private PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public ResponseEntity<Object> createUser(RegisterDTO request) {

        if (userRepository.existsByEmail(request.getEmail())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorDTO("L'email est déjà utilisé."));
        }


        if (userRepository.existsByUsername(request.getUsername())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorDTO("Le username est déjà utilisé."));
        }

        Role role = roleService.findByName(RoleEnum.USER).orElseThrow(() -> new RuntimeException("Role USER not found"));

        String hashedPassword = PasswordHasher.hash(request.getPassword());

        User user = new User(
                request.getName(),
                request.getFirstName(),
                request.getUsername(),
                request.getEmail(),
                hashedPassword,
                role
        );

        User savedUser = userRepository.save(user);

        UserDTO userDTO = new UserDTO(savedUser);

        return ResponseEntity.status(HttpStatus.CREATED).body(userDTO);
    }

    public ResponseEntity<Object> loginUser(LoginDTO request) {

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();

        User user = userRepository.findByUsername(userDetails.getUsername());

        if (!user.getUsername().equals(request.getUsername())) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ErrorDTO("Utilisateur introuvable après authentification."));
        }

        String role = user.getRole().getName().name();

        String token = jwtUtils.generateToken(user.getUsername(),role);

        return ResponseEntity.status(HttpStatus.OK)
                .body(new TokenDTO(token, user.getId()));
    }

    public ResponseEntity<Object> getUserById(Long id) {
        Optional<User> user = userRepository.findById(id);

        if (user.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ErrorDTO("L'utilisateur '" + id + "' n'existe pas."));
        }

        UserDTO userDTO = new UserDTO(user.get());
        return ResponseEntity.status(HttpStatus.OK).body(userDTO);
    }

    public List<UserDTO> getAllUsers() {
        List<User> users = userRepository.findAll();

        List<UserDTO> userDTOList = new ArrayList<>();

        for (User user : users) {
            userDTOList.add(new UserDTO(user));
        }

        return userDTOList;
    }

    public ResponseEntity<Object> updateUser(Long id, UpdateUserDTO request) {
        Optional<User> optionalUser = userRepository.findById(id);

        if (optionalUser.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ErrorDTO("L'utilisateur '" + id + "' n'existe pas."));
        }

        User user = optionalUser.get();

        if (request.getName() != null && !request.getName().isBlank()) {
            user.setName(request.getName());
        }

        if (request.getUsername() != null && !request.getUsername().isBlank()) {
            user.setUsername(request.getUsername());
        }

        if (request.getFirstName() != null && !request.getFirstName().isBlank()) {
            user.setFirstName(request.getFirstName());
        }

        if (request.getEmail() != null && !request.getEmail().isBlank()) {
            user.setEmail(request.getEmail());
        }

        if (request.getPassword() != null && !request.getPassword().isBlank()) {
            String hashedPassword = passwordEncoder.encode(request.getPassword());
            user.setPassword(hashedPassword);
        }

        User updatedUser = userRepository.save(user);

        UserDTO userDTO = new UserDTO(updatedUser);

        return ResponseEntity.status(HttpStatus.OK).body(userDTO);
    }

    public ResponseEntity<Object> getCurrentUser(Authentication authentication) {
        String username = authentication.getName();
        User user = userRepository.findByUsername(username);

        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ErrorDTO("Utilisateur non trouvé."));
        }

        UserDTO userDTO = new UserDTO(user);

        return ResponseEntity.ok(userDTO);
    }

    public ResponseEntity<Object> updateCurrentUser(Authentication authentication, UpdateUserDTO request) {
        String username = authentication.getName();
        User user = userRepository.findByUsername(username);

        if (user == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(new ErrorDTO("Utilisateur non trouvé."));
        }

        return updateUser(user.getId(), request);
    }
}