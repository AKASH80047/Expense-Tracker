class AIMessageModel {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String>? quickSuggestions;

  const AIMessageModel({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.quickSuggestions,
  });
}
