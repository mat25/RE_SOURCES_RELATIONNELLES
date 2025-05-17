package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.category.CategoryDTO;
import com.ReSourcesRelationnelles.prod.dto.category.CreateCategoryDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.CreateResourceDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.ResourceDTO;
import com.ReSourcesRelationnelles.prod.entity.*;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.CategoryRepository;
import com.ReSourcesRelationnelles.prod.repository.UserRepository;
import com.ReSourcesRelationnelles.prod.security.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class CategoryService {
    private static final Logger log = LoggerFactory.getLogger(UserService.class);
    @Autowired
    private CategoryRepository categoryRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private SecurityUtils securityUtils;

    public List<CategoryDTO> getAllCategory() {
        return categoryRepository.findByActiveTrue().stream()
                .map(CategoryDTO::new)
                .toList();
    }

    public CategoryDTO createCategory(CreateCategoryDTO request, Authentication authentication) {

        User currentUser = securityUtils.getCurrentUser(authentication);

        Category category = new Category();
        category.setName(request.getName());
        category.setActive(true);

        Category savedCategory = categoryRepository.save(category);

        log.info("Création de la catégorie ID {} par l'utilisateur {}", savedCategory.getId(), currentUser.getUsername());

        return new CategoryDTO(savedCategory);
    }

    public CategoryDTO updateCategory(Long id, CreateCategoryDTO request,Authentication authentication) {

        User currentUser = securityUtils.getCurrentUser(authentication);

        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Catégorie non trouvée."));

        if (!category.isActive()) {
            throw new BadRequestException("Impossible de modifier une catégorie supprimée.");
        }

        if (request.getName() == null || request.getName().isBlank()) {
            throw new BadRequestException("Le nom de la catégorie ne peut pas être vide.");
        }

        category.setName(request.getName());

        Category savedCategory = categoryRepository.save(category);

        log.info("Mise a jour de la catégorie ID {} par l'utilisateur {}", savedCategory.getId(), currentUser.getUsername());

        return new CategoryDTO(savedCategory);
    }

    public CategoryDTO deleteCategory(Long id, Authentication authentication) {

        User currentUser = securityUtils.getCurrentUser(authentication);

        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Catégorie non trouvée."));

        category.setActive(false);

        Category savedCategory = categoryRepository.save(category);

        log.warn("Suppression de la catégorie ID {} par l'utilisateur {}", savedCategory.getId(), currentUser.getUsername());

        return new CategoryDTO(savedCategory);
    }

}
