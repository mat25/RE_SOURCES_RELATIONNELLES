package com.ReSourcesRelationnelles.prod.dto.ressource;

import com.ReSourcesRelationnelles.prod.entity.Ressource;

import java.time.LocalDateTime;

public class RessourceDTO {
    private Long id;
    private String titre;
    private String contenu;
    private String lienVideo;
    private LocalDateTime dateCreation;
    private String visibilite;
    private String statut;
    private String type;
    private String categorie;
    private Long createurId;

    public RessourceDTO(Ressource ressource) {
        this.id = ressource.getIdRessource();
        this.titre = ressource.getTitre();
        this.contenu = ressource.getContenu();
        this.lienVideo = ressource.getLienVideo();
        this.dateCreation = ressource.getDateCreation();
        this.visibilite = ressource.getVisibilite().name();
        this.statut = ressource.getStatut().name();
        this.type = ressource.getType();
        this.categorie = ressource.getCategorie().getLibCategorie();
        this.createurId = ressource.getCreateur().getId();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

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

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    public String getVisibilite() {
        return visibilite;
    }

    public void setVisibilite(String visibilite) {
        this.visibilite = visibilite;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public Long getCreateurId() {
        return createurId;
    }

    public void setCreateurId(Long createurId) {
        this.createurId = createurId;
    }
}
