import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stage_ott/constants/api_constants.dart';
import '../viewmodels/movie_viewmodel.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MovieViewModel>(context);
    final movies =
        vm.showFavoritesOnly
            ? vm.favoriteMovies
            : (searchQuery.isEmpty ? vm.movies : vm.search(searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        actions: [
          IconButton(
            icon: Icon(
              vm.showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: () => vm.toggleShowFavoritesOnly(),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search...',
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
        ),
      ),
      body:
          vm.isOffline
              ? const Center(
                child: Text("No internet. Showing saved favorites."),
              )
              : vm.isLoading
              ? const Center(child: CircularProgressIndicator())
              : vm.error.isNotEmpty
              ? Center(child: Text(vm.error))
              : GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.6,
                ),
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  final isFav = vm.isFavorite(movie.id);

                  return GestureDetector(
                    onTap:
                        () =>
                            vm.isOffline
                                ? ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("No internet connection."),
                                  ),
                                )
                                : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MovieDetailScreen(movie: movie),
                                  ),
                                ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                      shadowColor: Colors.black26,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${ApiConstants.imageUrl}${movie.posterPath}',
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                    errorWidget:
                                        (context, url, error) =>
                                            const Icon(Icons.broken_image),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: IconButton(
                                    icon: Icon(
                                      isFav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.redAccent,
                                    ),
                                    onPressed:
                                        () => vm.toggleFavorite(movie.id),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              movie.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
