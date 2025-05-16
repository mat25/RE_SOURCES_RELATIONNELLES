package com.ReSourcesRelationnelles.prod.controller;

import com.ReSourcesRelationnelles.prod.dto.ressource.RessourceDTO;
import com.ReSourcesRelationnelles.prod.dto.user.UserDTO;
import com.ReSourcesRelationnelles.prod.service.RessourceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class RessourceController {

    @Autowired
    private RessourceService ressourceService;

    @GetMapping("/ressources")
    public ResponseEntity<List<RessourceDTO>> getAllRessources(Authentication authentication) {
        List<RessourceDTO> ressources = ressourceService.getAllRessources(authentication);
        return ResponseEntity.ok(ressources);
    }
}
