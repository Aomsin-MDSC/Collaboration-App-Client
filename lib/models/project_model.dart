class Project {
  final int projectId;
  final String projectName;
  final String userName;
  final String tagName;

  Project({
    required this.projectId,
    required this.projectName,
    required this.userName,
    required this.tagName,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['project_id'] ?? 0,
      projectName: json['project_name'] ?? '',
      userName: json['user_name'] ?? '',
      tagName: json['tag_name'] ?? '',
    );
  }
}
