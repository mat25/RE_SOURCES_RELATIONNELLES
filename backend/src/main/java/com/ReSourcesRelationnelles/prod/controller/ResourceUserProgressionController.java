package com.ReSourcesRelationnelles.prod.controller;

import com.ReSourcesRelationnelles.prod.dto.MessageDTO;
import com.ReSourcesRelationnelles.prod.dto.resource.ResourceUserProgressionDTO;
import com.ReSourcesRelationnelles.prod.service.ResourceUserProgressionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/resources")
public class ResourceUserProgressionController {

    @Autowired
    private ResourceUserProgressionService progressionService;

    @GetMapping("/favorites")
    public List<ResourceUserProgressionDTO> getFavorites(Authentication authentication) {
        return progressionService.getFavoriteResources(authentication);
    }

    @GetMapping("/exploited")
    public List<ResourceUserProgressionDTO> getExploited(Authentication authentication) {
        return progressionService.getExploitedResources(authentication);
    }

    @GetMapping("/set-aside")
    public List<ResourceUserProgressionDTO> getSetAside(Authentication authentication) {
        return progressionService.getSetAsideResources(authentication);
    }

    @PostMapping("/{id}/toggle-favorite")
    public MessageDTO toggleFavorite(@PathVariable Long id, Authentication authentication) {
        return progressionService.toggleFavorite(id, authentication);
    }

    @PostMapping("/{id}/toggle-exploited")
    public MessageDTO toggleExploited(@PathVariable Long id, Authentication authentication) {
        return progressionService.toggleExploited(id, authentication);
    }

    @PostMapping("/{id}/toggle-set-aside")
    public MessageDTO toggleSetAside(@PathVariable Long id, Authentication authentication) {
        return progressionService.toggleSetAside(id, authentication);
    }
}
