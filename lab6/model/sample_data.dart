import 'movie.dart';

const List<String> allGenres = [
  'Action',
  'Comedy',
  'Drama',
  'Sci-Fi',
  'Romance',
  'Animation',
  'Crime',
  'Adventure',
];

const List<Movie> sampleMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi', 'Adventure'],
    posterUrl: 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500&auto=format&fit=crop',
    rating: 8.8,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama', 'Adventure'],
    posterUrl: 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=500&auto=format&fit=crop',
    rating: 8.7,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Crime', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1509281373149-e957c6296406?w=500&auto=format&fit=crop',
    rating: 9.0,
  ),
  Movie(
    title: 'Spirited Away',
    year: 2001,
    genres: ['Animation', 'Adventure', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1579783900882-c0d3dad7b119?w=500&auto=format&fit=crop',
    rating: 8.6,
  ),
  Movie(
    title: 'Pulp Fiction',
    year: 1994,
    genres: ['Crime', 'Drama'],
    posterUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=500&auto=format&fit=crop',
    rating: 8.9,
  ),
  Movie(
    title: 'La La Land',
    year: 2016,
    genres: ['Comedy', 'Drama', 'Romance'],
    posterUrl: 'https://images.unsplash.com/photo-1518173946687-a4c8a383392e?w=500&auto=format&fit=crop',
    rating: 8.0,
  ),
  Movie(
    title: 'Parasite',
    year: 2019,
    genres: ['Drama', 'Comedy', 'Crime'],
    posterUrl: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=500&auto=format&fit=crop',
    rating: 8.5,
  ),
  Movie(
    title: 'Spider-Man: Into the Spider-Verse',
    year: 2018,
    genres: ['Animation', 'Action', 'Sci-Fi'],
    posterUrl: 'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=500&auto=format&fit=crop',
    rating: 8.4,
  ),
];
