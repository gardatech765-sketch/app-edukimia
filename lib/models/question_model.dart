/// Strongly-typed data class representing a single chemistry quiz question.
class QuestionModel {
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const QuestionModel({
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  /// Factory constructor to map raw dummy data into a robust model.
  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      questionText: map['question'] as String,
      options: List<String>.from(map['options'] as List),
      correctIndex: map['correctIndex'] as int,
      explanation: map['explanation'] as String,
    );
  }
}
