package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.CreateUserRequestDTO;
import com.ReSourcesRelationnelles.prod.utility.PasswordHasher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;

@Service
public class UserService {

    // Permet de faire de l'injection de dépendance
    @Autowired
    private UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public User createUser(CreateUserRequestDTO request) {

        String hashedPassword = PasswordHasher.hash(request.getPassword());

        User user = new User(request.getName(),request.getFirstName(), request.getPseudo(), request.getEmail(), hashedPassword);

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