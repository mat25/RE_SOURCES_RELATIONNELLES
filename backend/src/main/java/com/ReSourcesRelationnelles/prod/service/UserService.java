package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.*;
import com.ReSourcesRelationnelles.prod.dto.user.*;
import com.ReSourcesRelationnelles.prod.entity.Role;
import com.ReSourcesRelationnelles.prod.entity.RoleEnum;
import com.ReSourcesRelationnelles.prod.entity.UserStatusEnum;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.security.JwtUtil;
import com.ReSourcesRelationnelles.prod.security.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;

import java.util.List;

@Service
public class UserService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);
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
    @Autowired
    private SecurityUtils securityUtils;

    private void validateRegistration(RegisterDTO request) {
        if (userRepository.existsByEmailAndDeletedFalse(request.getEmail())) {
            throw new BadRequestException("L'email est déjà utilisé.");
        }
        if (userRepository.existsByUsernameAndDeletedFalse(request.getUsername())) {
            throw new BadRequestException("Le username est déjà utilisé.");
        }
    }

    public UserDTO createUser(RegisterDTO request) {
        validateRegistration(request);

        Role role = roleService.findByName(RoleEnum.USER)
                .orElseThrow(() -> new NotFoundException("Rôle USER introuvable."));

        String hashedPassword = passwordEncoder.encode(request.getPassword());

        User user = new User(
                request.getName(),
                request.getFirstName(),
                request.getUsername(),
                request.getEmail(),
                hashedPassword,
                role
        );

        log.info("Création d'un nouvel utilisateur : {}", request.getUsername());
        return new UserDTO(userRepository.save(user));
    }

    public UserDTO createUserWithRole(RegisterWithRoleDTO request) {
        validateRegistration(request);

        if (request.getRole() == null) {
            throw new BadRequestException("Le rôle est requis.");
        }

        RoleEnum roleEnum = request.getRole();

        Role role = roleService.findByName(roleEnum)
                .orElseThrow(() -> new NotFoundException("Rôle " + roleEnum.name() + " introuvable."));

        String hashedPassword = passwordEncoder.encode(request.getPassword());

        User user = new User(
                request.getName(),
                request.getFirstName(),
                request.getUsername(),
                request.getEmail(),
                hashedPassword,
                role
        );

        log.info("Création d'un utilisateur avec le rôle {} : {}", roleEnum.name(), request.getUsername());
        return new UserDTO(userRepository.save(user));
    }

    public TokenDTO loginUser(LoginDTO request) {

        log.info("Tentative de connexion pour l'utilisateur : {}", request.getUsername());

        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getUsername(),
                        request.getPassword()
                )
        );

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();

        User user = userRepository.findByUsernameAndDeletedFalse(userDetails.getUsername());

        if (user == null) {
            throw new NotFoundException("Utilisateur introuvable.");
        }

        if (user.getStatus() == UserStatusEnum.INACTIVE) {
            throw new BadRequestException("Ce compte est désactivé. Veuillez contacter un administrateur.");
        }

        String role = user.getRole().getName().name();
        String token = jwtUtils.generateToken(user.getUsername(), role);

        return new TokenDTO(token, user.getId());
    }

    public UserDTO getUserById(Long id) {
        log.info("Récupération de l'utilisateur avec l'ID : {}", id);

        User user = userRepository.findByIdAndDeletedFalse(id)
                .orElseThrow(() -> new NotFoundException("L'utilisateur avec l'ID '" + id + "' n'existe pas."));

        Role role = user.getRole();
        if (role == null || role.getName() != RoleEnum.USER) {
            throw new BadRequestException("Seuls les utilisateurs avec le rôle USER peuvent être consultés.");
        }

        return new UserDTO(user);
    }

    public List<UserDTO> getAllUsers() {
        log.info("Récupération de la liste complète des utilisateurs");
        return userRepository.findAllByDeletedFalse().stream()
                .map(UserDTO::new)
                .toList();
    }

    public UserDTO updateUser(Long id, UpdateUserDTO request) {
        User user = userRepository.findByIdAndDeletedFalse(id)
                .orElseThrow(() -> new NotFoundException("L'utilisateur '" + id + "' n'existe pas."));

        Role role = user.getRole();

        if (role == null || role.getName() != RoleEnum.USER) {
            throw new BadRequestException("Seuls les utilisateurs avec le rôle USER peuvent être modifié.");
        }

        if (request.getName() != null && !request.getName().isBlank()) {
            user.setName(request.getName());
        }
        if (request.getFirstName() != null && !request.getFirstName().isBlank()) {
            user.setFirstName(request.getFirstName());
        }
        if (request.getUsername() != null && !request.getUsername().isBlank()) {

            if (userRepository.existsByUsernameAndDeletedFalse(request.getUsername()) && !user.getUsername().equals(request.getUsername())) {
                throw new BadRequestException("Le username est déjà utilisé.");
            }
            user.setUsername(request.getUsername());
        }
        if (request.getEmail() != null && !request.getEmail().isBlank()) {

            if (userRepository.existsByEmailAndDeletedFalse(request.getEmail()) && !user.getEmail().equals(request.getEmail())) {
                throw new BadRequestException("L'email est déjà utilisé.");
            }
            user.setEmail(request.getEmail());
        }

        if (request.getPassword() != null && !request.getPassword().isBlank()) {

            user.setPassword(passwordEncoder.encode(request.getPassword()));
        }

        log.info("Mise à jour de l'utilisateur avec l'ID : {}", id);

        return new UserDTO(userRepository.save(user));
    }

    public UserDTO getCurrentUser(Authentication authentication) {

        User currentUser = securityUtils.getCurrentUser(authentication);

        return new UserDTO(currentUser);
    }

    public UserDTO updateCurrentUser(Authentication authentication, UpdateUserDTO request) {

        User currentUser = securityUtils.getCurrentUser(authentication);

        log.info("Mise à jour du compte de l'utilisateur connecté : {}", currentUser.getUsername());

        return updateUser(currentUser.getId(), request);
    }

    public MessageDTO deleteCurrentUser(Authentication authentication) {

        User currentUser = securityUtils.getCurrentUser(authentication);

        currentUser.setDeleted(true);
        userRepository.save(currentUser);

        log.warn("Suppression du compte de l'utilisateur connecté : {}", currentUser.getUsername());

        return new MessageDTO("Utilisateur supprimé avec succès.");
    }

    public MessageDTO deleteUser(Long id) {
        User user = userRepository.findByIdAndDeletedFalse(id)
                .orElseThrow(() -> new NotFoundException("L'utilisateur '" + id + "' n'existe pas."));

        Role role = user.getRole();

        if (role == null || role.getName() != RoleEnum.USER) {
            throw new BadRequestException("Seuls les utilisateurs avec le rôle USER peuvent être supprimés.");
        }

        user.setDeleted(true);
        userRepository.save(user);

        log.warn("Suppression de l'utilisateur avec l'ID : {}", id);

        return new MessageDTO("Utilisateur supprimé avec succès.");
    }

    public UserDTO toggleUserStatus(Long id) {
        User user = userRepository.findByIdAndDeletedFalse(id)
                .orElseThrow(() -> new NotFoundException("L'utilisateur '" + id + "' n'existe pas."));

        if (user.getRole() == null || user.getRole().getName() != RoleEnum.USER) {
            throw new BadRequestException("Seuls les utilisateurs avec le rôle USER peuvent être désactivés ou réactivés.");
        }

        if (user.getStatus() == UserStatusEnum.ACTIVE) {
            user.setStatus(UserStatusEnum.INACTIVE);
            log.info("Désactivation de l'utilisateur avec l'ID : {}", id);
        } else {
            user.setStatus(UserStatusEnum.ACTIVE);
            log.info("Réactivation de l'utilisateur avec l'ID : {}", id);
        }

        return new UserDTO(userRepository.save(user));
    }
}
