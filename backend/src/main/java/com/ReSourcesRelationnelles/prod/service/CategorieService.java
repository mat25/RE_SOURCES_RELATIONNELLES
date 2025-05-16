package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.ressource.CategorieDTO;
import com.ReSourcesRelationnelles.prod.repository.CategorieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import java.util.List;

@Service
public class CategorieService {

    @Autowired
    private CategorieRepository categorieRepository;

    public List<CategorieDTO> getAllCategories() {
        return categorieRepository.findAll().stream()
                .map(CategorieDTO::new)
                .toList();
    }
}
