
class Project {
  final int Project_id;
  final String Project_name;
  final int Tag_id;
  final int User_id;

  Project({
    required this.Project_id,
    required this.Tag_id,
    required this.User_id,
    required this.Project_name

  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      Project_id: json['Project_id'],
      Project_name: json['Project_name'],
      Tag_id: json['Tag_id'],
      User_id: json['User_id'],
    );
  }
}

