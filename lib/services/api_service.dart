import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stage_ott/constants/api_constants.dart';
import '../models/movie.dart';

class ApiService {
  static Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
      Uri.parse(
        "${ApiConstants.baseUrl}/movie/popular?api_key=${ApiConstants.apiKey}",
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['results'] as List).map((e) => Movie.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load movies");
    }
  }
}
