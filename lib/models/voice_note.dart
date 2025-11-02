class VoiceNote {
  String id;
  String title;
  String content;
  DateTime timestamp;

  VoiceNote({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };

  factory VoiceNote.fromJson(Map<String, dynamic> json) => VoiceNote(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}
