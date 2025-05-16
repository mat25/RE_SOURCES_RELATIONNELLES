package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.category.CategoryDTO;
import com.ReSourcesRelationnelles.prod.dto.category.CreateCategoryDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.CreateResourceDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.ResourceDTO;
import com.ReSourcesRelationnelles.prod.entity.*;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    public List<CategoryDTO> getAllCategory() {
        return categoryRepository.findAll().stream()
                .map(CategoryDTO::new)
                .toList();
    }

    public CategoryDTO createCategory(CreateCategoryDTO request) {

        Category category = new Category();
        category.setName(request.getName());

        Category savedCategory = categoryRepository.save(category);

        return new CategoryDTO(savedCategory);
    }
}
