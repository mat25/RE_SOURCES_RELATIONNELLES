package com.ReSourcesRelationnelles.prod.dto.resource;

import com.ReSourcesRelationnelles.prod.entity.Resource;
import com.ReSourcesRelationnelles.prod.entity.ResourceUserProgression;

import java.time.LocalDateTime;

public class ResourceDTO {
    private Long id;
    private String title;
    private String content;
    private String videoLink;
    private LocalDateTime creationDate;
    private String visibility;
    private String status;
    private String type;
    private Boolean active;
    private String category;
    private Long creatorId;

    // Nouveaux champs pour les utilisateurs connectés
    private Boolean isFavorite;
    private Boolean isSetAside;
    private Boolean isExploited;

    public ResourceDTO(Resource resource) {
        this.id = resource.getId();
        this.title = resource.getTitle();
        this.content = resource.getContent();
        this.videoLink = resource.getVideoLink();
        this.creationDate = resource.getCreationDate();
        this.visibility = resource.getVisibility().name();
        this.status = resource.getStatus().name();
        this.type = resource.getType().name();
        this.active = resource.isActive();
        this.category = resource.getCategory().getName();
        this.creatorId = resource.getCreator().getId();
    }

    public ResourceDTO(Resource resource, ResourceUserProgression progression) {
        // Appel au constructeur que avec resource
        this(resource);
        if (progression != null) {
            this.isFavorite = progression.isFavorite();
            this.isSetAside = progression.isSetAside();
            this.isExploited = progression.isExploited();
        }
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getVideoLink() { return videoLink; }
    public void setVideoLink(String videoLink) { this.videoLink = videoLink; }

    public LocalDateTime getCreationDate() { return creationDate; }
    public void setCreationDate(LocalDateTime creationDate) { this.creationDate = creationDate; }

    public String getVisibility() { return visibility; }
    public void setVisibility(String visibility) { this.visibility = visibility; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public Boolean getActive() { return active; }
    public void setActive(Boolean active) { this.active = active; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Long getCreatorId() { return creatorId; }
    public void setCreatorId(Long creatorId) { this.creatorId = creatorId; }

    public Boolean getIsFavorite() { return isFavorite; }
    public void setIsFavorite(Boolean isFavorite) { this.isFavorite = isFavorite; }

    public Boolean getIsSetAside() { return isSetAside; }
    public void setIsSetAside(Boolean isSetAside) { this.isSetAside = isSetAside; }

    public Boolean getIsExploited() { return isExploited; }
    public void setIsExploited(Boolean isExploited) { this.isExploited = isExploited; }
}