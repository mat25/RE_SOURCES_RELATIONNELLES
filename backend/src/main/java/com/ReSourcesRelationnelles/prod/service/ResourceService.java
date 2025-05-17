package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.MessageDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.CreateResourceDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.ResourceDTO;
import com.ReSourcesRelationnelles.prod.entity.*;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.CategoryRepository;
import com.ReSourcesRelationnelles.prod.repository.ResourceRepository;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;
import com.ReSourcesRelationnelles.prod.security.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class ResourceService {

    private static final Logger log = LoggerFactory.getLogger(UserService.class);
    @Autowired
    private ResourceRepository resourceRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private CategoryRepository categoryRepository;
    @Autowired
    private SecurityUtils securityUtils;

    public List<ResourceDTO> getAllResources(Authentication authentication) {
        List<Resource> allResources = resourceRepository.findAll();
        List<ResourceDTO> filteredResources = new ArrayList<>();
        User currentUser = null;

        if (authentication != null && authentication.getName() != null && !authentication.getName().isBlank()) {
            currentUser = userRepository.findByUsername(authentication.getName());
        }

        for (Resource resource : allResources) {

            if (resource.isActive()) {
                boolean isAcceptedAndPublic = resource.getStatus() == StatusEnum.ACCEPTED &&
                        resource.getVisibility() == VisibilityEnum.PUBLIC;

                boolean isOwner = currentUser != null && resource.getCreator().getId().equals(currentUser.getId());

                if (isAcceptedAndPublic || isOwner) {
                    filteredResources.add(new ResourceDTO(resource));
                }
            }
        }

        return filteredResources;
    }

    public ResourceDTO createResource(CreateResourceDTO request, Authentication authentication) {
        if (authentication == null || authentication.getName().isBlank()) {
            throw new BadRequestException("Utilisateur non identifié.");
        }

        User user = userRepository.findByUsername(authentication.getName());
        if (user == null) {
            throw new NotFoundException("Utilisateur introuvable.");
        }

        Category category = categoryRepository.findById(request.getCategoryId())
                .orElseThrow(() -> new NotFoundException("Catégorie introuvable."));

        Resource resource = new Resource();
        resource.setTitle(request.getTitle());
        resource.setContent(request.getContent());
        resource.setVideoLink(request.getVideoLink());
        resource.setCreationDate(LocalDateTime.now());
        resource.setVisibility(VisibilityEnum.valueOf(request.getVisibility().toUpperCase()));
        resource.setStatus(StatusEnum.PENDING);
        resource.setType(request.getType());
        resource.setActive(true);
        resource.setCategory(category);
        resource.setCreator(user);

        Resource savedResource = resourceRepository.save(resource);

        log.info("Création de la ressource ID {} par l'utilisateur {}", savedResource.getId(), user.getUsername());

        return new ResourceDTO(savedResource);
    }

    public MessageDTO deleteResource(Long resourceId, Authentication authentication) {
        User currentUser = securityUtils.getCurrentUser(authentication);

        Resource resource = resourceRepository.findById(resourceId)
                .orElseThrow(() -> new NotFoundException("Ressource non trouvée."));

        boolean isAdmin = currentUser.getRole().getName() == RoleEnum.ADMIN;
        boolean isSuperAdmin = currentUser.getRole().getName() == RoleEnum.SUPER_ADMIN;

        if (!isAdmin && !isSuperAdmin) {
            if (!resource.getCreator().getId().equals(currentUser.getId())) {
                throw new BadRequestException("Vous ne pouvez supprimer que vos propres ressources.");
            }
        }

        resource.setActive(false);
        resourceRepository.save(resource);

        log.warn("Suppression de la ressource ID {} par l'utilisateur {}", resourceId, currentUser.getUsername());

        return new MessageDTO("Ressource supprimée avec succès.");
    }

    public ResourceDTO updateResource(Long resourceId, CreateResourceDTO request, Authentication authentication) {
        User currentUser = securityUtils.getCurrentUser(authentication);

        Resource resource = resourceRepository.findById(resourceId)
                .orElseThrow(() -> new NotFoundException("Ressource non trouvée."));

        if (!resource.isActive()) {
            throw new BadRequestException("Impossible de modifier une ressource supprimée.");
        }

        boolean isOwner = resource.getCreator().getId().equals(currentUser.getId());
        boolean isModerator = currentUser.getRole().getName() == RoleEnum.MODERATOR;
        boolean isAdmin = currentUser.getRole().getName() == RoleEnum.ADMIN;
        boolean isSuperAdmin = currentUser.getRole().getName() == RoleEnum.SUPER_ADMIN;

        if (isOwner) {
            if (request.getTitle() != null) {
                resource.setTitle(request.getTitle());
            }
            if (request.getContent() != null) {
                resource.setContent(request.getContent());
            }
            if (request.getVideoLink() != null) {
                resource.setVideoLink(request.getVideoLink());
            }
            if (request.getVisibility() != null) {
                try {
                    resource.setVisibility(VisibilityEnum.valueOf(request.getVisibility().toUpperCase()));
                } catch (IllegalArgumentException e) {
                    throw new BadRequestException("Visibilité invalide.");
                }
            }
            if (request.getType() != null) {
                resource.setType(request.getType());
            }
            if (request.getCategoryId() != null) {
                Category category = categoryRepository.findById(request.getCategoryId())
                        .orElseThrow(() -> new NotFoundException("Catégorie introuvable."));
                resource.setCategory(category);
            }

            resource.setStatus(StatusEnum.PENDING);
        }

        if ((isModerator || isAdmin || isSuperAdmin)) {
            if (request.getStatus() == null) {
                throw new BadRequestException("Statut invalide.");
            }
            try {
                resource.setStatus(StatusEnum.valueOf(request.getStatus().toUpperCase()));
            } catch (IllegalArgumentException e) {
                throw new BadRequestException("Statut invalide.");
            }
        }

        if (!isOwner && !isModerator && !isAdmin && !isSuperAdmin) {
            throw new BadRequestException("Vous ne pouvez modifier que vos propres ressources.");
        }

        Resource updated = resourceRepository.save(resource);
        log.info("Mise à jour de la ressource ID {} par {}", resourceId, currentUser.getUsername());

        return new ResourceDTO(updated);
    }


}
