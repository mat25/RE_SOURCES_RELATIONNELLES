package com.ReSourcesRelationnelles.prod.dto.comment;

public class CreateCommentDTO {
    private String content;
    private Long parentId;

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }
}
