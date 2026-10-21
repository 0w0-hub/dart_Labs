import 'package:flutter/material.dart';

void main() {
  runApp(const InputControlsApp());
}

class InputControlsApp extends StatelessWidget {
  const InputControlsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 2 – Input Controls Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B5B82),
          surface: const Color(0xFFF7F7FA),
        ),
      ),
      home: const InputControlsDemo(),
    );
  }
}

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  double _sliderValue = 50.0;
  bool _switchValue = false;
  String? _selectedGenre;
  DateTime? _selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
      });
      messenger.showSnackBar(
        SnackBar(
          content: Text('Selected Date: ${picked.day}/${picked.month}/${picked.year}'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text(
          'Exercise 2 – Input Controls Demo',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Rating (Slider)
            const Text(
              'Rating (Slider)',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1B20),
              ),
            ),
            const SizedBox(height: 6.0),
            Slider(
              value: _sliderValue,
              min: 0.0,
              max: 100.0,
              activeColor: const Color(0xFF535F8A),
              inactiveColor: const Color(0xFFE4E2E9),
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            Text(
              'Current value: ${_sliderValue.round()}',
              style: const TextStyle(
                fontSize: 15.0,
                color: Color(0xFF1D1B20),
              ),
            ),

            const SizedBox(height: 24.0),

            // 2. Active (Switch)
            const Text(
              'Active (Switch)',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1B20),
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Is movie active?',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF1D1B20),
                  ),
                ),
                Switch(
                  value: _switchValue,
                  activeThumbColor: const Color(0xFF535F8A),
                  onChanged: (bool value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24.0),

            // 3. Genre (RadioListTile)
            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D1B20),
              ),
            ),
            const SizedBox(height: 4.0),
            // ignore: deprecated_member_use
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Action',
                style: TextStyle(fontSize: 16.0, color: Color(0xFF1D1B20)),
              ),
              value: 'Action',
              // ignore: deprecated_member_use
              groupValue: _selectedGenre,
              activeColor: const Color(0xFF535F8A),
              // ignore: deprecated_member_use
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            // ignore: deprecated_member_use
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Comedy',
                style: TextStyle(fontSize: 16.0, color: Color(0xFF1D1B20)),
              ),
              value: 'Comedy',
              // ignore: deprecated_member_use
              groupValue: _selectedGenre,
              activeColor: const Color(0xFF535F8A),
              // ignore: deprecated_member_use
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            const SizedBox(height: 4.0),
            Text(
              'Selected genre: ${_selectedGenre ?? 'None'}',
              style: const TextStyle(
                fontSize: 15.0,
                color: Color(0xFF1D1B20),
              ),
            ),

            const SizedBox(height: 28.0),

            // 4. Open Date Picker Button
            SizedBox(
              width: double.infinity,
              height: 48.0,
              child: FilledButton.tonal(
                onPressed: () => _pickDate(context),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF0EFF5),
                  foregroundColor: const Color(0xFF474360),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: Colors.grey.shade300, width: 0.8),
                  ),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Open Date Picker'
                      : 'Picked: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
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
