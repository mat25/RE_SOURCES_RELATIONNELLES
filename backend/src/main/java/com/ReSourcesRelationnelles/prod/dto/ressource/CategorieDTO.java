package com.ReSourcesRelationnelles.prod.dto.ressource;

import com.ReSourcesRelationnelles.prod.entity.Categorie;

public class CategorieDTO {
    private Long id;
    private String libCategorie;

    public CategorieDTO(Categorie categorie) {
        this.id = categorie.getIdCategorie();
        this.libCategorie = categorie.getLibCategorie();
    }
}
