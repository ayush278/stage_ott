import 'package:flutter_test/flutter_test.dart';
import 'package:stage_ott/models/movie.dart';
import 'package:stage_ott/viewmodels/movie_viewmodel.dart';

void main() {
  group('MovieViewModel Tests', () {
    late MovieViewModel vm;

    final testMovies = [
      Movie(
        id: 1,
        title: 'Inception',
        posterPath: '/inception.jpg',
        overview: 'Mind-bending thriller',
        releaseDate: '2010-07-16',
        rating: 8.8,
      ),
      Movie(
        id: 2,
        title: 'Interstellar',
        posterPath: '/interstellar.jpg',
        overview: 'Space odyssey',
        releaseDate: '2014-11-07',
        rating: 8.6,
      ),
    ];

    setUp(() {
      vm = MovieViewModel();

      vm
        ..movies.clear()
        ..movies.addAll(testMovies);
    });

    test('Initial state', () {
      expect(vm.movies.length, 2);
      expect(vm.favoriteMovies.length, 0);
      expect(vm.isFavorite(1), false);
    });

    test('Toggle favorite adds/removes correctly', () {
      vm.toggleFavorite(1);
      expect(vm.isFavorite(1), true);
      expect(vm.favoriteMovies.length, 1);

      vm.toggleFavorite(1);
      expect(vm.isFavorite(1), false);
      expect(vm.favoriteMovies.length, 0);
    });

    test('Search movies by title', () {
      final result = vm.search('inter');
      expect(result.length, 1);
      expect(result.first.title, 'Interstellar');
    });

    test('Favorites filter works correctly', () {
      vm.toggleFavorite(2);
      final favs = vm.favoriteMovies;
      expect(favs.length, 1);
      expect(favs.first.id, 2);
    });
  });
}
