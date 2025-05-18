package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.MessageDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.ResourceUserProgressionDTO;
import com.ReSourcesRelationnelles.prod.entity.*;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.ResourceRepository;
import com.ReSourcesRelationnelles.prod.repository.ResourceUserProgressionRepository;
import com.ReSourcesRelationnelles.prod.security.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ResourceUserProgressionService {

    @Autowired
    private ResourceUserProgressionRepository progressionRepository;

    @Autowired
    private ResourceRepository resourceRepository;

    @Autowired
    private SecurityUtils securityUtils;

    private ResourceUserProgression getOrCreateProgression(User user, Resource resource) {
        return progressionRepository.findByUserAndResource(user, resource)
                .orElseGet(() -> {
                    ResourceUserProgression progression = new ResourceUserProgression();
                    progression.setUser(user);
                    progression.setResource(resource);
                    return progression;
                });
    }

    private Resource getActiveResource(Long resourceId) {
        Resource resource = resourceRepository.findById(resourceId)
                .orElseThrow(() -> new NotFoundException("Ressource introuvable."));
        if (!resource.isActive()) {
            throw new NotFoundException("La ressource est inactive.");
        }
        return resource;
    }

    public MessageDTO toggleFavorite(Long resourceId, Authentication auth) {
        User user = securityUtils.getCurrentUser(auth);
        Resource resource = getActiveResource(resourceId);

        validateUserCanInteractWithResource(user, resource);

        ResourceUserProgression progression = getOrCreateProgression(user, resource);
        progression.setFavorite(!progression.isFavorite());
        progressionRepository.save(progression);
        return new MessageDTO("Favori mis à jour.");
    }

    public MessageDTO toggleExploited(Long resourceId, Authentication auth) {
        User user = securityUtils.getCurrentUser(auth);
        Resource resource = getActiveResource(resourceId);

        validateUserCanInteractWithResource(user, resource);

        ResourceUserProgression progression = getOrCreateProgression(user, resource);
        progression.setExploited(!progression.isExploited());
        progressionRepository.save(progression);
        return new MessageDTO("Statut d'exploitation mis à jour.");
    }

    public MessageDTO toggleSetAside(Long resourceId, Authentication auth) {
        User user = securityUtils.getCurrentUser(auth);
        Resource resource = getActiveResource(resourceId);

        validateUserCanInteractWithResource(user, resource);

        ResourceUserProgression progression = getOrCreateProgression(user, resource);
        progression.setSetAside(!progression.isSetAside());
        progressionRepository.save(progression);
        return new MessageDTO("Mise de côté mise à jour.");
    }

    public List<ResourceUserProgressionDTO> getFavoriteResources(Authentication auth) {
        User user = securityUtils.getCurrentUser(auth);
        return progressionRepository.findAllByUserAndFavoriteTrue(user).stream()
                .filter(p -> p.getResource().isActive())
                .map(p -> new ResourceUserProgressionDTO(
                        p.getResource(),
                        p.isFavorite(),
                        p.isExploited(),
                        p.isSetAside()
                ))
                .collect(Collectors.toList());
    }

    public List<ResourceUserProgressionDTO> getExploitedResources(Authentication auth) {
        User user = securityUtils.getCurrentUser(auth);
        return progressionRepository.findAllByUserAndExploitedTrue(user).stream()
                .filter(p -> p.getResource().isActive())
                .map(p -> new ResourceUserProgressionDTO(
                        p.getResource(),
                        p.isFavorite(),
                        p.isExploited(),
                        p.isSetAside()
                ))
                .collect(Collectors.toList());
    }

    public List<ResourceUserProgressionDTO> getSetAsideResources(Authentication auth) {
        User user = securityUtils.getCurrentUser(auth);
        return progressionRepository.findAllByUserAndSetAsideTrue(user).stream()
                .filter(p -> p.getResource().isActive())
                .map(p -> new ResourceUserProgressionDTO(
                        p.getResource(),
                        p.isFavorite(),
                        p.isExploited(),
                        p.isSetAside()
                ))
                .collect(Collectors.toList());
    }

    private void validateUserCanInteractWithResource(User user, Resource resource) {
        boolean isAcceptedAndPublic = resource.getStatus() == ResourceStatusEnum.ACCEPTED &&
                resource.getVisibility() == ResourceVisibilityEnum.PUBLIC;

        boolean isCreator = resource.getCreator().equals(user);

        if (!isAcceptedAndPublic && !isCreator) {
            throw new NotFoundException("Vous n'avez pas l'autorisation d'interagir avec cette ressource.");
        }
    }

}
