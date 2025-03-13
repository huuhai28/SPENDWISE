import 'package:flutter/material.dart';
import 'package:hai123/screen/login_screen.dart';
import '../model/colors.dart';
import '../service/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.auth}) : super(key: key);
  final AuthenticationDatasource auth;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Nguyễn Hữu Hải";
  String email = "nguyenhai281103@gmail.com";
  String location = "Hà Nội, Việt Nam";

  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _editProfile() {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);
    TextEditingController locationController =
        TextEditingController(text: location);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColors, // Đồng bộ màu nền
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Chỉnh sửa thông tin",
            style: TextStyle(color: primary), // Dùng primary cho tiêu đề
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Họ và tên",
                  labelStyle: TextStyle(color: second),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primary!),
                  ),
                ),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: second),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primary!),
                  ),
                ),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: "Địa chỉ",
                  labelStyle: TextStyle(color: second),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: primary!),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Hủy",
                style: TextStyle(color: second),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                  location = locationController.text;
                });
                Navigator.pop(context);
              },
              child: const Text("Lưu", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('images/profile_picture.png'),
              backgroundColor: custom_green,
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              email,
              style: TextStyle(
                  fontSize: 16, color: Colors.grey[800]), // Tăng độ đậm
            ),
            Text(
              location,
              style: TextStyle(
                  fontSize: 14, color: Colors.grey[800]), // Tăng độ đậm
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: second,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _editProfile,
              icon: const Icon(Icons.edit, size: 18, color: Colors.white),
              label: const Text(
                "Chỉnh sửa thông tin",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            _buildCard(
              title: "Cài đặt",
              icon: Icons.settings,
              children: [
                _buildListTile(Icons.notifications, "Thông báo"),
                _buildListTile(Icons.payment, "Phương thức thanh toán"),
                _buildListTile(Icons.security, "Bảo mật"),
              ],
            ),
            const SizedBox(height: 80),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary, // Thay Colors.redAccent bằng primary
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _signOut,
              icon: const Icon(Icons.logout, size: 18, color: Colors.white),
              label: const Text(
                "Đăng xuất",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: custom_green), // Dùng custom_green cho icon
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          Divider(color: second), // Dùng second cho divider
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: custom_green), // Dùng custom_green cho icon
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: second),
      onTap: () {},
    );
  }
}
