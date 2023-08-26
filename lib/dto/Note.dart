class Note {
  final String title;
  final String content;
  bool isSelected;

  Note({
    required this.title,
    required this.content,
    this.isSelected = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'isSelected': isSelected,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      title: json['title'],
      content: json['content'],
      isSelected: json['isSelected'] ?? false,
    );
  }
}
