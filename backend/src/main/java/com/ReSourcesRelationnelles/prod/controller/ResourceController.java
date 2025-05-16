package com.ReSourcesRelationnelles.prod.controller;

import com.ReSourcesRelationnelles.prod.dto.ressource.CreateResourceDTO;
import com.ReSourcesRelationnelles.prod.dto.ressource.ResourceDTO;
import com.ReSourcesRelationnelles.prod.service.ResourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class ResourceController {

    @Autowired
    private ResourceService resourceService;

    @GetMapping("/resources")
    public ResponseEntity<List<ResourceDTO>> getAllResources(Authentication authentication) {
        List<ResourceDTO> resources = resourceService.getAllResources(authentication);
        return ResponseEntity.ok(resources);
    }

    @PostMapping("/resources")
    public ResponseEntity<ResourceDTO> createResource(@RequestBody CreateResourceDTO request, Authentication authentication) {
        ResourceDTO resource = resourceService.createResource(request, authentication);
        return ResponseEntity.ok(resource);
    }
}
