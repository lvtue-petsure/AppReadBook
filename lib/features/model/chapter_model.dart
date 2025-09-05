class Chapter {
  final int? id;
  final int? titlebookId;
  final int? chapterNumber;
  final String chapterTitle;
  final String content;

  Chapter({
    required this.id,
    required this.titlebookId,
    required this.chapterNumber,
    required this.chapterTitle,
    required this.content,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      id: json['id'],
      titlebookId: json['titlebookid'],
      chapterNumber: json['chapternumber'],
      chapterTitle: json['chaptertitle'],
      content: json['content'],
    );
  }
}