// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:hai123/model/icons_list.dart';

class CategoryDropdown extends StatelessWidget {
  CategoryDropdown({
    super.key,
    this.cattype,
    required this.onChanged,
  });
  final String? cattype;
  final ValueChanged<String?> onChanged;
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: cattype,
        isExpanded: true,
        hint: const Text("Select Category"),
        items: appIcons.homeExpensesCategories
            .map((e) => DropdownMenuItem<String>(
                value: e['name'],
                child: Row(
                  children: [
                    Icon(
                      e['icon'],
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      e['name'],
                      style: const TextStyle(
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )))
            .toList(),
        onChanged: onChanged);
  }
}
