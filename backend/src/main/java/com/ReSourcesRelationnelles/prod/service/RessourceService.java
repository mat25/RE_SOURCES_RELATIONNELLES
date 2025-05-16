package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.ressource.CreateRessourceDTO;
import com.ReSourcesRelationnelles.prod.dto.ressource.RessourceDTO;
import com.ReSourcesRelationnelles.prod.entity.*;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.CategorieRepository;
import com.ReSourcesRelationnelles.prod.repository.RessourceRepository;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class RessourceService {

    @Autowired
    private RessourceRepository ressourceRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private CategorieRepository categorieRepository;

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

    public RessourceDTO createRessource(CreateRessourceDTO request, Authentication authentication) {
        if (authentication == null || authentication.getName().isBlank()) {
            throw new BadRequestException("Utilisateur non authentifié.");
        }

        User user = userRepository.findByUsername(authentication.getName());
        if (user == null) {
            throw new NotFoundException("Utilisateur introuvable.");
        }

        Categorie categorie = categorieRepository.findById(request.getCategorieId())
                .orElseThrow(() -> new NotFoundException("Catégorie introuvable."));

        Ressource ressource = new Ressource();
        ressource.setTitre(request.getTitre());
        ressource.setContenu(request.getContenu());
        ressource.setLienVideo(request.getLienVideo());
        ressource.setDateCreation(LocalDateTime.now());
        ressource.setVisibilite(VisibiliteEnum.valueOf(request.getVisibilite().toUpperCase()));
        ressource.setStatut(StatutEnum.EN_ATTENTE);
        ressource.setType(request.getType());
        ressource.setCategorie(categorie);
        ressource.setCreateur(user);

        Ressource ressourceSaved = ressourceRepository.save(ressource);
        return new RessourceDTO(ressourceSaved);
    }




}