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
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.Authentication;

import java.time.LocalDateTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ResourceServiceTest {

    @InjectMocks
    private ResourceService resourceService;

    @Mock
    private ResourceRepository resourceRepository;
    @Mock
    private UserRepository userRepository;
    @Mock
    private CategoryRepository categoryRepository;
    @Mock
    private SecurityUtils securityUtils;

    @Mock
    private Authentication authentication;

    private final User user = new User();
    private final Category category = new Category();
    private final Resource resource = new Resource();

    @BeforeEach
    void setUp() {
        user.setId(1L);
        user.setUsername("user1");
        Role role = new Role();
        role.setName(RoleEnum.USER);
        user.setRole(role);

        category.setId(1L);
        category.setName("Santé");

        resource.setId(1L);
        resource.setTitle("Titre");
        resource.setContent("Contenu");
        resource.setVideoLink("https://link");
        resource.setStatus(ResourceStatusEnum.ACCEPTED);
        resource.setVisibility(ResourceVisibilityEnum.PUBLIC);
        resource.setType(ResourceTypeEnum.VIDEO);
        resource.setCreator(user);
        resource.setCategory(category);
        resource.setActive(true);
        resource.setCreationDate(LocalDateTime.now());
        resource.setProgressions(new ArrayList<>());
    }

    private CreateResourceDTO createValidDTO() {
        return new CreateResourceDTO("Titre", "Contenu", "https://video", "PUBLIC", "ACCEPTED", "Article", 1L);
    }

    // ---------------------- getAllResources ----------------------

    @Test
    void getAllResources_shouldReturnAccessibleResources() {
        when(resourceRepository.findAll()).thenReturn(List.of(resource));
        when(authentication.getName()).thenReturn("user1");
        when(userRepository.findByUsernameAndDeletedFalse("user1")).thenReturn(user);

        List<ResourceDTO> result = resourceService.getAllResources(authentication);

        assertEquals(1, result.size());
        assertEquals(resource.getTitle(), result.get(0).getTitle());
    }

    // ---------------------- getResourceById ----------------------

    @Test
    void getResourceById_shouldReturnIfPublicAndAccepted() {
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));
        when(authentication.getName()).thenReturn("user1");
        when(userRepository.findByUsernameAndDeletedFalse("user1")).thenReturn(user);

        ResourceDTO result = resourceService.getResourceById(1L, authentication);

        assertEquals(resource.getId(), result.getId());
    }

    @Test
    void getResourceById_shouldThrowIfUserNotAuthorizedToAccessPrivateOrPendingResource() {
        resource.setVisibility(ResourceVisibilityEnum.PRIVATE);
        resource.setStatus(ResourceStatusEnum.PENDING);
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));
        when(authentication.getName()).thenReturn("another");
        when(userRepository.findByUsernameAndDeletedFalse("another")).thenReturn(new User());

        assertThrows(BadRequestException.class, () -> resourceService.getResourceById(1L, authentication));
    }

    @Test
    void getResourceById_shouldThrowIfNotFound() {
        when(resourceRepository.findById(1L)).thenReturn(Optional.empty());
        assertThrows(NotFoundException.class, () -> resourceService.getResourceById(1L, authentication));
    }

    @Test
    void getResourceById_shouldThrowIfDeleted() {
        resource.setActive(false);
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));
        assertThrows(NotFoundException.class, () -> resourceService.getResourceById(1L, authentication));
    }

    // ---------------------- createResource ----------------------

    @Test
    void createResource_shouldCreateResource() {
        CreateResourceDTO request = createValidDTO();
        when(authentication.getName()).thenReturn("user1");
        when(userRepository.findByUsernameAndDeletedFalse("user1")).thenReturn(user);
        when(categoryRepository.findById(1L)).thenReturn(Optional.of(category));
        when(resourceRepository.save(any())).thenAnswer(invocation -> {
            Resource r = invocation.getArgument(0);
            r.setId(1L);
            return r;
        });

        ResourceDTO result = resourceService.createResource(request, authentication);

        assertEquals("Titre", result.getTitle());
        assertNotNull(result.getId());
    }

    @Test
    void createResource_shouldThrowWhenAuthenticationIsNull() {
        assertThrows(BadRequestException.class, () -> resourceService.createResource(new CreateResourceDTO(), null));
    }

    @Test
    void createResource_shouldThrowIfUserNotFound() {
        when(authentication.getName()).thenReturn("user1");
        when(userRepository.findByUsernameAndDeletedFalse("user1")).thenReturn(null);

        assertThrows(NotFoundException.class, () -> resourceService.createResource(new CreateResourceDTO(), authentication));
    }

    @Test
    void createResource_shouldThrowIfCategoryNotFound() {
        CreateResourceDTO request = createValidDTO();
        when(authentication.getName()).thenReturn("user1");
        when(userRepository.findByUsernameAndDeletedFalse("user1")).thenReturn(user);
        when(categoryRepository.findById(1L)).thenReturn(Optional.empty());

        assertThrows(NotFoundException.class, () -> resourceService.createResource(request, authentication));
    }

    // ---------------------- deleteResource ----------------------

    @Test
    void deleteResource_shouldDeleteOwnResource() {
        resource.setCreator(user);
        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));

        MessageDTO result = resourceService.deleteResource(1L, authentication);

        assertEquals("Ressource supprimée avec succès.", result.getMessage());
        assertFalse(resource.isActive(), "La ressource doit être désactivée");
        verify(resourceRepository, times(1)).save(any());
    }

    @Test
    void deleteResource_shouldThrowIfResourceNotFound() {
        when(resourceRepository.findById(999L)).thenReturn(Optional.empty());
        assertThrows(NotFoundException.class, () -> resourceService.deleteResource(999L, authentication));
    }

    @Test
    void deleteResource_shouldThrowIfNotOwnerOrAdmin() {
        User otherUser = new User();
        otherUser.setId(2L);
        Role role = new Role();
        role.setName(RoleEnum.USER);
        otherUser.setRole(role);

        resource.setCreator(user);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(otherUser);
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));

        assertThrows(BadRequestException.class, () -> resourceService.deleteResource(1L, authentication));
    }

    // ---------------------- updateResource ----------------------

    @Test
    void updateResource_shouldUpdateAsOwner() {
        CreateResourceDTO request = new CreateResourceDTO("New title", "Contenu", null, "PRIVATE", "ACCEPTED", "Article", 1L);
        resource.setCreator(user);
        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));
        when(categoryRepository.findById(1L)).thenReturn(Optional.of(category));
        when(resourceRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

        ResourceDTO result = resourceService.updateResource(1L, request, authentication);

        assertEquals("New title", result.getTitle());
    }

    @Test
    void updateResource_shouldThrowIfNotAuthorized() {
        User stranger = new User();
        stranger.setId(999L);
        Role role = new Role();
        role.setName(RoleEnum.USER);
        stranger.setRole(role);

        resource.setCreator(user);
        when(securityUtils.getCurrentUser(authentication)).thenReturn(stranger);
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));

        CreateResourceDTO request = new CreateResourceDTO("New", null, null, null, null, null, null);
        assertThrows(BadRequestException.class, () -> resourceService.updateResource(1L, request, authentication));
    }

    @Test
    void updateResource_shouldThrowIfDeleted() {
        resource.setActive(false);
        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));

        assertThrows(BadRequestException.class, () -> resourceService.updateResource(1L, new CreateResourceDTO(), authentication));
    }

    @Test
    void updateResource_shouldThrowIfResourceNotFound() {
        when(resourceRepository.findById(999L)).thenReturn(Optional.empty());
        assertThrows(NotFoundException.class, () -> resourceService.updateResource(999L, new CreateResourceDTO(), authentication));
    }
}
