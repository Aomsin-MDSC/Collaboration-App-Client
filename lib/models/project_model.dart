class Project {
  final int projectId;
  final String projectName;
  final String userName;
  final String tagName;
  final int tagId;
  final int userId;
  final String tagColor;

  Project({
    required this.projectId,
    required this.projectName,
    required this.userName,
    required this.tagName,
    required this.tagId,
    required this.userId,
    required this.tagColor,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      tagId: json['tag_id'] ?? 0,
      projectId: json['project_id'] ?? 0,
      projectName: json['project_name'] ?? '',
      userName: json['user_name'] ?? '',
      tagName: json['tag_name'] ?? '',
      userId: json['user_id'] ?? 0,
      tagColor: json['tag_color'],
    );
  }
}
