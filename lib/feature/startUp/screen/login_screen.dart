import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramc/core/utils/design_utils.dart';
import 'package:instagramc/core/widgets/core_flat_button.dart';
import 'package:instagramc/core/widgets/text_field_input.dart';
import 'package:instagramc/feature/startUp/screen/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool obscureText = true;
  bool isSigning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: Container(),
              ),
              SvgPicture.asset(
                AppLogos.instagram,
                colorFilter:
                    const ColorFilter.mode(primaryColor, BlendMode.srcIn),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldInput(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: AuthValidator.emailValidator,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFieldInput(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                controller: _passwordController,
                validator: AuthValidator.passwordValidator,
                prefixIcon: Icons.password_outlined,
                obscureText: obscureText,
                suffixIcon: IconButton(
                  icon: Icon(
                    !obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),

              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: CoreFlatButton(
                  text: 'Sign In'.toUpperCase(),
                  isGradientBg: true,
                  onPressed: signIn,
                  isLoading: isSigning,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: AppTextTheme.text18.copyWith(
                          color: primaryColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      ),
                        style: AppTextTheme.text22.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void signIn(){}
  void signUp(){}

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
