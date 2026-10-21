import 'package:flutter/material.dart';

import 'model/movie.dart';
import 'model/sample_data.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

/// Ứng dụng chính thiết lập Theme và màn hình khởi đầu
class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Genre Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
      ),
      home: const GenresScreen(),
    );
  }
}

/// Màn hình chính duyệt phim theo thể loại (StatefulWidget)
class GenresScreen extends StatefulWidget {
  const GenresScreen({super.key});

  @override
  State<GenresScreen> createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  // Quản lý controller và State tìm kiếm, lọc, sắp xếp
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedGenres = {};
  String _selectedSort = 'A-Z';
  int _currentBottomNavIndex = 1; // Mặc định ở tab 'Genre' (theo hình mẫu)

  final List<String> _sortOptions = ['A-Z', 'Z-A', 'Year', 'Rating'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Xóa toàn bộ bộ lọc về trạng thái ban đầu
  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedGenres.clear();
      _selectedSort = 'A-Z';
    });
  }

  /// Thuật toán lọc và sắp xếp phim
  List<Movie> get _filteredAndSortedMovies {
    // 1. Lọc theo từ khóa tìm kiếm và thể loại
    List<Movie> result = sampleMovies.where((movie) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          movie.title.toLowerCase().contains(_searchQuery.toLowerCase().trim());

      final matchesGenre =
          _selectedGenres.isEmpty ||
          movie.genres.any((genre) => _selectedGenres.contains(genre));

      return matchesSearch && matchesGenre;
    }).toList();

    // 2. Sắp xếp theo tiêu chí đã chọn
    switch (_selectedSort) {
      case 'A-Z':
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case 'Z-A':
        result.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;
      case 'Year':
        result.sort((a, b) => b.year.compareTo(a.year)); // Năm mới nhất lên đầu
        break;
      case 'Rating':
        result.sort(
          (a, b) => b.rating.compareTo(a.rating),
        ); // Điểm cao nhất lên đầu
        break;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final visibleMovies = _filteredAndSortedMovies;
    final bool hasActiveFilters =
        _searchQuery.isNotEmpty ||
        _selectedGenres.isNotEmpty ||
        _selectedSort != 'A-Z';

    return Scaffold(
      body: IndexedStack(
        index: _currentBottomNavIndex,
        children: [
          _buildHomeScreen(),
          _buildGenreContent(context, visibleMovies, hasActiveFilters),
          _buildFavoritesScreen(),
        ],
      ),
      // BOTTOM NAVIGATION BAR (Khớp với hình mẫu: Nền đen, 3 tab Home, Genre, Favorites)
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF141414),
          border: Border(
            top: BorderSide(color: Color(0xFF262626), width: 0.8),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentBottomNavIndex,
          onTap: (index) {
            setState(() {
              _currentBottomNavIndex = index;
            });
          },
          backgroundColor: const Color(0xFF141414),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade500,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.home, size: 24),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _currentBottomNavIndex == 1
                          ? Colors.white
                          : Colors.grey.shade500,
                      width: 1.8,
                    ),
                  ),
                  child: Icon(
                    Icons.music_note,
                    size: 13,
                    color: _currentBottomNavIndex == 1
                        ? Colors.white
                        : Colors.grey.shade500,
                  ),
                ),
              ),
              label: 'Genre',
            ),
            const BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Icon(Icons.favorite, size: 24),
              ),
              label: 'Favorites',
            ),
          ],
        ),
      ),
    );
  }

  /// Màn hình Home (Placeholder)
  Widget _buildHomeScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home_outlined, size: 64, color: Colors.deepPurple.shade300),
              const SizedBox(height: 12),
              const Text(
                'Home Screen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Switch to "Genre" tab to browse responsive movies',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Màn hình Favorites (Placeholder)
  Widget _buildFavoritesScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 64, color: Colors.redAccent.shade200),
              const SizedBox(height: 12),
              const Text(
                'Favorites Screen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'No favorite movies saved yet',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Nội dung màn hình duyệt phim theo thể loại (Genre Screen)
  Widget _buildGenreContent(
    BuildContext context,
    List<Movie> visibleMovies,
    bool hasActiveFilters,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // LAB 6.1: HERO & HEADING SECTION
            // ==========================================
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Find a Movie',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      // const SizedBox(height: 4),
                      // Text(
                      //   'Explore top movies by genres and keywords',
                      //   style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      // ),
                    ],
                  ),
                  if (hasActiveFilters)
                    TextButton.icon(
                      onPressed: _clearFilters,
                      icon: const Icon(Icons.clear_all, size: 18),
                      label: const Text('Reset'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Search Bar Responsive
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search movie by title...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.deepPurple,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ==========================================
              // LAB 6.2: GENRE CHIPS (DÙNG WIDGET WRAP)
              // ==========================================
              Row(
                children: [
                  const Text(
                    'Genres',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  if (_selectedGenres.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_selectedGenres.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),

              // WRAP WIDGET: Tự động xuống dòng khi màn hình hẹp
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: allGenres.map((genre) {
                  final isSelected = _selectedGenres.contains(genre);
                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    showCheckmark: true,
                    selectedColor: Colors.deepPurple.shade100,
                    checkmarkColor: Colors.deepPurple,
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Colors.deepPurple : Colors.black87,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.deepPurple
                            : Colors.grey.shade300,
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedGenres.add(genre);
                        } else {
                          _selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),

              // Thanh công cụ Sort & Số lượng phim tìm thấy
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${visibleMovies.length} movie${visibleMovies.length <= 1 ? '' : 's'} found',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Sort: ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSort,
                            isDense: true,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.deepPurple,
                            ),
                            items: _sortOptions.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(
                                  option,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedSort = newValue;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // ==========================================
              // LAB 6.3: RESPONSIVE MOVIE LIST THEO BREAKPOINT
              // ==========================================
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (visibleMovies.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.movie_filter_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No matching movies found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Try clearing your search query or selecting other genres.',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _clearFilters,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reset Filters'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // BREAKPOINT: 800px (Điện thoại < 800px; Tablet/Web >= 800px)
                    final bool isTabletOrWeb = constraints.maxWidth >= 800;

                    if (!isTabletOrWeb) {
                      // PHONE LAYOUT: ListView cuộn dọc 1 cột
                      return ListView.separated(
                        itemCount: visibleMovies.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return MovieCard(movie: visibleMovies[index]);
                        },
                      );
                    } else {
                      // TABLET / DESKTOP WEB LAYOUT: GridView 2 cột
                      return GridView.builder(
                        itemCount: visibleMovies.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 2.7, // Tỉ lệ chiều rộng / chiều cao của mỗi card
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                        itemBuilder: (context, index) {
                          return MovieCard(movie: visibleMovies[index]);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
  }
}

/// Thẻ hiển thị thông tin từng bộ phim với khả năng tự co giãn bằng LayoutBuilder
class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Điều chỉnh kích thước ảnh poster theo bề rộng của chính Card này
          final bool isWideCard = constraints.maxWidth > 450;
          final double posterWidth = isWideCard ? 115 : 90;
          final double posterHeight = isWideCard ? 160 : 130;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Poster phim kèm fallback khi tải lỗi
              SizedBox(
                width: posterWidth,
                height: posterHeight,
                child: Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.deepPurple.shade50,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.movie,
                              color: Colors.deepPurple.shade300,
                              size: 30,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              movie.title.substring(0, 1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                ),
              ),

              // Thông tin phim
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Tiêu đề phim
                      Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: isWideCard ? 17 : 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Năm phát hành & Rating
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${movie.year}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                            size: 18,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            movie.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            ' / 10',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Tags thể loại nhỏ gọn
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: movie.genres.map((g) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              g,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.deepPurple.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
