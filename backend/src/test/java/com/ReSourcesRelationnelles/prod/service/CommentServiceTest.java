package com.ReSourcesRelationnelles.prod.service;

import com.ReSourcesRelationnelles.prod.dto.comment.CommentDTO;
import com.ReSourcesRelationnelles.prod.dto.comment.CreateCommentDTO;
import com.ReSourcesRelationnelles.prod.entity.*;
import com.ReSourcesRelationnelles.prod.exception.BadRequestException;
import com.ReSourcesRelationnelles.prod.exception.NotFoundException;
import com.ReSourcesRelationnelles.prod.repository.CommentRepository;
import com.ReSourcesRelationnelles.prod.repository.ResourceRepository;
import com.ReSourcesRelationnelles.prod.security.SecurityUtils;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.security.core.Authentication;

import java.util.*;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.Mockito.*;

class CommentServiceTest {

    @InjectMocks
    private CommentService commentService;

    @Mock
    private CommentRepository commentRepository;

    @Mock
    private ResourceRepository resourceRepository;

    @Mock
    private SecurityUtils securityUtils;

    @Mock
    private Authentication authentication;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    // --- Tests pour addComment ---

    @Test
    void addComment_shouldThrowBadRequest_whenContentIsNull() {
        CreateCommentDTO request = new CreateCommentDTO();
        request.setContent(null);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(new User());

        assertThatThrownBy(() -> commentService.addComment(1L, request, authentication))
                .isInstanceOf(BadRequestException.class)
                .hasMessage("Le commentaire est requis.");
        verifyNoInteractions(resourceRepository, commentRepository);
    }

    @Test
    void addComment_shouldThrowNotFound_whenResourceNotFound() {
        CreateCommentDTO request = new CreateCommentDTO();
        request.setContent("Mon commentaire");

        when(securityUtils.getCurrentUser(authentication)).thenReturn(new User());
        when(resourceRepository.findById(1L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> commentService.addComment(1L, request, authentication))
                .isInstanceOf(NotFoundException.class)
                .hasMessage("Ressource introuvable");
    }

    @Test
    void addComment_shouldThrowBadRequest_whenResourceNotAccepted() {
        CreateCommentDTO request = new CreateCommentDTO();
        request.setContent("Mon commentaire");

        Resource resource = new Resource();
        resource.setStatus(ResourceStatusEnum.PENDING); // Pas ACCEPTED
        resource.setVisibility(ResourceVisibilityEnum.PUBLIC);
        resource.setActive(true);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(new User());
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));

