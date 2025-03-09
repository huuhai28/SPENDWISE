import 'package:flutter/material.dart';
import '../model/colors.dart';
import '../service/auth_service.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(height: 100),
                image(),
                const SizedBox(height: 20),
                textfield(emailController, "Email", Icons.email),
                const SizedBox(height: 20),
                textfield(passwordController, "Mật Khẩu", Icons.key_sharp),
                const SizedBox(height: 20),
                textfield(
                    confirmController, "Nhập lại mật khẩu", Icons.key_sharp),
                const SizedBox(height: 5),
                account(context),
                const SizedBox(height: 20),
                register(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget register(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final AuthenticationDatasource authService = AuthenticationRemote();
        String email = emailController.text;
        String password = passwordController.text;
        String confirmPassWord = confirmController.text;
        try {
          await authService.register(email, password, confirmPassWord);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                "Đăng ký thành công",
                style: TextStyle(fontSize: 20),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        } catch (e) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                "Tài khoản đã tồn tại",
                style: TextStyle(fontSize: 20),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: custom_green,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'Đăng ký',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget account(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          "Bạn đã có tài khoản?",
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: const Text(
            'Đăng nhập',
            style: TextStyle(
                color: Colors.orange,
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget textfield(
      TextEditingController controller, String typeName, IconData iconss) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: controller,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
              prefixIcon: Icon(
                iconss,
                color: custom_green,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: typeName,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: custom_green,
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: custom_green,
                  width: 2.0,
                ),
              )),
        ),
      ),
    );
  }

  Widget image() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: backgroundColors,
          image: const DecorationImage(
            image: AssetImage('images/5.png'),
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
