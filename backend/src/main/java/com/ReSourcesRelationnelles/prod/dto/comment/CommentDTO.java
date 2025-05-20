package com.ReSourcesRelationnelles.prod.dto.comment;

import com.ReSourcesRelationnelles.prod.entity.Comment;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public class CommentDTO {
    private Long id;
    private String content;
    private String authorUsername;
    private LocalDateTime createdAt;
    private Long parentId;
    private List<CommentDTO> replies;

    public CommentDTO(Comment comment) {
        this.id = comment.getId();
        this.content = comment.getContent();
        this.authorUsername = comment.getAuthor().getUsername();
        this.createdAt = comment.getCreatedAt();
        this.parentId = comment.getParentComment() != null ? comment.getParentComment().getId() : null;
        this.replies = comment.getReplies().stream()
                .map(CommentDTO::new)
                .collect(Collectors.toList());
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAuthorUsername() {
        return authorUsername;
    }

    public void setAuthorUsername(String authorUsername) {
        this.authorUsername = authorUsername;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public List<CommentDTO> getReplies() {
        return replies;
    }

    public void setReplies(List<CommentDTO> replies) {
        this.replies = replies;
    }
}
