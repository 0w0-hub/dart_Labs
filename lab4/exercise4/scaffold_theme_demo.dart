import 'package:flutter/material.dart';

void main() {
  runApp(const ScaffoldThemeApp());
}

class ScaffoldThemeApp extends StatefulWidget {
  const ScaffoldThemeApp({super.key});

  @override
  State<ScaffoldThemeApp> createState() => _ScaffoldThemeAppState();
}

class _ScaffoldThemeAppState extends State<ScaffoldThemeApp> {
  bool _isDarkMode = false;

  void _toggleTheme(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 4 – App Structure & Theme',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF141218),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD0BCFF),
          brightness: Brightness.dark,
        ),
      ),
      home: ScaffoldThemeDemoScreen(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class ScaffoldThemeDemoScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool>? onToggleTheme;

  const ScaffoldThemeDemoScreen({
    super.key,
    this.isDarkMode = false,
    this.onToggleTheme,
  });

  @override
  State<ScaffoldThemeDemoScreen> createState() => _ScaffoldThemeDemoScreenState();
}

class _ScaffoldThemeDemoScreenState extends State<ScaffoldThemeDemoScreen> {
  late bool _darkModeInternal;

  @override
  void initState() {
    super.initState();
    _darkModeInternal = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(covariant ScaffoldThemeDemoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _darkModeInternal = widget.isDarkMode;
    }
  }

  void _handleToggle(bool val) {
    setState(() {
      _darkModeInternal = val;
    });
    if (widget.onToggleTheme != null) {
      widget.onToggleTheme!(val);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise 4 – App Structure & Theme',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Row(
            children: [
              const Text(
                'Dark',
                style: TextStyle(fontSize: 14.0),
              ),
              const SizedBox(width: 4.0),
              Switch(
                value: _darkModeInternal,
                onChanged: _handleToggle,
              ),
              const SizedBox(width: 12.0),
            ],
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'This is a simple screen with theme toggle.',
            style: TextStyle(
              fontSize: 16.0,
              color: theme.textTheme.bodyMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _handleToggle(!_darkModeInternal);
        },
        tooltip: 'Toggle Theme',
        child: Icon(_darkModeInternal ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }
}
