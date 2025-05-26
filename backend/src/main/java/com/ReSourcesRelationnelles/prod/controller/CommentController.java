package com.ReSourcesRelationnelles.prod.controller;

import com.ReSourcesRelationnelles.prod.dto.comment.CommentDTO;
import com.ReSourcesRelationnelles.prod.dto.comment.CreateCommentDTO;
import com.ReSourcesRelationnelles.prod.service.CommentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/resources/{resourceId}/comments")
public class CommentController {

    @Autowired
    private CommentService commentService;

    @Operation(summary = "Ajouter un commentaire à une ressource (réponse possible)", description = "Accessible uniquement aux utilisateurs authentifiés.")
    @ApiResponse(responseCode = "200", description = "Commentaire ajouté avec succès (CommentDTO)")
    @PostMapping
    @PreAuthorize("hasAnyRole('USER','MODERATOR')")
    public ResponseEntity<CommentDTO> addComment(@PathVariable Long resourceId, @RequestBody CreateCommentDTO request, Authentication auth) {
        return ResponseEntity.ok(commentService.addComment(resourceId, request, auth));
    }

    @Operation(summary = "Lister les commentaires d'une ressource", description = "Liste hiérarchique des commentaires et de leurs réponses.")
    @ApiResponse(responseCode = "200", description = "Liste des commentaires récupérée (List<CommentDTO>)")
    @GetMapping
    public ResponseEntity<List<CommentDTO>> getComments(@PathVariable Long resourceId) {
        return ResponseEntity.ok(commentService.getCommentsForResource(resourceId));
    }
}

