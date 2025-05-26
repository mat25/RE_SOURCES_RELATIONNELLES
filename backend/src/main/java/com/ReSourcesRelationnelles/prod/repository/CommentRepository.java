package com.ReSourcesRelationnelles.prod.repository;

import com.ReSourcesRelationnelles.prod.entity.Comment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByResourceIdAndParentCommentIsNull(Long resourceId);
    List<Comment> findByResourceIdAndParentCommentIsNullAndVisibleTrue(Long resourceId);
}
