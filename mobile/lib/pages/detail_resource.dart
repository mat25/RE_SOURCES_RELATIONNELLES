import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/resource.dart';
import '../repositories/resource_repository.dart';
import '../repositories/comment_repository.dart';
import '../models/comment.dart';
import '../core/api/api_client.dart';
import '../widgets/resource/info_card.dart';
import '../widgets/resource/content_card.dart';
import '../widgets/resource/status_buttons.dart';
import '../widgets/resource/comment_section.dart';

class ResourceDetailPage extends StatefulWidget {
  final Resource resource;
  final String? token;

  const ResourceDetailPage({Key? key, required this.resource, this.token}) : super(key: key);

  @override
  State<ResourceDetailPage> createState() => _ResourceDetailPageState();
}

class _ResourceDetailPageState extends State<ResourceDetailPage> {
  late bool isFavorite;
  late bool isBookmarked;
  late bool isUsed;
  bool isLoading = true;
  final TextEditingController _commentController = TextEditingController();
  late ResourceRepository _repository;
  late CommentRepository _commentRepository;
  List<Comment> comments = [];

  @override
  void initState() {
    super.initState();
    isFavorite = false;
    isBookmarked = false;
    isUsed = false;
    _repository = ResourceRepository(ApiClient());
    _commentRepository = CommentRepository(ApiClient());
    _loadData();
  }

  Future<void> _loadData() async {
    await _fetchStatuses();
    await _fetchComments();
    setState(() => isLoading = false);
  }

  Future<void> _fetchStatuses() async {
    try {
      final id = widget.resource.id;
      final favorites = await _repository.fetchFavorites(token: widget.token);
      final setAside = await _repository.fetchSetAside(token: widget.token);
      final exploited = await _repository.fetchExploited(token: widget.token);

      setState(() {
        isFavorite = favorites.any((r) => r.id == id);
        isBookmarked = setAside.any((r) => r.id == id);
        isUsed = exploited.any((r) => r.id == id);
      });
    } catch (e) {
      _showError('Erreur statuts : $e');
    }
  }

  Future<void> _fetchComments() async {
    try {
      final result = await _commentRepository.fetchComments(widget.resource.id, token: widget.token);
      setState(() => comments = result);
    } catch (e) {
      _showError('Erreur commentaires : $e');
    }
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();
    if (content.isEmpty) return;
    try {
      await _commentRepository.postComment(
        resourceId: widget.resource.id,
        content: content,
        token: widget.token!,
      );
      _commentController.clear();
      await _fetchComments();
    } catch (e) {
      _showError('Erreur envoi commentaire : $e');
    }
  }

  Future<void> _toggleFavorite() async {
    try {
      await _repository.toggleFavorite(widget.resource.id, token: widget.token);
      setState(() => isFavorite = !isFavorite);
    } catch (e) {
      _showError('Erreur favori');
    }
  }

  Future<void> _toggleSetAside() async {
    try {
      await _repository.toggleSetAside(widget.resource.id, token: widget.token);
      setState(() => isBookmarked = !isBookmarked);
    } catch (e) {
      _showError('Erreur mise de côté');
    }
  }

  Future<void> _toggleExploited() async {
    try {
      await _repository.toggleExploited(widget.resource.id, token: widget.token);
      setState(() => isUsed = !isUsed);
    } catch (e) {
      _showError('Erreur exploité');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final resource = widget.resource;

    return Scaffold(
      appBar: AppBar(
        title: Text(resource.title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ResourceInfoCard(resource: resource),
            const SizedBox(height: 20),
            ResourceContentCard(resource: resource),
            const SizedBox(height: 30),
            StatusButtons(
              isBookmarked: isBookmarked,
              isFavorite: isFavorite,
              isUsed: isUsed,
              onBookmarkToggle: _toggleSetAside,
              onFavoriteToggle: _toggleFavorite,
              onUsedToggle: _toggleExploited,
            ),
            const SizedBox(height: 30),
            CommentSection(
              comments: comments,
              commentController: _commentController,
              onSubmit: _submitComment,
              onReply: (String content, int parentId) async {
                await _commentRepository.postComment(
                  resourceId: widget.resource.id,
                  content: content,
                  parentId: parentId,
                  token: widget.token!,
                );
                await _fetchComments();
              },
            ),
          ],
        ),
      ),
    );
  }
}
