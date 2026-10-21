import 'package:flutter/material.dart';

void main() {
  runApp(const LayoutBasicsApp());
}

class LayoutBasicsApp extends StatelessWidget {
  const LayoutBasicsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 3 – Layout Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
      ),
      home: const LayoutBasicsDemoScreen(),
    );
  }
}

class MovieItem {
  final String title;
  final String description;

  const MovieItem({
    required this.title,
    required this.description,
  });
}

class LayoutBasicsDemoScreen extends StatelessWidget {
  const LayoutBasicsDemoScreen({super.key});

  final List<MovieItem> _movies = const [
    MovieItem(title: 'Avatar', description: 'Sample description'),
    MovieItem(title: 'Inception', description: 'Sample description'),
    MovieItem(title: 'Interstellar', description: 'Sample description'),
    MovieItem(title: 'Joker', description: 'Sample description'),
  ];

  @override
  Widget build(BuildContext context) {
    const double spacing = 12.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text(
          'Exercise 3 – Layout Demo',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 12.0),

            // Headline "Now Playing" centered
            const Center(
              child: Text(
                'Now Playing',
                style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1B20),
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            // ListView.builder inside Column wrapped in Expanded
            Expanded(
              child: ListView.separated(
                itemCount: _movies.length,
                separatorBuilder: (context, index) => const SizedBox(height: spacing),
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  final initial = movie.title.isNotEmpty ? movie.title[0] : '?';

                  return Card(
                    elevation: 0,
                    color: const Color(0xFFF0F0F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(color: Colors.grey.shade300, width: 0.8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFDCE2FE),
                          radius: 22.0,
                          child: Text(
                            initial,
                            style: const TextStyle(
                              color: Color(0xFF1B1B1F),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        title: Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1D1B20),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            movie.description,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Color(0xFF49454F),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
