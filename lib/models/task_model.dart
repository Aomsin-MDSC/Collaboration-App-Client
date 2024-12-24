class Task {
  final int taskId;
  final String taskName;
  final String taskDetail;
  final DateTime taskEnd;
  final String taskColor;
  final bool taskStatus;
  final int userId;
  final int tagId;
  final int projectId;

  Task({
    required this.taskId,
    required this.taskName,
    required this.taskDetail,
    required this.taskEnd,
    required this.taskStatus,
    required this.userId,
    required this.tagId,
    required this.projectId,
    required this.taskColor,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['task_id'] ?? 0,
      taskName: json['task_name'] ?? '',
      taskDetail: json['task_detail'] ?? '',
      taskEnd: json['task_end'] ?? '',
      taskColor: json['task_color'] ?? '',
      taskStatus: json['task_status'] ?? '',
      userId: json['user_id'] ?? '',
      tagId: json['tag_id'] ?? '',
      projectId: json['project_id'] ?? '',
    );
  }
}
