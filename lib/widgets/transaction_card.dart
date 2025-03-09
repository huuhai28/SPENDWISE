import 'package:flutter/material.dart';
import '../model/expense_model.dart';
import '../service/firetor.dart';
import '../model/icons_list.dart';

class TransactionCard extends StatefulWidget {
  final Expense _expense;
  const TransactionCard(this._expense, {super.key});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  var appIcons = AppIcons();

  void _confirmDelete(Expense expense) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn xóa mục này?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                FireStore_Datasource().delete_expense(expense.id);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appIcons = AppIcons();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: widget._expense.type ? Colors.green : Colors.red,
            ),
            child: Icon(
                appIcons.getExpenseCategoryIcons(widget._expense.category)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget._expense.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text("Balance"),
              Text(
                widget._expense.date,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${widget._expense.amount.toStringAsFixed(0)} VND",
                style: TextStyle(
                  color: widget._expense.type ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text("Số dư: ??? VND"),
            ],
          ),
        ],
      ),
    );
  }
}
