import 'package:flutter/material.dart';
import 'package:hai123/model/colors.dart';
import 'package:hai123/service/firetor.dart';
import '../widgets/datepicker.dart';
import '../widgets/stream_expense.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  DateTime selectedDate = DateTime.now();
  final datepciker = Datepicker();
  bool isIncome = true;
  int _totalIncome = 0;
  int _totalExpense = 0;
  int _currentBalance = 0;
  Map<DateTime, Map<String, int>> _dailyTotals =
      {}; // Lưu trữ tổng thu/chi theo ngày

  final FireStore_Datasource firestoreDatasource = FireStore_Datasource();

  @override
  void initState() {
    super.initState();
    _fetchTotals();
    _fetchDailyTotalsForMonth();
  }

  Future<void> _fetchTotals() async {
    final totals = await firestoreDatasource.fetchTotals();
    if (mounted) {
      setState(() {
        _currentBalance = totals["currentBalance"] ?? 0;
        _totalExpense = totals["totalExpense"] ?? 0;
        _totalIncome = totals["totalIncome"] ?? 0;
      });
    }
  }

  Future<void> _fetchDailyTotalsForMonth() async {
    final firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    final lastDay = DateTime(selectedDate.year, selectedDate.month + 1, 0);

    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(selectedDate.year, selectedDate.month, day);
      final totals = await firestoreDatasource.fetchDailyTotals(date);
      if (mounted) {
        setState(() {
          _dailyTotals[date] = totals;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateCalendarDays(selectedDate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColors,
        title: const Text("Lịch"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedDate =
                        DateTime(selectedDate.year, selectedDate.month - 1);
                    _fetchDailyTotalsForMonth(); // Cập nhật dữ liệu khi thay đổi tháng
                  });
                },
              ),
              TextButton(
                onPressed: () => datepciker.showCupertinoDatePicker(
                    context, selectedDate, (DateTime newDate) {
                  setState(() {
                    selectedDate = newDate;
                    _fetchDailyTotalsForMonth(); // Cập nhật dữ liệu khi chọn ngày mới
                  });
                }),
                child: Container(
                  height: 40,
                  width: 270,
                  decoration: BoxDecoration(
                    color: second,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  setState(() {
                    selectedDate =
                        DateTime(selectedDate.year, selectedDate.month + 1);
                    _fetchDailyTotalsForMonth(); // Cập nhật dữ liệu khi thay đổi tháng
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                .map((e) => Expanded(
                      child: Center(
                        child: Text(e),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(
            height: 300,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: days.length,
              itemBuilder: (context, index) {
                final day = days[index];
                return Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: day == null
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${day.day}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${_dailyTotals[DateTime(day.year, day.month, day.day)]?['totalIncome'] ?? 0}',
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.blue),
                                    ),
                                    Text(
                                      '${_dailyTotals[DateTime(day.year, day.month, day.day)]?['totalExpense'] ?? 0}',
                                      style: const TextStyle(
                                          fontSize: 10, color: Colors.red),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                total("Thu nhập", '$_totalIncome', Colors.green),
                total("Chi tiêu", "$_totalExpense", Colors.red),
                total("Tổng", "$_currentBalance", Colors.orange),
              ],
            ),
          ),
          Container(height: 0.5, color: Colors.grey),
          const Expanded(
            child: StreamExpense(),
          ),
        ],
      ),
    );
  }
}

Widget line() {
  return Container(
    height: 0.5,
    width: double.infinity,
    color: Colors.grey,
  );
}

Widget total(String title, String number, Color color) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.black),
        ),
        Text(
          number,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

List<DateTime?> _generateCalendarDays(DateTime selectedDate) {
  final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
  final lastDayOfMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0);

  final daysBefore = firstDayOfMonth.weekday % 7;
  final daysAfter = 6 - lastDayOfMonth.weekday % 7;

  final totalDays = daysBefore + lastDayOfMonth.day + daysAfter;

  return List.generate(totalDays, (index) {
    final day = index - daysBefore + 1;
    if (day < 1 || day > lastDayOfMonth.day) {
      return null;
    } else {
      return DateTime(selectedDate.year, selectedDate.month, day);
    }
  });
}
