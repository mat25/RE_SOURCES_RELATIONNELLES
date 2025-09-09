package com.ReSourcesRelationnelles.prod.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import com.ReSourcesRelationnelles.prod.dto.MessageDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.CreateResourceDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.ResourceDTO;
import com.ReSourcesRelationnelles.prod.entity.Category;
import com.ReSourcesRelationnelles.prod.entity.Resource;
import com.ReSourcesRelationnelles.prod.entity.ResourceStatusEnum;
import com.ReSourcesRelationnelles.prod.entity.ResourceTypeEnum;
import com.ReSourcesRelationnelles.prod.entity.ResourceUserProgression;
import com.ReSourcesRelationnelles.prod.entity.ResourceVisibilityEnum;
import com.ReSourcesRelationnelles.prod.entity.RoleEnum;
import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.CategoryRepository;
import com.ReSourcesRelationnelles.prod.repository.ResourceRepository;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;
import com.ReSourcesRelationnelles.prod.security.SecurityUtils;

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

    /** Retourne true si l'utilisateur a l'un des rôles donnés. Null-safe. */
    private boolean hasAnyRole(User u, RoleEnum... roles) {
        if (u == null || u.getRole() == null || u.getRole().getName() == null) return false;
        RoleEnum name = u.getRole().getName();
        for (RoleEnum r : roles) {
            if (name == r) return true;
        }
        return false;
    }

    public ResourceDTO getResourceById(Long resourceId, Authentication authentication) {
        Resource resource = resourceRepository.findById(resourceId)
                .orElseThrow(() -> new NotFoundException("Ressource non trouvée."));

        if (!resource.isActive()) {
            throw new NotFoundException("Ressource supprimée.");
        }

        // Récupération de l'utilisateur courant (peut être null si non authentifié)
        final User currentUser =
                (authentication != null && authentication.getName() != null && !authentication.getName().isBlank())
                        ? userRepository.findByUsernameAndDeletedFalse(authentication.getName())
                        : null;

        boolean isAcceptedAndPublic =
                resource.getStatus() == ResourceStatusEnum.ACCEPTED
                        && resource.getVisibility() == ResourceVisibilityEnum.PUBLIC;

        boolean isOwner = currentUser != null
                && resource.getCreator() != null
                && Objects.equals(resource.getCreator().getId(), currentUser.getId());

        boolean isModeratorOrHigher = hasAnyRole(currentUser,
                RoleEnum.MODERATOR, RoleEnum.ADMIN, RoleEnum.SUPER_ADMIN);

        if (!isAcceptedAndPublic && !isOwner && !isModeratorOrHigher) {
            throw new BadRequestException("Vous n'avez pas accès à cette ressource.");
        }

        if (currentUser != null) {
            ResourceUserProgression progression = (resource.getProgressions() != null)
                    ? resource.getProgressions().stream()
                        .filter(p -> p != null
                                && p.getUser() != null
                                && p.getUser().getId() != null
                                && currentUser.getId() != null
                                && p.getUser().getId().equals(currentUser.getId()))
                        .findFirst()
                        .orElse(null)
                    : null;

            return new ResourceDTO(resource, progression);
        }

        return new ResourceDTO(resource);
    }

    public List<ResourceDTO> getAllResources(Authentication authentication) {
        List<Resource> allResources = resourceRepository.findAll();
        List<ResourceDTO> filteredResources = new ArrayList<>();

        final User currentUser =
                (authentication != null && authentication.getName() != null && !authentication.getName().isBlank())
                        ? userRepository.findByUsernameAndDeletedFalse(authentication.getName())
                        : null;

        boolean isModeratorOrHigher = hasAnyRole(currentUser,
                RoleEnum.MODERATOR, RoleEnum.ADMIN, RoleEnum.SUPER_ADMIN);

        for (Resource resource : allResources) {
            if (resource == null || !resource.isActive()) continue;

            boolean isAcceptedAndPublic =
                    resource.getStatus() == ResourceStatusEnum.ACCEPTED
                            && resource.getVisibility() == ResourceVisibilityEnum.PUBLIC;

            boolean isOwner = currentUser != null
                    && resource.getCreator() != null
                    && Objects.equals(resource.getCreator().getId(), currentUser.getId());

            if (isAcceptedAndPublic || isOwner || isModeratorOrHigher) {
                if (currentUser != null) {
                    ResourceUserProgression progression = (resource.getProgressions() != null)
                            ? resource.getProgressions().stream()
                                .filter(p -> p != null
                                        && p.getUser() != null
                                        && p.getUser().getId() != null
                                        && currentUser.getId() != null
                                        && p.getUser().getId().equals(currentUser.getId()))
                                .findFirst()
                                .orElse(null)
                            : null;

                    filteredResources.add(new ResourceDTO(resource, progression));
                } else {
                    filteredResources.add(new ResourceDTO(resource));
                }
            }
        }

        return filteredResources;
    }

    public ResourceDTO createResource(CreateResourceDTO request, Authentication authentication) {
        if (authentication == null || authentication.getName() == null || authentication.getName().isBlank()) {
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

        boolean isAdmin = hasAnyRole(currentUser, RoleEnum.ADMIN);
        boolean isSuperAdmin = hasAnyRole(currentUser, RoleEnum.SUPER_ADMIN);

        if (!isAdmin && !isSuperAdmin) {
            if (resource.getCreator() == null || currentUser == null
                    || !Objects.equals(resource.getCreator().getId(), currentUser.getId())) {
                throw new BadRequestException("Vous ne pouvez supprimer que vos propres ressources.");
            }
        }

        resource.setActive(false);
        resourceRepository.save(resource);

        log.warn("Suppression de la ressource ID {} par l'utilisateur {}", resourceId,
                currentUser != null ? currentUser.getUsername() : "inconnu");

        return new MessageDTO("Ressource supprimée avec succès.");
    }

    public ResourceDTO updateResource(Long resourceId, CreateResourceDTO request, Authentication authentication) {
        User currentUser = securityUtils.getCurrentUser(authentication);

        Resource resource = resourceRepository.findById(resourceId)
                .orElseThrow(() -> new NotFoundException("Ressource non trouvée."));

        if (!resource.isActive()) {
            throw new BadRequestException("Impossible de modifier une ressource supprimée.");
        }

        boolean isOwner = resource.getCreator() != null
                && currentUser != null
                && Objects.equals(resource.getCreator().getId(), currentUser.getId());
        boolean isModerator = hasAnyRole(currentUser, RoleEnum.MODERATOR);
        boolean isAdmin = hasAnyRole(currentUser, RoleEnum.ADMIN);
        boolean isSuperAdmin = hasAnyRole(currentUser, RoleEnum.SUPER_ADMIN);

        // Edition par le propriétaire
        if (isOwner) {
            if (request.getTitle() != null) resource.setTitle(request.getTitle());
            if (request.getContent() != null) resource.setContent(request.getContent());
            if (request.getVideoLink() != null) resource.setVideoLink(request.getVideoLink());

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

            // Toute édition propriétaire remet en PENDING
            resource.setStatus(ResourceStatusEnum.PENDING);
        }

        // Modération (statut) par rôles élevés
        if (isModerator || isAdmin || isSuperAdmin) {
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
        log.info("Mise à jour de la ressource ID {} par {}", resourceId,
                currentUser != null ? currentUser.getUsername() : "inconnu");

        return new ResourceDTO(updated);
    }
}
