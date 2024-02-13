
import 'package:elemental_project/data_classes/question.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

Future<List<Question>> loadCSV() async {
  String csvString =
      await rootBundle.loadString('assets/questions/foundation_questions.csv');
  List<List<dynamic>> csvTable = CsvToListConverter().convert(csvString);

// Assuming you have loaded your CSV data into a List<List<dynamic>> called csvTable
  List<Question> questions =
      csvTable.map((row) => Question.fromCsv(row)).toList();

// Access individual questions
  for (var question in questions) {
    print('Question: ${question.question}');
    print(
        'Choices: ${question.choice1}, ${question.choice2}, ${question.choice3}, ${question.choice4}');
    print('Correct Choice: ${question.correctChoice}');
    print('---');
  }
  return questions;
}
