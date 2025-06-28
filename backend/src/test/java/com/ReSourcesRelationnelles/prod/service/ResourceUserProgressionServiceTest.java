package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.MessageDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.ResourceUserProgressionDTO;
import com.ReSourcesRelationnelles.prod.entity.*;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.ResourceRepository;
import com.ReSourcesRelationnelles.prod.repository.ResourceUserProgressionRepository;
import com.ReSourcesRelationnelles.prod.security.SecurityUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.security.core.Authentication;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

class ResourceUserProgressionServiceTest {

    @InjectMocks
    private ResourceUserProgressionService service;

    @Mock
    private ResourceUserProgressionRepository progressionRepository;

    @Mock
    private ResourceRepository resourceRepository;

    @Mock
    private SecurityUtils securityUtils;

    @Mock
    private Authentication authentication;

    private User user;
    private Resource resource;

    @BeforeEach
    void setup() {
        MockitoAnnotations.openMocks(this);

        user = new User();
        user.setId(1L);
        user.setUsername("testuser");

        resource = new Resource();
        resource.setId(10L);
        resource.setTitle("Titre ressource");
        resource.setContent("Contenu");
        resource.setVideoLink("http://video.link");
        resource.setCreationDate(LocalDateTime.now());
        resource.setVisibility(ResourceVisibilityEnum.PUBLIC);
        resource.setStatus(ResourceStatusEnum.ACCEPTED);
        resource.setType(ResourceTypeEnum.VIDEO);
        resource.setActive(true);
        resource.setCategory(new Category(1L,"Catégorie"));
        resource.setCreator(user);
    }

    @Test
    void toggleFavorite_shouldToggleFavoriteAndSave() {
        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(resourceRepository.findById(resource.getId())).thenReturn(Optional.of(resource));

        ResourceUserProgression existingProgression = new ResourceUserProgression();
        existingProgression.setUser(user);
        existingProgression.setResource(resource);
        existingProgression.setFavorite(false);

        when(progressionRepository.findByUserAndResource(user, resource)).thenReturn(Optional.of(existingProgression));
        when(progressionRepository.save(any(ResourceUserProgression.class))).thenAnswer(invocation -> invocation.getArgument(0));

        MessageDTO result = service.toggleFavorite(resource.getId(), authentication);

        assertThat(result.getMessage()).isEqualTo("Favori mis à jour.");
        assertThat(existingProgression.isFavorite()).isTrue();

        verify(progressionRepository).save(existingProgression);
    }

    @Test
    void toggleFavorite_shouldCreateProgressionIfNotExists() {
        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(resourceRepository.findById(resource.getId())).thenReturn(Optional.of(resource));
        when(progressionRepository.findByUserAndResource(user, resource)).thenReturn(Optional.empty());
        when(progressionRepository.save(any(ResourceUserProgression.class))).thenAnswer(invocation -> invocation.getArgument(0));

        MessageDTO result = service.toggleFavorite(resource.getId(), authentication);

        assertThat(result.getMessage()).isEqualTo("Favori mis à jour.");

        ArgumentCaptor<ResourceUserProgression> captor = ArgumentCaptor.forClass(ResourceUserProgression.class);
        verify(progressionRepository).save(captor.capture());

        ResourceUserProgression saved = captor.getValue();
        assertThat(saved.getUser()).isEqualTo(user);
        assertThat(saved.getResource()).isEqualTo(resource);
        assertThat(saved.isFavorite()).isTrue();
    }

    @Test
    void toggleFavorite_shouldThrowNotFoundExceptionIfResourceNotFound() {
        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(resourceRepository.findById(resource.getId())).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.toggleFavorite(resource.getId(), authentication))
                .isInstanceOf(NotFoundException.class)
                .hasMessage("Ressource introuvable.");
    }

    @Test
    void toggleFavorite_shouldThrowNotFoundExceptionIfResourceInactive() {
        resource.setActive(false);
        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(resourceRepository.findById(resource.getId())).thenReturn(Optional.of(resource));

        assertThatThrownBy(() -> service.toggleFavorite(resource.getId(), authentication))
                .isInstanceOf(NotFoundException.class)
                .hasMessage("La ressource est inactive.");
    }

    @Test
    void toggleFavorite_shouldThrowNotFoundExceptionIfUserNotAuthorized() {
        resource.setStatus(ResourceStatusEnum.PENDING);
        resource.setVisibility(ResourceVisibilityEnum.PRIVATE);
        User otherUser = new User();
        otherUser.setId(2L);
        resource.setCreator(otherUser);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(resourceRepository.findById(resource.getId())).thenReturn(Optional.of(resource));

        assertThatThrownBy(() -> service.toggleFavorite(resource.getId(), authentication))
                .isInstanceOf(NotFoundException.class)
                .hasMessage("Vous n'avez pas l'autorisation d'interagir avec cette ressource.");
    }

    // Même principe pour toggleExploited et toggleSetAside

    @Test
    void getFavoriteResources_shouldReturnOnlyActiveFavorites() {
        ResourceUserProgression p1 = new ResourceUserProgression();
        p1.setResource(resource);
        p1.setFavorite(true);
        p1.setExploited(false);
        p1.setSetAside(false);

        ResourceUserProgression p2 = new ResourceUserProgression();
        Resource inactiveResource = new Resource();
        inactiveResource.setActive(false);
        p2.setResource(inactiveResource);
        p2.setFavorite(true);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(progressionRepository.findAllByUserAndFavoriteTrue(user)).thenReturn(List.of(p1, p2));

        List<ResourceUserProgressionDTO> result = service.getFavoriteResources(authentication);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(resource.getId());
        assertThat(result.get(0).isFavorite()).isTrue();
    }

    @Test
    void getExploitedResources_shouldReturnOnlyActiveExploited() {
        ResourceUserProgression p1 = new ResourceUserProgression();
        p1.setResource(resource);
        p1.setFavorite(false);
        p1.setExploited(true);
        p1.setSetAside(false);

        ResourceUserProgression p2 = new ResourceUserProgression();
        Resource inactiveResource = new Resource();
        inactiveResource.setActive(false);
        p2.setResource(inactiveResource);
        p2.setExploited(true);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(progressionRepository.findAllByUserAndExploitedTrue(user)).thenReturn(List.of(p1, p2));

        List<ResourceUserProgressionDTO> result = service.getExploitedResources(authentication);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(resource.getId());
        assertThat(result.get(0).isExploited()).isTrue();
    }

    @Test
    void getSetAsideResources_shouldReturnOnlyActiveSetAside() {
        ResourceUserProgression p1 = new ResourceUserProgression();
        p1.setResource(resource);
        p1.setFavorite(false);
        p1.setExploited(false);
        p1.setSetAside(true);

        ResourceUserProgression p2 = new ResourceUserProgression();
        Resource inactiveResource = new Resource();
        inactiveResource.setActive(false);
        p2.setResource(inactiveResource);
        p2.setSetAside(true);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(progressionRepository.findAllByUserAndSetAsideTrue(user)).thenReturn(List.of(p1, p2));

        List<ResourceUserProgressionDTO> result = service.getSetAsideResources(authentication);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(resource.getId());
        assertThat(result.get(0).isSetAside()).isTrue();
    }
}
