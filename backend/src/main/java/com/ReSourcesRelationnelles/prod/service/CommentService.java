package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.comment.CommentDTO;
import com.ReSourcesRelationnelles.prod.dto.comment.CreateCommentDTO;
import com.ReSourcesRelationnelles.prod.entity.*;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.CommentRepository;
import com.ReSourcesRelationnelles.prod.repository.ResourceRepository;
import com.ReSourcesRelationnelles.prod.security.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CommentService {

    @Autowired
    private CommentRepository commentRepository;
    @Autowired
    private ResourceRepository resourceRepository;
    @Autowired
    private SecurityUtils securityUtils;

    public CommentDTO addComment(Long resourceId, CreateCommentDTO request, Authentication auth) {
        User author = securityUtils.getCurrentUser(auth);

        if (request.getContent() == null || request.getContent().isBlank()) {
            throw new BadRequestException("Le commentaire est requis.");
        }

        Resource resource = resourceRepository.findById(resourceId)
                .orElseThrow(() -> new NotFoundException("Ressource introuvable"));

        if (resource.getStatus() != ResourceStatusEnum.ACCEPTED) {
            throw new BadRequestException("Impossible d'ajouter un commentaire sur une ressource non accepter.");
        }
        if (resource.getVisibility() != ResourceVisibilityEnum.PUBLIC) {
            throw new BadRequestException("Impossible d'ajouter un commentaire sur une ressource non public.");
        }
        if (!resource.isActive()) {
            throw new BadRequestException("Impossible d'ajouter un commentaire sur une ressource supprimée.");
        }

        Comment parent = null;
        if (request.getParentId() != null) {
            parent = commentRepository.findById(request.getParentId())
                    .orElseThrow(() -> new NotFoundException("Commentaire parent introuvable"));
        }

        Comment comment = new Comment();
        comment.setAuthor(author);
        comment.setContent(request.getContent());
        comment.setResource(resource);
        comment.setParentComment(parent);

        return new CommentDTO(commentRepository.save(comment));
    }

    public List<CommentDTO> getCommentsForResource(Long resourceId) {
        List<Comment> comments = commentRepository.findByResourceIdAndParentCommentIsNull(resourceId);
        return comments.stream()
                .map(CommentDTO::new)
                .collect(Collectors.toList());
    }
}

