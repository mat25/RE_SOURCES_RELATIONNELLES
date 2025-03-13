package com.ReSourcesRelationnelles.prod.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class testController {

    // Route pour la page d'accueil
    @GetMapping("/")
    public String home() {
        return "index";  // Nom du fichier index.html à afficher
    }

    // Route pour la nouvelle page personnalisée
    @GetMapping("/nouvelle-page")
    public String nouvellePage() {
        return "nouvelle-page";  // Nom du fichier nouvelle-page.html
    }
}