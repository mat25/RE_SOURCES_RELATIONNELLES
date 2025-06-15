import 'package:flutter/material.dart';
import '../../models/comment.dart';

class CommentSection extends StatelessWidget {
  final List<Comment> comments;
  final TextEditingController commentController;
  final VoidCallback onSubmit;
  final Future<void> Function(String content, int parentId) onReply;

  const CommentSection({
    Key? key,
    required this.comments,
    required this.commentController,
    required this.onSubmit,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Commentaires', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...comments.map((c) => _buildCommentTile(context, c)).toList(),
        const SizedBox(height: 20),
        const Text('Ajouter un commentaire', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: commentController,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: 'Votre commentaire...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: onSubmit,
            child: const Text('Envoyer'),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTile(BuildContext context, Comment comment, {int indentLevel = 0}) {
    final replyController = TextEditingController();
    bool showReplyField = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: EdgeInsets.only(left: indentLevel * 16.0, bottom: 12.0),
          child: Card(
            color: Colors.grey[100],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
                      const SizedBox(width: 8),
                      Text(comment.authorUsername, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 8),
                      Text('• ${comment.createdAt.toLocal().toString().split(' ')[0]}',
                          style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(comment.content, style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() => showReplyField = !showReplyField),
                    child: Text(showReplyField ? 'Annuler' : 'Répondre'),
                  ),
                  if (showReplyField) ...[
                    TextField(
                      controller: replyController,
                      decoration: const InputDecoration(
                        hintText: 'Votre réponse...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      ),
                      minLines: 1,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () async {
                          final reply = replyController.text.trim();
                          if (reply.isEmpty) return;
                          await onReply(reply, comment.id);
                          replyController.clear();
                          setState(() => showReplyField = false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Envoyer'),
                      ),
                    ),
                  ],
                  ...comment.replies.map(
                        (reply) => _buildCommentTile(context, reply, indentLevel: indentLevel + 1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
