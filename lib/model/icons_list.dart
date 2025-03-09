import 'package:flutter/material.dart';

class AppIcons {
  final List<Map<String, dynamic>> homeExpensesCategories = [
    {
      "name": "Nhà",
      "icon": Icons.home,
      "color": Colors.pink, // Màu nhà
    },
    {
      "name": "Ăn uống",
      "icon": Icons.restaurant,
      "color": Colors.green, // Màu ăn uống
    },
    {
      "name": "Quần áo",
      "icon": Icons.checkroom,
      "color": Colors.purple, // Màu quần áo
    },
    {
      "name": "Khác",
      "icon": Icons.shopping_bag,
      "color": Colors.blue, // Màu cho mục 'Khác'
    },
    {
      "name": "Đi lại",
      "icon": Icons.directions_car,
      "color": Colors.orange, // Màu đi lại
    },
    {
      "name": "Phí liên lạc",
      "icon": Icons.phone,
      "color": Colors.teal, // Màu phí liên lạc
    },
    {
      "name": "Vay mượn",
      "icon": Icons.money_off,
      "color": Colors.red, // Màu vay mượn
    },
    {
      "name": "Tiền lương",
      "icon": Icons.account_balance_wallet,
      "color": Colors.green, // Màu tiền lương
    },
    {
      "name": "Tiền thưởng",
      "icon": Icons.card_giftcard,
      "color": Colors.amber, // Màu tiền thưởng
    },
    {
      "name": "Tiền đầu tư",
      "icon": Icons.trending_up,
      "color": Colors.greenAccent, // Màu tiền đầu tư
    },
  ];

  IconData getExpenseCategoryIcons(String categoryName) {
    final category = homeExpensesCategories.firstWhere(
        (category) => category['name'] == categoryName,
        orElse: () => {"icon": Icons.home});

    return category['icon'];
  }
}
