package com.ReSourcesRelationnelles.prod.controller;

import com.ReSourcesRelationnelles.prod.dto.MessageDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.ResourceUserProgressionDTO;
import com.ReSourcesRelationnelles.prod.service.ResourceUserProgressionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/resources")
public class ResourceUserProgressionController {

    @Autowired
    private ResourceUserProgressionService progressionService;

    @Operation(summary = "Récupérer les ressources favorites", description = "Retourne la liste des ressources marquées comme favorites par l'utilisateur connecté.")
    @ApiResponse(responseCode = "200", description = "Liste des ressources favorites récupérée (List<ResourceUserProgressionDTO>)")
    @GetMapping("/favorites")
    public List<ResourceUserProgressionDTO> getFavorites(Authentication authentication) {
        return progressionService.getFavoriteResources(authentication);
    }

    @Operation(summary = "Récupérer les ressources exploitées", description = "Retourne la liste des ressources exploitées par l'utilisateur connecté.")
    @ApiResponse(responseCode = "200", description = "Liste des ressources exploitées récupérée (List<ResourceUserProgressionDTO>)")
    @GetMapping("/exploited")
    public List<ResourceUserProgressionDTO> getExploited(Authentication authentication) {
        return progressionService.getExploitedResources(authentication);
    }

    @Operation(summary = "Récupérer les ressources mises de côté", description = "Retourne la liste des ressources mises de côté par l'utilisateur connecté.")
    @ApiResponse(responseCode = "200", description = "Liste des ressources mises de côté récupérée (List<ResourceUserProgressionDTO>)")
    @GetMapping("/set-aside")
    public List<ResourceUserProgressionDTO> getSetAside(Authentication authentication) {
        return progressionService.getSetAsideResources(authentication);
    }

    @Operation(summary = "Basculer le statut favori d'une ressource", description = "Permet de marquer une ressource comme favorite pour l'utilisateur connecté.")
    @ApiResponse(responseCode = "200", description = "Statut favori basculé (MessageDTO)")
    @PostMapping("/{id}/toggle-favorite")
    public MessageDTO toggleFavorite(@PathVariable Long id, Authentication authentication) {
        return progressionService.toggleFavorite(id, authentication);
    }

    @Operation(summary = "Basculer le statut exploité d'une ressource", description = "Permet de marquer une ressource comme exploitée pour l'utilisateur connecté.")
    @ApiResponse(responseCode = "200", description = "Statut exploité basculé (MessageDTO)")
    @PostMapping("/{id}/toggle-exploited")
    public MessageDTO toggleExploited(@PathVariable Long id, Authentication authentication) {
        return progressionService.toggleExploited(id, authentication);
    }

    @Operation(summary = "Basculer le statut mise de côté d'une ressource", description = "Permet de marquer une ressource comme mise de côté pour l'utilisateur connecté.")
    @ApiResponse(responseCode = "200", description = "Statut mise de côté basculé (MessageDTO)")
    @PostMapping("/{id}/toggle-set-aside")
    public MessageDTO toggleSetAside(@PathVariable Long id, Authentication authentication) {
        return progressionService.toggleSetAside(id, authentication);
    }
}
