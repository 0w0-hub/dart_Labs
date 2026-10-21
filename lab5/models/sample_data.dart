import 'movie.dart';

/// Danh sách dữ liệu mẫu khớp 100% với ảnh đề bài Lab 5 (Figures 8.12 - 8.18)
final List<Movie> sampleMovies = [
  Movie(
    id: 'dune-2',
    title: 'Dune: Part Two',
    posterUrl:
        'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=800&auto=format&fit=crop&q=80',
    overview:
        'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.6,
    trailers: const [
      Trailer(id: 't1', title: 'Official Trailer #1'),
      Trailer(id: 't2', title: 'IMAX Sneak Peek'),
    ],
  ),
  Movie(
    id: 'deadpool-wolverine',
    title: 'Deadpool & Wolverine',
    posterUrl:
        'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=800&auto=format&fit=crop&q=80',
    overview:
        'The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.',
    genres: ['Action', 'Comedy'],
    rating: 8.3,
    trailers: const [
      Trailer(id: 't3', title: 'Red Band Trailer'),
      Trailer(id: 't4', title: 'Behind the Scenes'),
    ],
  ),
  Movie(
    id: 'interstellar',
    title: 'Interstellar',
    posterUrl:
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=800&auto=format&fit=crop&q=80',
    overview:
        'A team of explorers travel through a wormhole in space in an attempt to ensure humanity\'s survival.',
    genres: ['Sci-Fi', 'Adventure', 'Drama'],
    rating: 8.7,
    trailers: const [
      Trailer(id: 't5', title: 'Teaser Trailer'),
      Trailer(id: 't6', title: 'Official Trailer'),
    ],
  ),
];
