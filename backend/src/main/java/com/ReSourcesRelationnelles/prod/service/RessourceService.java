package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.ressource.RessourceDTO;
import com.ReSourcesRelationnelles.prod.entity.Ressource;
import com.ReSourcesRelationnelles.prod.entity.StatutEnum;
import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.entity.VisibiliteEnum;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.RessourceRepository;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class RessourceService {

    @Autowired
    private RessourceRepository ressourceRepository;
    @Autowired
    private UserRepository userRepository;

    public List<RessourceDTO> getAllRessources(Authentication authentication) {

        List<Ressource> allRessources = ressourceRepository.findAll();
        List<RessourceDTO> filteredRessources = new ArrayList<>();
        User currentUser = null;

        if (authentication != null && authentication.getName() != null && !authentication.getName().isBlank()) {
            currentUser = userRepository.findByUsername(authentication.getName());
        }

        for (Ressource ressource : allRessources) {
            boolean isAcceptedAndPublic = ressource.getStatut() == StatutEnum.ACCEPTER &&
                    ressource.getVisibilite() == VisibiliteEnum.PUBLIQUE;

            boolean isOwner = currentUser != null && ressource.getCreateur().getId().equals(currentUser.getId());

            if (isAcceptedAndPublic || isOwner) {
                filteredRessources.add(new RessourceDTO(ressource));
            }
        }

        return filteredRessources;
    }



}