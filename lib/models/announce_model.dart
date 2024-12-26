class Announce {
  final int announceId;
  final String announceText;
  final int projectId;
  final String announceDate;
  final String announceTitle;
  final int userId;

  Announce({
    required this.announceId,
    required this.announceText,
    required this.projectId,
    required this.announceDate,
    required this.announceTitle,
    required this.userId,
  });

  factory Announce.fromJson(Map<String, dynamic> json) {
    return Announce(
      announceId: json['announce_id'] ?? 0,
      announceText: json['announce_text'] ?? '',
      projectId: json['project_id'] ?? 0,
      announceDate: json['announce_date'] ?? '',
      announceTitle: json['announce_title'] ?? '',
      userId: json['user_id'] ?? '0',
    );
  }
}
