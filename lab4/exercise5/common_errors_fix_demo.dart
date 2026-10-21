import 'package:flutter/material.dart';

void main() {
  runApp(const CommonErrorsFixApp());
}

class CommonErrorsFixApp extends StatelessWidget {
  const CommonErrorsFixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercise 5 – Common UI Fixes',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
      ),
      home: const CommonErrorsFixDemoScreen(),
    );
  }
}

class CommonErrorsFixDemoScreen extends StatefulWidget {
  const CommonErrorsFixDemoScreen({super.key});

  @override
  State<CommonErrorsFixDemoScreen> createState() =>
      _CommonErrorsFixDemoScreenState();
}

class _CommonErrorsFixDemoScreenState extends State<CommonErrorsFixDemoScreen> {
  int _selectedTaskIndex = 0;

  // Variables for Task 3 & 4
  int _counter = 0;
  DateTime? _pickedDate;

  final List<String> _movies = const ['Movie A', 'Movie B', 'Movie C', 'Movie D'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        title: const Text(
          'Exercise 5 – Common UI Fixes',
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 19),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // PopupMenu to switch between the 4 required fix tasks
          PopupMenuButton<int>(
            tooltip: 'Chọn bài sửa lỗi',
            initialValue: _selectedTaskIndex,
            onSelected: (int index) {
              setState(() {
                _selectedTaskIndex = index;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 0,
                child: Text('Task 1: ListView in Column (Expanded)'),
              ),
              PopupMenuItem(
                value: 1,
                child: Text('Task 2: Fix Overflow (SingleChildScrollView)'),
              ),
              PopupMenuItem(
                value: 2,
                child: Text('Task 3: State Update (setState)'),
              ),
              PopupMenuItem(
                value: 3,
                child: Text('Task 4: Valid Context (DatePicker)'),
              ),
            ],
          ),
        ],
      ),
      body: _buildCurrentTaskView(),
    );
  }

  Widget _buildCurrentTaskView() {
    switch (_selectedTaskIndex) {
      case 0:
        return _buildTask1ExpandedView();
      case 1:
        return _buildTask2OverflowFixView();
      case 2:
        return _buildTask3SetStateFixView();
      case 3:
        return _buildTask4DatePickerContextView();
      default:
        return _buildTask1ExpandedView();
    }
  }

  // =========================================================================
  // TASK 1: EXACT MATCH VỚI ẢNH MẪU (IMAGE 6)
  // Correct ListView inside Column using Expanded
  // =========================================================================
  Widget _buildTask1ExpandedView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12.0),
          const Text(
            'Correct ListView inside Column using\nExpanded',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1B20),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12.0),
          // Bọc ListView bằng Expanded bên trong Column
          Expanded(
            child: ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                  leading: const Icon(
                    Icons.movie,
                    color: Color(0xFF49454F),
                    size: 28.0,
                  ),
                  title: Text(
                    _movies[index],
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Color(0xFF1D1B20),
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

  // =========================================================================
  // TASK 2: Fix overflow in small screens using SingleChildScrollView
  // =========================================================================
  Widget _buildTask2OverflowFixView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fix Overflow using SingleChildScrollView',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1B20),
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Nội dung dài được bọc an toàn trong SingleChildScrollView, loại bỏ sọc vàng đen trên màn hình nhỏ:',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 12.0),
          ...List.generate(7, (i) {
            return Card(
              elevation: 0,
              color: const Color(0xFFF0F0F6),
              margin: const EdgeInsets.only(bottom: 12.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey.shade300, width: 0.8),
              ),
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text('Cuộn an toàn - Thẻ số ${i + 1}'),
                subtitle: const Text('Không bao giờ bị lỗi RenderFlex overflowed.'),
              ),
            );
          }),
        ],
      ),
    );
  }

  // =========================================================================
  // TASK 3: Fix state update issue by adding setState()
  // =========================================================================
  Widget _buildTask3SetStateFixView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fix State Update by adding setState()',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1B20),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            'Bộ đếm hiện tại: $_counter',
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          FilledButton.icon(
            onPressed: () {
              // Fix: Gọi setState để thông báo cập nhật UI
              setState(() {
                _counter++;
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Bấm để tăng số (Có setState)'),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // TASK 4: Fix DatePicker build context errors
  // =========================================================================
  Widget _buildTask4DatePickerContextView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fix DatePicker BuildContext Error',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D1B20),
            ),
          ),
          const SizedBox(height: 12.0),
          Text(
            _pickedDate == null
                ? 'Chưa chọn ngày'
                : 'Ngày đã chọn: ${_pickedDate!.day}/${_pickedDate!.month}/${_pickedDate!.year}',
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          FilledButton.icon(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              // Fix: Kiểm tra mounted an toàn trước khi setState
              if (!mounted) return;
              if (date != null) {
                setState(() {
                  _pickedDate = date;
                });
              }
            },
            icon: const Icon(Icons.calendar_today),
            label: const Text('Mở DatePicker an toàn'),
          ),
        ],
      ),
    );
  }
}
