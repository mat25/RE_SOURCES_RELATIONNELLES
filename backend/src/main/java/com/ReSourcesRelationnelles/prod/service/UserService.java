package com.ReSourcesRelationnelles.prod.service;

import java.time.LocalDateTime;

import com.ReSourcesRelationnelles.prod.dto.CreateUserRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;

import jakarta.annotation.PostConstruct;

@Service
public class UserService {

    // Permet de faire de l'injection de dépendance
    @Autowired
    private UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User createUser(CreateUserRequest request) {
        User user = new User();
        user.setUsername(request.getUsername());
        user.setEmail(request.getEmail());
        user.setPassword(request.getPassword()); // Tu peux hash le mot de passe ici

        return userRepository.save(user);
    }

//    // Ajout au lancement de l'application
//    @PostConstruct
//    public void init() {
//        User user = new User();
//        user.setNom("Test Prenom");
//        user.setPrenom("Test Nom");
//        user.setPseudo("Test Pseudo");
//        user.setEmail("Test email");
//        user.setPassword("Test password");
//        user.setStatut(true);
//
//        LocalDateTime dateInscription = LocalDateTime.now();
//        user.setDateInscription(dateInscription);
//
//        userRepository.save(user);
//    }


}