import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hai123/service/firetor.dart';
import 'package:hai123/widgets/transaction_card.dart';
import '../screen/edit_screen.dart';

class StreamExpense extends StatefulWidget {
  const StreamExpense({super.key});

  @override
  _StreamExpenseState createState() => _StreamExpenseState();
}

class _StreamExpenseState extends State<StreamExpense> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FireStore_Datasource().stream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          print('StreamBuilder: No data in snapshot');
          return const Center(child: Text('Không có dữ liệu từ Firestore'));
        }
        final expensesList = FireStore_Datasource().getExpenses(snapshot);
        if (expensesList.isEmpty) {
          return const Center(child: Text('Chưa có khoản chi tiêu nào.'));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: expensesList.length,
          itemBuilder: (context, index) {
            final expense = expensesList[index];
            return Slidable(
              key: Key(expense.id),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.4,
                children: [
                  SlidableAction(
                    onPressed: (slidableContext) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditExpenseScreen(expense: expense),
                        ),
                      );
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Sửa',
                    spacing: 8,
                  ),
                  SlidableAction(
                    onPressed: (slidableContext) async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Xác nhận xóa'),
                          content:
                              Text('Bạn có chắc muốn xóa "${expense.title}"?'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, false),
                              child: const Text('Hủy'),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(dialogContext, true),
                              child: const Text('Xóa'),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        await FireStore_Datasource().delete_expense(expense.id);
                        // Chỉ gọi SnackBar nếu widget còn mounted và danh sách chưa rỗng
                        if (mounted &&
                            FireStore_Datasource()
                                .getExpenses(snapshot)
                                .isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('${expense.title} đã được xóa')),
                          );
                        }
                      }
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Xóa',
                    spacing: 8,
                  ),
                ],
              ),
              child: TransactionCard(expense),
            );
          },
        );
      },
    );
  }
}
