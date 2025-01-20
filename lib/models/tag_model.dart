class TagModel {
  final int tagId;
  final String tagName;
  final String tagColor;

  TagModel({
    required this.tagId,
    required this.tagName,
    required this.tagColor,
  });
  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      tagId: json['tag_id'] as int,
      tagName: json['tag_name'] as String,
      tagColor: json['tag_color'] as String,
    );
  }
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TagModel && other.tagId == tagId;
  }

  @override
  int get hashCode => tagId.hashCode;
}