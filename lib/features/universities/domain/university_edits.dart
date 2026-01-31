import 'dart:io';

class UniversityEdits {
  final int? students;
  final File? imageFile;

  const UniversityEdits({this.students, this.imageFile});

  UniversityEdits copyWith({int? students, File? imageFile}) {
    return UniversityEdits(
      students: students ?? this.students,
      imageFile: imageFile ?? this.imageFile,
    );
  }
}
