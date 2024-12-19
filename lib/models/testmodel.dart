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
      projectId: json['project_id'] ?? 0,  // ถ้า 'project_id' เป็น null ให้ใช้ 0
      projectName: json['project_name'] ?? '',  // ถ้า 'project_name' เป็น null ให้ใช้ค่า default เป็น ''
      userName: json['user_name'] ?? '',  // ถ้า 'user_name' เป็น null ให้ใช้ค่า default เป็น ''
      tagName: json['tag_name'] ?? '',  // ถ้า 'tag_name' เป็น null ให้ใช้ค่า default เป็น ''
    );
  }
}
