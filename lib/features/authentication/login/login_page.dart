import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../music_feed/music_feed.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
            Color.fromARGB(255, 112, 78, 225),
            Color.fromARGB(255, 255, 255, 255),
          ],
              stops: [
            0.1,
            0.5
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _page(),
      ),
    );
  }

  Widget _page() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon(),
            const SizedBox(
              height: 50,
            ),
            _inputField("Username", usernameController),
            const SizedBox(
              height: 50,
            ),
            _inputField("Password", passwordController, isPassword: true),
            const SizedBox(
              height: 50,
            ),
            _loginBtn(),
            const SizedBox(
              height: 50,
            ),
            _extraText()
          ],
        ),
      ),
    );
  }

  Widget _icon() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.person,
        color: Colors.white,
        size: 120,
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {isPassword = false}) {
    var border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: Color.fromARGB(255, 112, 78, 225)));
    return TextField(
      style: const TextStyle(color: Color.fromARGB(255, 112, 78, 225)),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 112, 78, 225)),
        enabledBorder: border,
        focusedBorder: border,
      ),
      obscureText: isPassword,
    );
  }

  Widget _loginBtn() {
    return ElevatedButton(
      onPressed: () {
        debugPrint("Username :" + usernameController.text);
        debugPrint("Password :" + passwordController.text);
      },
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Log in",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        foregroundColor: Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 112, 78, 225),
      ),
    );
  }

  Widget _extraText() {
    return const Text(
      "Can't acees to your account?",
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 16, color: const Color.fromARGB(255, 112, 78, 225)),
    );
  }
}
