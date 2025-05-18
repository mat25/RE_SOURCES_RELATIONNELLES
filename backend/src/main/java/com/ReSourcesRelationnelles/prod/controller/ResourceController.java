package com.ReSourcesRelationnelles.prod.controller;

import com.ReSourcesRelationnelles.prod.dto.MessageDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.CreateResourceDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.ResourceDTO;
import com.ReSourcesRelationnelles.prod.service.ResourceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class ResourceController {

    @Autowired
    private ResourceService resourceService;

    @Operation(summary = "Récupérer toutes les ressources", description = "Retourne la liste de toutes les ressources accessibles par l'utilisateur connecté ou non connecté.")
    @ApiResponse(responseCode = "200", description = "Liste des ressources récupérée (List<ResourceDTO>)")
    @GetMapping("/resources")
    public ResponseEntity<List<ResourceDTO>> getAllResources(Authentication authentication) {
        List<ResourceDTO> resources = resourceService.getAllResources(authentication);
        return ResponseEntity.ok(resources);
    }

    @Operation(summary = "Créer une ressource", description = "Permet de créer une nouvelle ressource. Retourne la ressource créée (ResourceDTO).")
    @ApiResponse(responseCode = "200", description = "Ressource créée avec succès (ResourceDTO)")
    @PostMapping("/resources")
    public ResponseEntity<ResourceDTO> createResource(@RequestBody CreateResourceDTO request, Authentication authentication) {
        ResourceDTO resourceDTO = resourceService.createResource(request, authentication);
        return ResponseEntity.ok(resourceDTO);
    }

    @Operation(summary = "Mettre à jour une ressource", description = "Modifie une ressource existante. Retourne la ressource mise à jour (ResourceDTO).")
    @ApiResponse(responseCode = "200", description = "Ressource mise à jour avec succès (ResourceDTO)")
    @PatchMapping("/resources/{id}")
    public ResponseEntity<ResourceDTO> updateResource(@PathVariable Long id,@RequestBody CreateResourceDTO request, Authentication authentication) {
        ResourceDTO resourceDTO = resourceService.updateResource(id,request, authentication);
        return ResponseEntity.ok(resourceDTO);
    }

    @Operation(summary = "Supprimer une ressource", description = "Permet de supprimer une ressource existante. Réservé aux administrateurs ou à l'utilisateur qui la crée.")
    @ApiResponse(responseCode = "200", description = "Ressource supprimée (MessageDTO)")
    @DeleteMapping("/resources/{id}")
    public ResponseEntity<MessageDTO> deleteResource(@PathVariable Long id, Authentication authentication) {
        MessageDTO message = resourceService.deleteResource(id, authentication);
        return ResponseEntity.ok(message);
    }
}
