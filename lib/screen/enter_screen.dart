import 'package:flutter/material.dart';
import 'package:hai123/model/icons_list.dart';
import '../model/colors.dart';
import '../service/firetor.dart';
import '../widgets/datepicker.dart';

class EnterScreen extends StatefulWidget {
  const EnterScreen({super.key});

  @override
  State<EnterScreen> createState() => _EnterScreenState();
}

class _EnterScreenState extends State<EnterScreen> {
  bool type = true;
  List<bool> isSelectedd = [false, true];
  var selectCategoryIndex = AppIcons().homeExpensesCategories[0]['name'];
  DateTime selectedDate = DateTime.now();
  final datepicker = Datepicker();
  final title = TextEditingController();
  final amount = TextEditingController();
  final FireStore_Datasource firestoreDatasource = FireStore_Datasource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColors,
        title: Column(
          children: [
            button(),
            const SizedBox(height: 5),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            line(),
            ListTile(
              leading: leading("Ngày"),
              title: TextButton(
                onPressed: () => datepicker.showCupertinoDatePicker(
                    context, selectedDate, (DateTime newDate) {
                  setState(() {
                    selectedDate = newDate;
                  });
                }),
                child: Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            line(),
            ListTile(
              leading: leading("Ghi chú"),
              title: textfield("Nhập ghi chú", title),
            ),
            line(),
            ListTile(
              leading: leading("Tiền"),
              title: textfield("Nhập số tiền", amount),
            ),
            line(),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Danh mục",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: category(),
            ),
            Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsetsDirectional.symmetric(horizontal: 20),
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: () async {
                    if (title.text.isNotEmpty &&
                        amount.text.isNotEmpty &&
                        int.tryParse(amount.text) != null) {
                      try {
                        firestoreDatasource.AddExpense(
                          title.text,
                          type,
                          int.parse(amount.text),
                          selectCategoryIndex.toString(),
                          selectedDate,
                        );
                        title.clear();
                        amount.clear();
                      } catch (e) {
                        print("Lỗi khi thêm dữ liệu: $e");
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Vui lòng nhập đầy đủ thông tin hợp lệ!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  child: const Center(
                      child: Text(
                    "Lưu",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                )),
          ],
        ),
      ),
    );
  }

  Widget textfield(String text, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: text,
        hintStyle: TextStyle(color: Colors.grey[400]),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  Widget leading(String text) {
    return SizedBox(
      width: 55,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }

  Widget button() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      child: ToggleButtons(
        isSelected: isSelectedd,
        onPressed: (index) {
          setState(() {
            for (int i = 0; i < isSelectedd.length; i++) {
              isSelectedd[i] = i == index;
            }
            type = index != 0; // false: chi, true: thu
            print("Loại giao dịch: $type"); // Kiểm tra giá trị
          });
        },
        borderRadius: BorderRadius.circular(8),
        selectedColor: Colors.white,
        fillColor: primary,
        color: primary,
        borderColor: Colors.grey[300],
        selectedBorderColor: primary,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
            child: Text(
              "Tiền chi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
            child: Text(
              "Tiền thu",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget category() {
    var appIcon = AppIcons().homeExpensesCategories;
    return SizedBox(
      height: 300,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 10,
          childAspectRatio: 1.9,
        ),
        itemCount: appIcon.length,
        itemBuilder: (context, index) {
          final category = appIcon[index];
          final isSelected = selectCategoryIndex == category['name'];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectCategoryIndex = category['name'];
              });
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: isSelected ? primary! : Colors.grey,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    category['icon'],
                    size: 30,
                    color: category['color'],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    category['name'],
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget line() {
    return Container(
      height: 0.5,
      width: double.infinity,
      color: Colors.grey,
    );
  }
}
