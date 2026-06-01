import 'question_model.dart';

/// Strongly-typed data class for evaluating mistakes.
/// Pairs the [QuestionModel] with the [selectedWrongIndex] chosen by the user
/// to give descriptive context on why the chosen answer was wrong.
class RecapModel {
  final QuestionModel question;
  final int selectedWrongIndex;

  const RecapModel({
    required this.question,
    required this.selectedWrongIndex,
  });
}
