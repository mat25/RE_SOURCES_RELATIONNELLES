package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.category.CategoryDTO;
import com.ReSourcesRelationnelles.prod.dto.category.CreateCategoryDTO;
import com.ReSourcesRelationnelles.prod.entity.Category;
import com.ReSourcesRelationnelles.prod.entity.User;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.CategoryRepository;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;
import com.ReSourcesRelationnelles.prod.security.SecurityUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.security.core.Authentication;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

class CategoryServiceTest {

    @InjectMocks
    private CategoryService categoryService;

    @Mock
    private CategoryRepository categoryRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private SecurityUtils securityUtils;

    @Mock
    private Authentication authentication;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    void getAllCategory_shouldReturnActiveCategories() {
        Category cat1 = new Category();
        cat1.setId(1L);
        cat1.setName("Cat 1");
        cat1.setActive(true);

        Category cat2 = new Category();
        cat2.setId(2L);
        cat2.setName("Cat 2");
        cat2.setActive(true);

        when(categoryRepository.findByActiveTrue()).thenReturn(Arrays.asList(cat1, cat2));

        List<CategoryDTO> result = categoryService.getAllCategory();

        assertEquals(2, result.size());
        assertEquals("Cat 1", result.get(0).getName());
        assertEquals("Cat 2", result.get(1).getName());
    }

    @Test
    void createCategory_shouldSaveAndReturnDTO() {
        User user = new User();
        user.setUsername("admin");

        CreateCategoryDTO dto = new CreateCategoryDTO();
        dto.setName("New Category");

        Category saved = new Category();
        saved.setId(10L);
        saved.setName("New Category");
        saved.setActive(true);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(categoryRepository.save(any(Category.class))).thenReturn(saved);

        CategoryDTO result = categoryService.createCategory(dto, authentication);

        assertEquals(saved.getId(), result.getId());
        assertEquals("New Category", result.getName());
        assertTrue(result.getActive());
    }

    @Test
    void updateCategory_shouldThrowIfNotFound() {
        when(categoryRepository.findById(1L)).thenReturn(Optional.empty());

        NotFoundException ex = assertThrows(NotFoundException.class, () ->
                categoryService.updateCategory(1L, new CreateCategoryDTO(), authentication));

        assertEquals("Catégorie non trouvée.", ex.getMessage());
    }

    @Test
    void updateCategory_shouldThrowIfInactive() {
        Category category = new Category();
        category.setActive(false);

        when(categoryRepository.findById(1L)).thenReturn(Optional.of(category));

        assertThrows(BadRequestException.class, () ->
                categoryService.updateCategory(1L, new CreateCategoryDTO(), authentication));
    }

    @Test
    void updateCategory_shouldThrowIfNameIsBlank() {
        Category category = new Category();
        category.setActive(true);

        CreateCategoryDTO dto = new CreateCategoryDTO();
        dto.setName("   ");

        when(categoryRepository.findById(1L)).thenReturn(Optional.of(category));

        assertThrows(BadRequestException.class, () ->
                categoryService.updateCategory(1L, dto, authentication));
    }

    @Test
    void updateCategory_shouldUpdateAndReturnDTO() {
        Category category = new Category();
        category.setId(1L);
        category.setName("Old Name");
        category.setActive(true);

        CreateCategoryDTO dto = new CreateCategoryDTO();
        dto.setName("Updated Name");

        User user = new User();
        user.setUsername("admin");

        when(categoryRepository.findById(1L)).thenReturn(Optional.of(category));
        when(categoryRepository.save(any(Category.class))).thenReturn(category);
        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);

        CategoryDTO result = categoryService.updateCategory(1L, dto, authentication);

        assertEquals("Updated Name", result.getName());
    }

    @Test
    void deleteCategory_shouldThrowIfNotFound() {
        when(categoryRepository.findById(1L)).thenReturn(Optional.empty());

        assertThrows(NotFoundException.class, () ->
                categoryService.deleteCategory(1L, authentication));
    }

    @Test
    void deleteCategory_shouldDeactivateCategoryAndReturnDTO() {
        Category category = new Category();
        category.setId(1L);
        category.setName("To delete");
        category.setActive(true);

        User user = new User();
        user.setUsername("admin");

        when(categoryRepository.findById(1L)).thenReturn(Optional.of(category));
        when(categoryRepository.save(any(Category.class))).thenReturn(category);
        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);

        CategoryDTO result = categoryService.deleteCategory(1L, authentication);

        assertFalse(category.isActive());
        assertEquals("To delete", result.getName());
    }
}
