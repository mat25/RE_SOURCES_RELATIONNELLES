package com.ReSourcesRelationnelles.prod.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class Ressource {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idRessource;

    private String titre;
    private String contenu;
    private String lienVideo;
    private LocalDateTime dateCreation;

    @Enumerated(EnumType.STRING)
    private VisibiliteEnum visibilite;

    @Enumerated(EnumType.STRING)
    private StatutEnum statut;

    private String type;

    @ManyToOne
    @JoinColumn(name = "categorie_id")
    private Categorie categorie;

    @ManyToOne
    @JoinColumn(name = "utilisateur_id")
    private User createur;

    public Long getIdRessource() {
        return idRessource;
    }

    public void setIdRessource(Long idRessource) {
        this.idRessource = idRessource;
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

    public VisibiliteEnum getVisibilite() {
        return visibilite;
    }

    public void setVisibilite(VisibiliteEnum visibilite) {
        this.visibilite = visibilite;
    }

    public StatutEnum getStatut() {
        return statut;
    }

    public void setStatut(StatutEnum statut) {
        this.statut = statut;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Categorie getCategorie() {
        return categorie;
    }

    public void setCategorie(Categorie categorie) {
        this.categorie = categorie;
    }

    public User getCreateur() {
        return createur;
    }

    public void setCreateur(User createur) {
        this.createur = createur;
    }
}
