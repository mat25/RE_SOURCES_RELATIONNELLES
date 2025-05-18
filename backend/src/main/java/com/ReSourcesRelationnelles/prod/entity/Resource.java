package com.ReSourcesRelationnelles.prod.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Resource {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;
    private String videoLink;
    private LocalDateTime creationDate;

    @Enumerated(EnumType.STRING)
    private ResourceVisibilityEnum visibility;

    @Enumerated(EnumType.STRING)
    private ResourceStatusEnum status;

    @Enumerated(EnumType.STRING)
    private ResourceTypeEnum type;

    @Column(nullable = false)
    private boolean active = true;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User creator;

    @OneToMany(mappedBy = "resource", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ResourceUserProgression> progressions = new ArrayList<>();

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getVideoLink() {
        return videoLink;
    }

    public void setVideoLink(String videoLink) {
        this.videoLink = videoLink;
    }

    public LocalDateTime getCreationDate() {
        return creationDate;
    }

    public void setCreationDate(LocalDateTime creationDate) {
        this.creationDate = creationDate;
    }

    public ResourceVisibilityEnum getVisibility() {
        return visibility;
    }

    public void setVisibility(ResourceVisibilityEnum visibility) {
        this.visibility = visibility;
    }

    public ResourceStatusEnum getStatus() {
        return status;
    }

    public void setStatus(ResourceStatusEnum status) {
        this.status = status;
    }

    public ResourceTypeEnum getType() {
        return type;
    }

    public void setType(ResourceTypeEnum type) {
        this.type = type;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public User getCreator() {
        return creator;
    }

    public void setCreator(User creator) {
        this.creator = creator;
    }

    public List<ResourceUserProgression> getProgressions() {
        return progressions;
    }

    public void setProgressions(List<ResourceUserProgression> progressions) {
        this.progressions = progressions;
    }
}
