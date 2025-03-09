import 'package:flutter/material.dart';
import 'package:hai123/model/expense_model.dart';
import 'package:hai123/model/icons_list.dart';
import 'package:hai123/service/firetor.dart';
import 'package:hai123/widgets/datepicker.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late bool type;
  late String selectCategoryIndex;
  late DateTime selectedDate;
  final datepicker = Datepicker();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final FireStore_Datasource firestoreDatasource = FireStore_Datasource();

  @override
  void initState() {
    super.initState();
    type = widget.expense.type;
    selectCategoryIndex = widget.expense.category;
    final dateParts = widget.expense.date.split('-');
    selectedDate = DateTime(
      int.parse(dateParts[2]),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
    );
    titleController.text = widget.expense.title;
    amountController.text = widget.expense.amount.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa giao dịch'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Text('Ngày',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              title: TextButton(
                onPressed: () => datepicker.showCupertinoDatePicker(
                  context,
                  selectedDate,
                  (DateTime newDate) {
                    setState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
                child: Text(
                  "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            ListTile(
              leading: const Text('Ghi chú',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              title: TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Nhập ghi chú'),
              ),
            ),
            ListTile(
              leading: const Text('Tiền',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              title: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Nhập số tiền'),
              ),
            ),
            ListTile(
              leading: const Text('Loại',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              title: ToggleButtons(
                isSelected: [type == false, type == true],
                onPressed: (index) {
                  setState(() {
                    type = index == 1;
                  });
                },
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Chi'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Thu'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    amountController.text.isNotEmpty &&
                    int.tryParse(amountController.text) != null) {
                  await firestoreDatasource.Update_Expense(
                    widget.expense.id,
                    titleController.text,
                    int.parse(amountController.text),
                    type,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Vui lòng nhập đầy đủ thông tin hợp lệ!')),
                  );
                }
              },
              child: const Text('Lưu thay đổi'),
            ),
          ],
        ),
      ),
    );
  }
}
