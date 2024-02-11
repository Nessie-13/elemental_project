class Question {
  String question;
  String choice1;
  String choice2;
  String choice3;
  String choice4;
  String correctChoice;

  Question({
    required this.question,
    required this.choice1,
    required this.choice2,
    required this.choice3,
    required this.choice4,
    required this.correctChoice,
  });

  // Factory method to create a Question instance from a CSV row
  factory Question.fromCsv(List<dynamic> csvRow) {
    return Question(
      question: csvRow[0].toString(),
      choice1: csvRow[1].toString(),
      choice2: csvRow[2].toString(),
      choice3: csvRow[3].toString(),
      choice4: csvRow[4].toString(),
      correctChoice: csvRow[5].toString(),
    );
  }
}
