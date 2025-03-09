import 'package:flutter/material.dart';

import '../model/icons_list.dart';
import 'category_dropdown.dart';

class AddTransaction extends StatefulWidget {
  final void Function(String title, String amount, String category, String type)
      onSave;

  const AddTransaction({super.key, required this.onSave});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final title = TextEditingController();
  final amount = TextEditingController();
  var type = "chi";
  List<bool> isSelected = [false, true];
  var category = AppIcons().homeExpensesCategories.isNotEmpty
      ? AppIcons().homeExpensesCategories[0]['name']
      : null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Danh mục'),
            ),
            TextField(
              controller: amount,
              decoration: const InputDecoration(labelText: 'Số tiền'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 10,
            ),
            CategoryDropdown(
              cattype: category,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    category = value;
                  });
                }
              },
            ),
            const SizedBox(height: 10),
            ToggleButtons(
              isSelected: isSelected,
              onPressed: (index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                  type = index == 0 ? "thu" : "chi";
                });
              },
              borderRadius: BorderRadius.circular(8),
              selectedColor: Colors.white,
              fillColor: Colors.orange,
              color: Colors.black,
              borderColor: Colors.grey,
              selectedBorderColor: Colors.orange,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Thu"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Chi"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (title.text.isNotEmpty &&
                    amount.text.isNotEmpty &&
                    int.tryParse(amount.text) != null) {
                  widget.onSave(
                    title.text,
                    amount.text,
                    category ?? "Khác",
                    type,
                  );
                  title.clear();
                  amount.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vui lòng nhập đầy đủ thông tin hợp lệ!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
