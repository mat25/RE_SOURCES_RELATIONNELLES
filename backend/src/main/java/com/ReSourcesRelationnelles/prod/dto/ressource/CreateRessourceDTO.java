package com.ReSourcesRelationnelles.prod.dto.ressource;

public class CreateRessourceDTO {
    private String titre;
    private String contenu;
    private String lienVideo;
    private String visibilite;
    private String type;
    private Long categorieId;


    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getContenu() {
        return contenu;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
    }

    public String getLienVideo() {
        return lienVideo;
    }

    public void setLienVideo(String lienVideo) {
        this.lienVideo = lienVideo;
    }

    public String getVisibilite() {
        return visibilite;
    }

    public void setVisibilite(String visibilite) {
        this.visibilite = visibilite;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Long getCategorieId() {
        return categorieId;
    }

    public void setCategorieId(Long categorieId) {
        this.categorieId = categorieId;
    }
}

