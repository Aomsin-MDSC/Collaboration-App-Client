class CommentModel {
  final int commentId;
  final String commentText;
  final DateTime commentDate;
  final int userId;
  final int taskId;
  final String userName;

  CommentModel({
    required this.commentId,
    required this.commentText,
    required this.commentDate,
    required this.userId,
    required this.taskId,
    required this.userName,
  });
}