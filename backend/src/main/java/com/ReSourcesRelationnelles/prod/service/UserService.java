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

        Optional<Role> optionalRole = roleService.findByName(RoleEnum.USER);

        if (optionalRole.isEmpty()) {
            return null;
        }

        String hashedPassword = PasswordHasher.hash(request.getPassword());

        User user = new User(
                request.getName(),
                request.getFirstName(),
                request.getUsername(),
                request.getEmail(),
                hashedPassword,
                optionalRole
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

        String token = jwtUtils.generateToken(userDetails.getUsername());

        return ResponseEntity.status(HttpStatus.OK)
                .body(new TokenDTO(token));
    }

    public ResponseEntity<Object> getUserById(Long id) {
        Optional<User> user = userRepository.findById(id);

        if (user.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(new ErrorDTO("L'utilisateur '"+id+"' n'existe pas."));
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


}