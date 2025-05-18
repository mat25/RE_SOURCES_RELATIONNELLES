package com.ReSourcesRelationnelles.prod.entity;

import jakarta.persistence.*;

@Entity
public class ResourceUserProgression {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(optional = false)
    @JoinColumn(name = "resource_id")
    private Resource resource;

    private boolean favorite = false;
    private boolean exploited = false;
    private boolean setAside = false;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Resource getResource() {
        return resource;
    }

    public void setResource(Resource resource) {
        this.resource = resource;
    }

    public boolean isFavorite() {
        return favorite;
    }

    public void setFavorite(boolean favorite) {
        this.favorite = favorite;
    }

    public boolean isExploited() {
        return exploited;
    }

    public void setExploited(boolean exploited) {
        this.exploited = exploited;
    }

    public boolean isSetAside() {
        return setAside;
    }

    public void setSetAside(boolean setAside) {
        this.setAside = setAside;
    }
}
