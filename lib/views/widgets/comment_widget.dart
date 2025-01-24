import 'package:collaboration_app_client/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({super.key, required this.comment});

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          comment.userName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              const TextSpan(
                text: " : ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: comment.commentText,
              ),
            ],
          ),
        ),
        Text(
          DateFormat('dd/MM/yyyy HH:mm').format(comment.commentDate),
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
