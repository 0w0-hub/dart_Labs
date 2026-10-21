import 'package:flutter/material.dart';

void main() {
  runApp(const CoreWidgetsApp());
}

class CoreWidgetsApp extends StatelessWidget {
  const CoreWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 1 – Core Widgets Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
      ),
      home: const CoreWidgetsDemoScreen(),
    );
  }
}

class CoreWidgetsDemoScreen extends StatelessWidget {
  const CoreWidgetsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text(
          'Exercise 1 – Core Widgets Demo',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12.0),

            // 1. Headline Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Welcome to Flutter UI',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1B20),
                ),
              ),
            ),

            const SizedBox(height: 24.0),

            // 2. Icon (Material Icon)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.all(12.0),
                child: const Icon(
                  Icons.movie,
                  size: 54.0,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 28.0),

            // 3. Image.network
            Image.network(
              'https://picsum.photos/seed/flutterlab4road/600/320',
              height: 190.0,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 190.0,
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 190.0,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),

            const SizedBox(height: 20.0),

            // 4. Card containing a ListTile
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                elevation: 0,
                color: const Color(0xFFF0F0F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                  side: BorderSide(color: Colors.grey.shade300, width: 0.8),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.star,
                      color: Color(0xFF49454F),
                      size: 28.0,
                    ),
                    title: Text(
                      'Movie Item',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                        color: Color(0xFF1D1B20),
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Text(
                        'This is a sample ListTile inside a Card.',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFF49454F),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
