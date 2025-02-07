class Task {
  final int taskId;
  final String taskName;
  final String taskDetail;
  final String taskEnd;
  final String taskColor;
  bool taskStatus;
  final int userId;
  final int tagId;
  final int projectId;
  final String ownerName;
  final int taskOwner;
  final String tagName;
  final String tagColor;
   int taskOrder;


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
    required this.ownerName,
    required this.taskOwner,
    required this.tagName,
    required this.tagColor,
    required this.taskOrder,
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
      tagId: json['tag_id'] != null ? json['tag_id'] : -1,
      projectId: json['project_id'] ?? '',
      ownerName: json['owner_name'] ?? '',
      taskOwner: json['task_Owner'] != null ? json['task_Owner'] : 0,
      tagName: json['tag_name'] != null ? json['tag_name'] : "No Tag",
      tagColor: json['tag_color'] != null ? json['tag_color'] : "#808080",
      taskOrder: json['task_order'],
    );
  }
}
