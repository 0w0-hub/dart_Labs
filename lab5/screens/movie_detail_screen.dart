import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late bool _isFavorite;
  double _userRating = 0.0;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.movie.isFavorite;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      widget.movie.isFavorite = _isFavorite;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? 'Đã thêm "${widget.movie.title}" vào danh sách Yêu thích!'
              : 'Đã xóa "${widget.movie.title}" khỏi danh sách Yêu thích.',
        ),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double tempRating = _userRating > 0 ? _userRating : widget.movie.rating;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Đánh giá "${widget.movie.title}"'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${tempRating.toStringAsFixed(1)} / 10',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: tempRating,
                    min: 1.0,
                    max: 10.0,
                    divisions: 18,
                    onChanged: (val) {
                      setDialogState(() {
                        tempRating = val;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Hủy'),
                ),
                FilledButton(
                  onPressed: () {
                    setState(() {
                      _userRating = tempRating;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cảm ơn bạn đã đánh giá ${tempRating.toStringAsFixed(1)} sao!'),
                      ),
                    );
                  },
                  child: const Text('Xác nhận'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _shareMovie() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Đang chia sẻ liên kết phim "${widget.movie.title}"...'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: Text(
          movie.title,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. HERO BANNER: STACK + IMAGE + GRADIENT
            // ==========================================
            Stack(
              children: [
                Image.network(
                  movie.posterUrl,
                  height: 230.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 230.0,
                      color: Colors.grey.shade300,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 230.0,
                      color: const Color(0xFF333333),
                      child: const Center(
                        child: Icon(Icons.movie, size: 64, color: Colors.white54),
                      ),
                    );
                  },
                ),
                // Lớp phủ Gradient đen dần về phía dưới
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 110.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                ),
                // Tên phim màu trắng in đậm ở góc dưới banner
                Positioned(
                  left: 16.0,
                  bottom: 14.0,
                  right: 16.0,
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 1),
                          blurRadius: 3,
                          color: Colors.black87,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14.0),

            // ==========================================
            // 2. GENRES CHIPS (WRAP + CONTAINER/CHIP)
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 6.0,
                children: movie.genres.map((genre) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F6),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      genre,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF49454F),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16.0),

            // ==========================================
            // 3. OVERVIEW TEXT
            // ==========================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                movie.overview,
                style: const TextStyle(
                  fontSize: 15.0,
                  height: 1.45,
                  color: Color(0xFF1D1B20),
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // ==========================================
            // 4. ACTION BUTTONS ROW (Favorite, Rate, Share)
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                  iconColor: _isFavorite ? Colors.red : const Color(0xFF49454F),
                  label: 'Favorite',
                  onTap: _toggleFavorite,
                ),
                _buildActionButton(
                  icon: Icons.star,
                  iconColor: _userRating > 0 ? Colors.amber : const Color(0xFF49454F),
                  label: _userRating > 0 ? '${_userRating.toStringAsFixed(1)}★' : 'Rate',
                  onTap: _showRatingDialog,
                ),
                _buildActionButton(
                  icon: Icons.share,
                  iconColor: const Color(0xFF49454F),
                  label: 'Share',
                  onTap: _shareMovie,
                ),
              ],
            ),

            const SizedBox(height: 24.0),

            // ==========================================
            // 5. TRAILERS SECTION
            // ==========================================
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Trailers',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1B20),
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: movie.trailers.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade300,
              ),
              itemBuilder: (context, index) {
                final trailer = movie.trailers[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.play_circle_fill,
                    size: 30.0,
                    color: Color(0xFF49454F),
                  ),
                  title: Text(
                    trailer.title,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Color(0xFF1D1B20),
                    ),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đang phát trailer: ${trailer.title}'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28.0, color: iconColor),
            const SizedBox(height: 6.0),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13.0,
                color: Color(0xFF49454F),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
