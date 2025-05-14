package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.*;
import com.ReSourcesRelationnelles.prod.entity.Role;
import com.ReSourcesRelationnelles.prod.entity.RoleEnum;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
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

    public UserDTO createUser(RegisterDTO request) {
        if (request.getName() == null || request.getName().isBlank())
            throw new BadRequestException("Le nom est requis.");

        if (request.getFirstName() == null || request.getFirstName().isBlank())
            throw new BadRequestException("Le prénom est requis.");

        if (request.getUsername() == null || request.getUsername().isBlank())
            throw new BadRequestException("Le username est requis.");

        if (request.getEmail() == null || !request.getEmail().matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$"))
            throw new BadRequestException("Format d'email invalide.");

        if (request.getPassword() == null || request.getPassword().length() < 8)
            throw new BadRequestException("Le mot de passe doit contenir au moins 8 caractères.");

        if (userRepository.existsByEmail(request.getEmail()))
            throw new BadRequestException("L'email est déjà utilisé.");

        if (userRepository.existsByUsername(request.getUsername()))
            throw new BadRequestException("Le username est déjà utilisé.");

        Role role = roleService.findByName(RoleEnum.USER)
                .orElseThrow(() -> new NotFoundException("Rôle USER introuvable."));

        String hashedPassword = PasswordHasher.hash(request.getPassword());

        User user = new User(
                request.getName(),
                request.getFirstName(),
                request.getUsername(),
                request.getEmail(),
                hashedPassword,
                role
        );

        return new UserDTO(userRepository.save(user));
    }

    public TokenDTO loginUser(LoginDTO request) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();

        User user = userRepository.findByUsername(userDetails.getUsername());

        if (user == null)
            throw new NotFoundException("Utilisateur introuvable après authentification.");

        String role = user.getRole().getName().name();
        String token = jwtUtils.generateToken(user.getUsername(), role);

        return new TokenDTO(token, user.getId());
    }

    public UserDTO getUserById(Long id) {
        return userRepository.findById(id)
                .map(UserDTO::new)
                .orElseThrow(() -> new NotFoundException("L'utilisateur '" + id + "' n'existe pas."));
    }

    public List<UserDTO> getAllUsers() {
        return userRepository.findAll().stream()
                .map(UserDTO::new)
                .toList();
    }

    public UserDTO updateUser(Long id, UpdateUserDTO request) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("L'utilisateur '" + id + "' n'existe pas."));

        if (request.getName() != null && !request.getName().isBlank()) {
            user.setName(request.getName());
        }
        if (request.getFirstName() != null && !request.getFirstName().isBlank()) {
            user.setFirstName(request.getFirstName());
        }
        if (request.getUsername() != null && !request.getUsername().isBlank()) {
            user.setUsername(request.getUsername());
        }
        if (request.getEmail() != null && !request.getEmail().isBlank()) {
            user.setEmail(request.getEmail());
        }

        if (request.getPassword() != null && !request.getPassword().isBlank()) {
            user.setPassword(passwordEncoder.encode(request.getPassword()));
        }

        return new UserDTO(userRepository.save(user));
    }

    public UserDTO getCurrentUser(Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName());

        if (user == null)
            throw new NotFoundException("Utilisateur non trouvé.");

        return new UserDTO(user);
    }

    public UserDTO updateCurrentUser(Authentication authentication, UpdateUserDTO request) {
        User user = userRepository.findByUsername(authentication.getName());

        if (user == null)
            throw new NotFoundException("Utilisateur non trouvé.");

        return updateUser(user.getId(), request);
    }

    public MessageDTO deleteCurrentUser(Authentication authentication) {
        User user = userRepository.findByUsername(authentication.getName());

        if (user == null)
            throw new NotFoundException("Utilisateur non trouvé.");

        userRepository.delete(user);
        return new MessageDTO("Utilisateur supprimé avec succès.");
    }

    public MessageDTO deleteUser(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("L'utilisateur '" + id + "' n'existe pas."));

        userRepository.delete(user);
        return new MessageDTO("Utilisateur supprimé avec succès.");
    }
}
