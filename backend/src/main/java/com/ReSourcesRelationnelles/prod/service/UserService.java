package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.CreateUserRequestDTO;
import com.ReSourcesRelationnelles.prod.dto.ErrorDTO;
import com.ReSourcesRelationnelles.prod.dto.UserDTO;
import com.ReSourcesRelationnelles.prod.utility.PasswordHasher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
public class UserService {

    // Permet de faire de l'injection de dépendance
    @Autowired
    private UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public ResponseEntity<Object> createUser(CreateUserRequestDTO request) {

        if (userRepository.existsByEmail(request.getEmail())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorDTO("L'email est déjà utilisé."));
        }


        if (userRepository.existsByPseudo(request.getPseudo())) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ErrorDTO("Le pseudo est déjà utilisé."));
        }

        String hashedPassword = PasswordHasher.hash(request.getPassword());

        User user = new User(
                request.getName(),
                request.getFirstName(),
                request.getPseudo(),
                request.getEmail(),
                hashedPassword
        );

        User savedUser = userRepository.save(user);

        UserDTO userDTO = new UserDTO(savedUser);

        return ResponseEntity.status(HttpStatus.CREATED).body(userDTO);
    }

    public ResponseEntity<UserDTO> getUserById(Long id) {
        Optional<User> user = userRepository.findById(id);

        if (user.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
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