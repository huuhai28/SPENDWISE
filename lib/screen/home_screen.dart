import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hai123/service/firetor.dart';
import 'package:hai123/widgets/add_transaction.dart';
import '../model/expense_model.dart';
import '../widgets/stream_expense.dart';

class ExpenseHomePage extends StatefulWidget {
  final Expense? expense;
  const ExpenseHomePage({
    super.key,
    required this.expense,
  });

  @override
  State<ExpenseHomePage> createState() => _ExpenseHomePageState();
}

class _ExpenseHomePageState extends State<ExpenseHomePage> {
  final title = TextEditingController();
  final amount = TextEditingController();
  bool isIncome = true;
  int _totalIncome = 0;
  int _totalExpense = 0;
  int _currentBalance = 0;

  final FireStore_Datasource firestoreDatasource = FireStore_Datasource();

  @override
  void initState() {
    super.initState();
    _fetchTotals();
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

  _dialogBuider(BuildContext context) {
    DateTime date = DateTime.now();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: AddTransaction(
            onSave: (title, amount, category, type) async {
              await firestoreDatasource.AddExpense(
                  title, type == "thu", int.parse(amount), category, date);
              Navigator.of(context).pop();
              _fetchTotals();
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> _getPieChartData() {
    return [
      PieChartSectionData(
        value: _totalIncome.toDouble(),
        color: Colors.green,
        title: 'Thu nhập\n$_totalIncome VND',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: _totalExpense.toDouble(),
        color: Colors.red,
        title: 'Chi tiêu\n$_totalExpense VND',
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Quản Lý Chi Tiêu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng thu nhập: $_totalIncome VND',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Tổng chi tiêu: $_totalExpense VND',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Số dư hiện tại: $_currentBalance VND',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _currentBalance >= 0 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Biểu đồ thu chi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _getPieChartData(),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Danh mục thu chi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Expanded(
              child: StreamExpense(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _dialogBuider(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
