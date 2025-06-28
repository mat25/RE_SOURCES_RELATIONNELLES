package com.ReSourcesRelationnelles.prod.dto.resource;

public class CreateResourceDTO {
    private String title;
    private String content;
    private String videoLink;
    private String visibility;
    private String status;
    private String type;
    private Long categoryId;

    public CreateResourceDTO() {}

    public CreateResourceDTO(String title, String content, String videoLink, String visibility, String status, String type, Long categoryId) {
        this.title = title;
        this.content = content;
        this.videoLink = videoLink;
        this.visibility = visibility;
        this.status = status;
        this.type = type;
        this.categoryId = categoryId;
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

    public String getVisibility() {
        return visibility;
    }

    public void setVisibility(String visibility) {
        this.visibility = visibility;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }
}

