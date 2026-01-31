import 'package:dio/dio.dart';
import '../domain/university.dart';

class UniversityRepository {
  UniversityRepository(this._dio);
  final Dio _dio;

  static const url =
      'https://tyba-assets.s3.amazonaws.com/FE-Engineer-test/universities.json';

  Future<List<University>> fetchAll() async {
    final res = await _dio.get(url);
    final data = res.data;
    if (data is! List) throw StateError('Unexpected JSON shape: expected a List');
    return data.map((e) => University.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}