        assertThatThrownBy(() -> commentService.addComment(1L, request, authentication))
                .isInstanceOf(BadRequestException.class)
                .hasMessage("Impossible d'ajouter un commentaire sur une ressource non accepter.");
    }

    @Test
    void addComment_shouldThrowBadRequest_whenResourceNotPublic() {
        CreateCommentDTO request = new CreateCommentDTO();
        request.setContent("Mon commentaire");

        Resource resource = new Resource();
        resource.setStatus(ResourceStatusEnum.ACCEPTED);
        resource.setVisibility(ResourceVisibilityEnum.PRIVATE); // Pas PUBLIC
        resource.setActive(true);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(new User());
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));

        assertThatThrownBy(() -> commentService.addComment(1L, request, authentication))
                .isInstanceOf(BadRequestException.class)
                .hasMessage("Impossible d'ajouter un commentaire sur une ressource non public.");
    }

    @Test
    void addComment_shouldThrowBadRequest_whenResourceNotActive() {
        CreateCommentDTO request = new CreateCommentDTO();
        request.setContent("Mon commentaire");

        Resource resource = new Resource();
        resource.setStatus(ResourceStatusEnum.ACCEPTED);
        resource.setVisibility(ResourceVisibilityEnum.PUBLIC);
        resource.setActive(false);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(new User());
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));

        assertThatThrownBy(() -> commentService.addComment(1L, request, authentication))
                .isInstanceOf(BadRequestException.class)
                .hasMessage("Impossible d'ajouter un commentaire sur une ressource supprimée.");
    }

    @Test
    void addComment_shouldThrowNotFound_whenParentCommentNotFound() {
        CreateCommentDTO request = new CreateCommentDTO();
        request.setContent("Mon commentaire");
        request.setParentId(5L);

        Resource resource = new Resource();
        resource.setStatus(ResourceStatusEnum.ACCEPTED);
        resource.setVisibility(ResourceVisibilityEnum.PUBLIC);
        resource.setActive(true);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(new User());
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));
        when(commentRepository.findById(5L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> commentService.addComment(1L, request, authentication))
                .isInstanceOf(NotFoundException.class)
                .hasMessage("Commentaire parent introuvable");
    }

    @Test
    void addComment_shouldThrowBadRequest_whenParentCommentNotVisible() {
        CreateCommentDTO request = new CreateCommentDTO();
        request.setContent("Mon commentaire");
        request.setParentId(5L);

        Resource resource = new Resource();
        resource.setStatus(ResourceStatusEnum.ACCEPTED);
        resource.setVisibility(ResourceVisibilityEnum.PUBLIC);
        resource.setActive(true);

        Comment parentComment = new Comment();
        parentComment.setVisible(false);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(new User());
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));
        when(commentRepository.findById(5L)).thenReturn(Optional.of(parentComment));

        assertThatThrownBy(() -> commentService.addComment(1L, request, authentication))
                .isInstanceOf(BadRequestException.class)
                .hasMessage("Impossible de répondre à un commentaire masqué.");
    }

    @Test
    void addComment_shouldAddCommentSuccessfully_withoutParent() {
        CreateCommentDTO request = new CreateCommentDTO();
        request.setContent("Mon commentaire");
        request.setParentId(null);

        User user = new User();
        user.setUsername("testUser");

        Resource resource = new Resource();
        resource.setStatus(ResourceStatusEnum.ACCEPTED);
        resource.setVisibility(ResourceVisibilityEnum.PUBLIC);
        resource.setActive(true);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(resourceRepository.findById(1L)).thenReturn(Optional.of(resource));
        when(commentRepository.save(any(Comment.class))).thenAnswer(invocation -> invocation.getArgument(0));

        CommentDTO result = commentService.addComment(1L, request, authentication);

        assertThat(result).isNotNull();
        assertThat(result.getAuthorUsername()).isEqualTo("testUser");
        assertThat(result.getContent()).isEqualTo("Mon commentaire");
        assertThat(result.getParentId()).isNull();

        verify(commentRepository, times(1)).save(any(Comment.class));
    }

    @Test
    void addComment_shouldAddCommentSuccessfully_withParent() {
        CreateCommentDTO request = new CreateCommentDTO();
        request.setContent("Réponse au commentaire");
        request.setParentId(10L);

        User user = new User();
        user.setUsername("moderator");

        Resource resource = new Resource();
        resource.setStatus(ResourceStatusEnum.ACCEPTED);
        resource.setVisibility(ResourceVisibilityEnum.PUBLIC);
        resource.setActive(true);

        Comment parentComment = new Comment();
        parentComment.setVisible(true);
        parentComment.setId(10L);

        when(securityUtils.getCurrentUser(authentication)).thenReturn(user);
        when(resourceRepository.findById(2L)).thenReturn(Optional.of(resource));
        when(commentRepository.findById(10L)).thenReturn(Optional.of(parentComment));
        when(commentRepository.save(any(Comment.class))).thenAnswer(invocation -> invocation.getArgument(0));

        CommentDTO result = commentService.addComment(2L, request, authentication);

        assertThat(result).isNotNull();
        assertThat(result.getAuthorUsername()).isEqualTo("moderator");
        assertThat(result.getContent()).isEqualTo("Réponse au commentaire");
        assertThat(result.getParentId()).isEqualTo(10L);

        verify(commentRepository, times(1)).save(any(Comment.class));
    }

    // --- Tests pour getCommentsForResource ---

    @Test
    void getCommentsForResource_shouldReturnListOfComments() {
        User author1 = new User();
        author1.setUsername("user1");

        Comment comment1 = new Comment();
        comment1.setId(1L);
        comment1.setContent("Commentaire 1");
        comment1.setVisible(true);
        comment1.setReplies(new ArrayList<>());
        comment1.setAuthor(author1);

        Comment comment2 = new Comment();
        comment2.setId(2L);
        comment2.setContent("Commentaire 2");
        comment2.setVisible(true);
        comment2.setReplies(new ArrayList<>());
        comment2.setAuthor(author1);

        List<Comment> comments = List.of(comment1, comment2);

        when(commentRepository.findByResourceIdAndParentCommentIsNullAndVisibleTrue(1L)).thenReturn(comments);

        List<CommentDTO> results = commentService.getCommentsForResource(1L);

        assertThat(results).hasSize(2);
        assertThat(results.get(0).getContent()).isEqualTo("Commentaire 1");
        assertThat(results.get(1).getContent()).isEqualTo("Commentaire 2");
    }

    // --- Tests pour moderateComment ---

    @Test
    void moderateComment_shouldThrowNotFound_whenCommentNotFound() {
        when(commentRepository.findById(1L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> commentService.moderateComment(1L, authentication))
                .isInstanceOf(NotFoundException.class)
                .hasMessage("Commentaire introuvable");
    }

    @Test
    void moderateComment_shouldModerateCommentSuccessfully() {
        User moderator = new User();
        moderator.setUsername("admin");

        User author = new User();
        author.setUsername("someAuthor");

        Comment comment = new Comment();
        comment.setId(1L);
        comment.setVisible(true);
        comment.setAuthor(author);

        when(commentRepository.findById(1L)).thenReturn(Optional.of(comment));
        when(securityUtils.getCurrentUser(authentication)).thenReturn(moderator);
        when(commentRepository.save(any(Comment.class))).thenAnswer(invocation -> invocation.getArgument(0));

        CommentDTO result = commentService.moderateComment(1L, authentication);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(comment.isVisible()).isFalse();
        assertThat(comment.getModeratedBy()).isEqualTo(moderator);
        assertThat(comment.getModeratedAt()).isNotNull();

        verify(commentRepository, times(1)).save(comment);
    }
}
