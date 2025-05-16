package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.ressource.RessourceDTO;
import com.ReSourcesRelationnelles.prod.repository.RessourceRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class RessourceService {

    @Autowired
    private RessourceRepository ressourceRepository;

    public List<RessourceDTO> getAllRessources() {
        return ressourceRepository.findAll().stream()
                .map(RessourceDTO::new)
                .toList();
    }
}