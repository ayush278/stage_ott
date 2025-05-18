import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stage_ott/constants/api_constants.dart';
import '../models/movie.dart';
import '../viewmodels/movie_viewmodel.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MovieViewModel>(context);
    final isFav = vm.isFavorite(movie.id);

    return vm.isOffline
        ? Scaffold(
          appBar: AppBar(title: Text(movie.title)),
          body: const Center(child: Text("No internet connection.")),
        )
        : Scaffold(
          appBar: AppBar(
            title: Text(movie.title),
            actions: [
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () => vm.toggleFavorite(movie.id),
              ),
            ],
          ),
          body: ListView(
            children: [
              Image.network('${ApiConstants.imageUrl}${movie.posterPath}'),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  movie.overview,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Release: ${movie.releaseDate} | Rating: ${movie.rating}",
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        );
  }
}
