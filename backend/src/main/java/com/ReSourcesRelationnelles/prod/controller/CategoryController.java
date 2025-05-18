package com.ReSourcesRelationnelles.prod.controller;

import com.ReSourcesRelationnelles.prod.dto.category.CategoryDTO;
import com.ReSourcesRelationnelles.prod.dto.category.CreateCategoryDTO;
import com.ReSourcesRelationnelles.prod.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class CategoryController {

    @Autowired
    private CategoryService categoryService;

    @Operation(summary = "Récupérer toutes les catégories", description = "Renvoie la liste de toutes les catégories disponibles.")
    @ApiResponse(responseCode = "200", description = "Liste des catégories (List<CategoryDTO>)")
    @GetMapping("/category")
    public ResponseEntity<List<CategoryDTO>> getAllCategories() {
        List<CategoryDTO> category = categoryService.getAllCategory();
        return ResponseEntity.ok(category);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Créer une nouvelle catégorie", description = "Permet de créer une nouvelle catégorie. Réservé aux administrateurs.")
    @ApiResponse(responseCode = "200", description = "Catégorie créée (CategoryDTO)")
    @PostMapping("/category")
    public ResponseEntity<CategoryDTO> createCategory(@RequestBody CreateCategoryDTO categoryDTO,Authentication authentication) {
        CategoryDTO category = categoryService.createCategory(categoryDTO,authentication);
        return ResponseEntity.ok(category);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Mettre à jour une catégorie", description = "Permet de modifier une catégorie existante. Réservé aux administrateurs.")
    @ApiResponse(responseCode = "200", description = "Catégorie mise à jour (CategoryDTO)")
    @PatchMapping("/category/{id}")
    public ResponseEntity<CategoryDTO> updateCategory(@PathVariable Long id,@RequestBody CreateCategoryDTO categoryDTO,Authentication authentication) {
        CategoryDTO category = categoryService.updateCategory(id,categoryDTO,authentication);
        return ResponseEntity.ok(category);
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'SUPER_ADMIN')")
    @Operation(summary = "Supprimer une catégorie", description = "Permet de supprimer une catégorie existante. Réservé aux administrateurs.")
    @ApiResponse(responseCode = "200", description = "Catégorie supprimée (CategoryDTO)")
    @DeleteMapping("/category/{id}")
    public ResponseEntity<CategoryDTO> deleteCategory(@PathVariable Long id,Authentication authentication) {
        CategoryDTO category = categoryService.deleteCategory(id,authentication);
        return ResponseEntity.ok(category);
    }
}
