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

        final User currentUser = (authentication != null && authentication.getName() != null && !authentication.getName().isBlank())
                ? userRepository.findByUsernameAndDeletedFalse(authentication.getName())
                : null;

        for (Resource resource : allResources) {
            if (!resource.isActive()) continue;

            boolean isAcceptedAndPublic = resource.getStatus() == ResourceStatusEnum.ACCEPTED &&
                    resource.getVisibility() == ResourceVisibilityEnum.PUBLIC;

            boolean isOwner = currentUser != null && resource.getCreator().getId().equals(currentUser.getId());

            if (isAcceptedAndPublic || isOwner) {
                if (currentUser != null) {
                    ResourceUserProgression progression = resource
                            .getProgressions()
                            .stream()
                            .filter(p -> p.getUser().getId().equals(currentUser.getId()))
                            .findFirst()
                            .orElse(null);

                    filteredResources.add(new ResourceDTO(resource, progression));
                } else {
                    filteredResources.add(new ResourceDTO(resource));
                }
            }
        }

        return filteredResources;
    }

    public ResourceDTO getResourceById(Long resourceId, Authentication authentication) {
        Resource resource = resourceRepository.findById(resourceId)
                .orElseThrow(() -> new NotFoundException("Ressource non trouvée."));

        if (!resource.isActive()) {
            throw new NotFoundException("Ressource supprimée.");
        }

        final User currentUser = (authentication != null && authentication.getName() != null && !authentication.getName().isBlank())
                ? userRepository.findByUsernameAndDeletedFalse(authentication.getName())
                : null;

        boolean isAcceptedAndPublic = resource.getStatus() == ResourceStatusEnum.ACCEPTED &&
                resource.getVisibility() == ResourceVisibilityEnum.PUBLIC;

        boolean isOwner = currentUser != null && resource.getCreator().getId().equals(currentUser.getId());

        if (!isAcceptedAndPublic && !isOwner) {
            throw new BadRequestException("Vous n'avez pas accès à cette ressource.");
        }

        if (currentUser != null) {
            ResourceUserProgression progression = resource.getProgressions()
                    .stream()
                    .filter(p -> p.getUser().getId().equals(currentUser.getId()))
                    .findFirst()
                    .orElse(null);
            return new ResourceDTO(resource, progression);
        }

        return new ResourceDTO(resource);
    }

    public ResourceDTO createResource(CreateResourceDTO request, Authentication authentication) {
        if (authentication == null || authentication.getName().isBlank()) {
            throw new BadRequestException("Utilisateur non identifié.");
        }

        User user = userRepository.findByUsernameAndDeletedFalse(authentication.getName());
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
        resource.setVisibility(ResourceVisibilityEnum.valueOf(request.getVisibility().toUpperCase()));
        resource.setStatus(ResourceStatusEnum.PENDING);
        resource.setType(ResourceTypeEnum.valueOf(request.getType().toUpperCase()));
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
                    resource.setVisibility(ResourceVisibilityEnum.valueOf(request.getVisibility().toUpperCase()));
                } catch (IllegalArgumentException e) {
                    throw new BadRequestException("Visibilité invalide.");
                }
            }
            if (request.getType() != null) {
                try {
                    resource.setType(ResourceTypeEnum.valueOf(request.getType().toUpperCase()));
                } catch (IllegalArgumentException e) {
                    throw new BadRequestException("Type de ressource invalide.");
                }
            }
            if (request.getCategoryId() != null) {
                Category category = categoryRepository.findById(request.getCategoryId())
                        .orElseThrow(() -> new NotFoundException("Catégorie introuvable."));
                resource.setCategory(category);
            }

            resource.setStatus(ResourceStatusEnum.PENDING);
        }

        if ((isModerator || isAdmin || isSuperAdmin)) {
            if (request.getStatus() == null) {
                throw new BadRequestException("Statut invalide.");
            }
            try {
                resource.setStatus(ResourceStatusEnum.valueOf(request.getStatus().toUpperCase()));
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
