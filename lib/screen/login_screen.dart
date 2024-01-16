import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramc/core/server/auth_methods.dart';
import 'package:instagramc/core/utils/design_utils.dart';
import 'package:instagramc/core/widgets/core_flat_button.dart';
import 'package:instagramc/core/widgets/text_field_input.dart';
import 'package:instagramc/screen/responsive/mobile_screen_layout.dart';
import 'package:instagramc/screen/responsive/responsive_layout.dart';
import 'package:instagramc/screen/responsive/web_screen_layout.dart';
import 'package:instagramc/screen/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final signInFormKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _isSigning = false;
  bool _readOnly = false;

  @override
  void initState(){
    super.initState();
    // defaultUser();
  }

  void defaultUser(){
    setState(() {
      _emailController.text = "rashad@gmail.com";
      _passwordController.text = "123456";
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:
        width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
      body: SafeArea(
        child: Container(
          padding:  width > webScreenSize
              ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Form(
            key: signInFormKey,
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
                  readOnly: _readOnly,
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
                  readOnly: _readOnly,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  controller: _passwordController,
                  validator: AuthValidator.passwordValidator,
                  prefixIcon: Icons.password_outlined,
                  obscureText: _obscureText,
                  suffixIcon: IconButton(
                    icon: Icon(
                      !_obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
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
                    onPressed: ()=> signIn(buildContext: context),
                    isLoading: _isSigning,
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
                          recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pushReplacement(
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
      ),
    );
  }
  Future<void> signIn({required BuildContext buildContext}) async {
    setState(() {
      _isSigning = true;
      _readOnly = true;
    });
    if (signInFormKey.currentState!.validate())  {

      String message = await AuthMethods().loginUser(
          email: _emailController.text, password: _passwordController.text);
        if (message == success) {

          // navigate to the home screen
          if (buildContext.mounted) {
            Navigator.of(buildContext).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                ),
              ),
            );
            setState(() {
              _isSigning = false;
              _readOnly = false;
            });
          }
        } else {
          setState(() {
            _isSigning = false;
            _readOnly = false;
          });
          // show the error
          if (buildContext.mounted) {
            showSnackBar(buildContext, message);
          }
        }

    } else {
      setState(() {
        _isSigning = false;
        _readOnly = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
}
