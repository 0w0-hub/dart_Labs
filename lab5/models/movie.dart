/// Model biểu diễn một trailer của bộ phim
class Trailer {
  final String id;
  final String title;

  const Trailer({
    required this.id,
    required this.title,
  });
}

/// Model biểu diễn thông tin chi tiết một bộ phim
class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;
  bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
    this.isFavorite = false,
  });
}
