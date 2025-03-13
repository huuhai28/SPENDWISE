import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hai123/model/expense_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class FireStore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> CreateUser(String email) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .set({"id": _auth.currentUser!.uid, "email": email});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  final NumberFormat currencyFormat =
      NumberFormat.currency(locale: 'vi_VN', symbol: 'VND');

  Future<Map<String, int>> fetchTotals() async {
    int income = 0;
    int expense = 0;

    try {
      final snapshot = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("expenses")
          .get();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] as int?) ?? 0;
        final isIncome = data['type'] == true;

        if (isIncome) {
          income += amount;
        } else {
          expense += amount;
        }
      }

      final currentBalance = income - expense;

      await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
        "totalIncome": income,
        "totalExpense": expense,
        "currentBalance": currentBalance,
      });
      return {
        "totalIncome": income,
        "totalExpense": expense,
        "currentBalance": currentBalance,
      };
    } catch (e) {
      print(e);
      return {"totalIncome": 0, "totalExpense": 0, "currentBalance": 0};
    }
  }

  Future<bool> AddExpense(String title, bool isIncome, int amount,
      String category, DateTime selectedDate) async {
    try {
      var uuid = const Uuid().v4();
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("expenses")
          .doc(uuid)
          .set({
        "id": uuid,
        "title": title,
        "amount": amount,
        "date": Timestamp.fromDate(selectedDate), // Lưu dưới dạng Timestamp
        "type": isIncome,
        "category": category,
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Stream<QuerySnapshot> stream() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('expenses')
        .snapshots();
  }

  Future<bool> Update_Expense(
      String uuid, String title, int amount, bool type) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("expenses")
          .doc(uuid)
          .update({
        "date": Timestamp.fromDate(DateTime.now()),
        "title": title,
        "amount": amount,
        "type": type,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> delete_expense(String uuid) async {
    try {
      await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("expenses")
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  List<Expense> getExpenses(AsyncSnapshot snapshot) {
    try {
      final expensesList = snapshot.data!.docs.map<Expense>((doc) {
        final data = doc.data() as Map<String, dynamic>;
        String dateString;

        // Kiểm tra kiểu của trường 'date'
        if (data['date'] is Timestamp) {
          final date = (data['date'] as Timestamp).toDate();
          dateString = "${date.day}-${date.month}-${date.year}";
        } else if (data['date'] is String) {
          dateString = data['date'] as String; // Giữ nguyên nếu là String
        } else {
          dateString = "N/A";
          print('Unexpected date type: ${data['date'].runtimeType}');
        }
        return Expense(
          data["id"] ?? "",
          data["title"] ?? "",
          data["amount"]?.toDouble() ?? 0.0,
          dateString,
          data["type"] == true,
          data["category"] ?? "",
        );
      }).toList();
      return expensesList;
    } catch (e) {
      print('Error in getExpenses: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> fetchReportByDate(DateTime date) async {
    try {
      final startOfDay =
          Timestamp.fromDate(DateTime(date.year, date.month, date.day));
      final endOfDay = Timestamp.fromDate(
          DateTime(date.year, date.month, date.day, 23, 59, 59));

      final snapshot = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("expenses")
          .where("date", isGreaterThanOrEqualTo: startOfDay)
          .where("date", isLessThanOrEqualTo: endOfDay)
          .get();

      double totalIncome = 0.0;
      double totalExpense = 0.0;

      final expenses = snapshot.docs.map((doc) {
        final data = doc.data();
        final amount = (data['amount'] as num?)?.toDouble() ?? 0.0;
        final isIncome = data['type'] == true;
        final date = (data['date'] as Timestamp)
            .toDate(); // Chuyển Timestamp thành DateTime

        if (isIncome) {
          totalIncome += amount;
        } else {
          totalExpense += amount;
        }

        return Expense(
          data['id'] ?? "",
          data['title'] ?? "",
          amount,
          "${date.day}-${date.month}-${date.year}", // Chuyển thành chuỗi
          isIncome,
          data["category"] ?? "",
        );
      }).toList();

      return {
        "expenses": expenses,
        "totalIncome": totalIncome,
        "totalExpense": totalExpense,
        "balance": totalIncome - totalExpense,
      };
    } catch (e) {
      print('Error in fetchReportByDate: $e');
      return {
        "expenses": [],
        "totalIncome": 0.0,
        "totalExpense": 0.0,
        "balance": 0.0,
      };
    }
  }

  Future<Map<String, int>> fetchDailyTotals(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    try {
      final snapshot = await _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection('expenses')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();

      int totalIncome = 0;
      int totalExpense = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] as int?) ?? 0;
        final type = data['type'] as bool; // true = thu, false = chi
        if (type) {
          totalIncome += amount;
        } else {
          totalExpense += amount;
        }
      }

      return {
        'totalIncome': totalIncome,
        'totalExpense': totalExpense,
      };
    } catch (e) {
      print('Error in fetchDailyTotals: $e');
      return {'totalIncome': 0, 'totalExpense': 0};
    }
  }
}
