import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Background(
      child: SingleChildScrollView(
        child: SafeArea(child: MobileWelcomeScreen()),
      ),
    );
  }
}

class MobileWelcomeScreen extends StatelessWidget {
  const MobileWelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const WelcomeImage(),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: const [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginAndSignupBtn(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "WELCOME TO OCR APP",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto",
            fontSize: 24,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            const Spacer(),
            Expanded(
              flex: 8,
              child: Image.asset(
                'assets/images/ocr.jpg',
                fit: BoxFit.cover,
              ),
            ),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key? key,
    required this.child,
    this.topImage = "assets/images/main_top.png",
    this.bottomImage = "assets/images/login_bottom.png",
  }) : super(key: key);

  final String topImage, bottomImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset(
                topImage,
                width: 120,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(bottomImage, width: 120),
            ),
            SafeArea(child: child),
          ],
        ),
      ),
    );
  }
}

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Hero(
          tag: "login_btn",
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black)),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  "Login".toUpperCase(),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const SignUpScreen();
                },
              ),
            );
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(color: Colors.black),
              ),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            overlayColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black.withOpacity(0.5);
                } else {
                  return Colors.black.withOpacity(0.2);
                }
              },
            ),
            elevation: MaterialStateProperty.all<double>(5),
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            textStyle: MaterialStateProperty.all<TextStyle>(
              const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            shadowColor:
                MaterialStateProperty.all<Color>(Colors.grey.withOpacity(0.5)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Center(
              child: Text(
                "Sign Up".toUpperCase(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
