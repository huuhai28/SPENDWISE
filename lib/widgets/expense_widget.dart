// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:hai123/model/expense_model.dart';

import '../service/firetor.dart';

class ExpenseWidget extends StatefulWidget {
  final Expense _expense;
  const ExpenseWidget(this._expense, {super.key});

  @override
  State<ExpenseWidget> createState() => _ExpenseWidgetState();
}

class _ExpenseWidgetState extends State<ExpenseWidget> {
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
    return ListTile(
      leading: Icon(
        widget._expense.type ? Icons.arrow_upward : Icons.arrow_downward,
        color: widget._expense.type ? Colors.green : Colors.red,
      ),
      title: Text(
        '${widget._expense.type ? 'Thu nhập' : 'Chi tiêu'} - ${widget._expense.title}',
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget._expense.date,
          ),
          Text(
            "${widget._expense.amount.toInt()}",
          ),
        ],
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                _confirmDelete(widget._expense);
              },
            ),
          ],
        ),
      ),
    );
  }
}
