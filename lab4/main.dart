import 'package:flutter/material.dart';

import 'exercise1/core_widgets_demo.dart';
import 'exercise2/input_controls_demo.dart';
import 'exercise3/layout_basics_demo.dart';
import 'exercise4/scaffold_theme_demo.dart';
import 'exercise5/common_errors_fix_demo.dart';

void main() {
  runApp(const Lab4MainApp());
}

class Lab4MainApp extends StatelessWidget {
  const Lab4MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 4 – Flutter UI Fundamentals',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          surface: const Color(0xFFF7F7FA),
        ),
      ),
      home: const MainMenuScreen(),
    );
  }
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> exercises = [
      {
        'title': 'Exercise 1 – Core Widgets\nDemo',
        'screen': const CoreWidgetsDemoScreen(),
      },
      {
        'title': 'Exercise 2 – Input Controls\nDemo',
        'screen': const InputControlsDemo(),
      },
      {
        'title': 'Exercise 3 – Layout Demo',
        'screen': const LayoutBasicsDemoScreen(),
      },
      {
        'title': 'Exercise 4 – App Structure &\nTheme',
        'screen': const ScaffoldThemeDemoScreen(),
      },
      {
        'title': 'Exercise 5 – Common UI\nFixes',
        'screen': const CommonErrorsFixDemoScreen(),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lab 4 – Flutter UI Fundamentals',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        itemCount: exercises.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14.0),
        itemBuilder: (context, index) {
          final item = exercises[index];
          return Card(
            elevation: 0,
            color: const Color(0xFFF0F0F6), 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(color: Colors.grey.shade300, width: 0.8),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => item['screen'] as Widget),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 18.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1D1B20),
                          height: 1.3,
                        ),
                      ),
                    ),
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
    );
  }
}
