import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/sample_data.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Movie> _filteredMovies = [];

  @override
  void initState() {
    super.initState();
    _filteredMovies = sampleMovies;
  }

  void _filterMovies(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredMovies = sampleMovies;
      } else {
        _filteredMovies = sampleMovies.where((movie) {
          final titleLower = movie.title.toLowerCase();
          final genresLower = movie.genres.join(' ').toLowerCase();
          final queryLower = query.toLowerCase();
          return titleLower.contains(queryLower) || genresLower.contains(queryLower);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text(
          'Movies',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 22.0,
            color: Color(0xFF1D1B20),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ==========================================
          // SEARCH BAR (OPTIONAL ENHANCEMENT)
          // ==========================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Tìm kiếm theo tên phim hoặc thể loại...',
              leading: const Icon(Icons.search, color: Color(0xFF49454F)),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      _filterMovies('');
                    },
                  ),
              ],
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: const WidgetStatePropertyAll(Color(0xFFEFEFF4)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: Colors.grey.shade300, width: 0.8),
                ),
              ),
              onChanged: _filterMovies,
            ),
          ),

          const SizedBox(height: 6.0),

          // ==========================================
          // MOVIE LIST VIEW (EXACT MATCH IMAGE 1)
          // ==========================================
          Expanded(
            child: _filteredMovies.isEmpty
                ? const Center(
                    child: Text(
                      'Không tìm thấy bộ phim phù hợp.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 10.0,
                    ),
                    itemCount: _filteredMovies.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14.0),
                    itemBuilder: (context, index) {
                      final movie = _filteredMovies[index];

                      return Card(
                        elevation: 0,
                        color: const Color(0xFFF0F0F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 0.8,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16.0),
                          onTap: () {
                            // Chuyển trang Movie Detail và truyền Movie object
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(movie: movie),
                              ),
                            ).then((_) {
                              // Cập nhật lại UI khi quay về nếu có thay đổi trạng thái
                              setState(() {});
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14.0,
                              vertical: 12.0,
                            ),
                            child: Row(
                              children: [
                                // Thumbnail ảnh bo góc 10px
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    movie.posterUrl,
                                    width: 90.0,
                                    height: 60.0,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 90.0,
                                        height: 60.0,
                                        color: Colors.grey.shade300,
                                        child: const Center(
                                          child: SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 90.0,
                                        height: 60.0,
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.movie,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(width: 14.0),

                                // Thông tin phim
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1D1B20),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6.0),
                                      Text(
                                        '☆ ${movie.rating} • ${movie.genres.join(', ')}',
                                        style: const TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFF49454F),
                                          height: 1.25,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8.0),

                                // Mũi tên điều hướng
                                const Icon(
                                  Icons.chevron_right,
                                  color: Color(0xFF49454F),
                                  size: 24.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
