import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramc/core/responsive/mobile_screen_layout.dart';
import 'package:instagramc/core/responsive/responsive_layout.dart';
import 'package:instagramc/core/responsive/web_screen_layout.dart';
import 'package:instagramc/core/utils/design_utils.dart';
import 'package:instagramc/core/widgets/core_flat_button.dart';
import 'package:instagramc/core/widgets/text_field_input.dart';
import 'package:instagramc/feature/startUp/screen/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // // signup user using our authmethodds
    // String res = await AuthMethods().signUpUser(
    //     email: _emailController.text,
    //     password: _passwordController.text,
    //     username: _usernameController.text,
    //     bio: _bioController.text,
    //     file: _image!);
    // // if string returned is sucess, user has been created
    // if (res == "success") {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   // navigate to the home screen
    //   if (context.mounted) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(
    //         builder: (context) => const ResponsiveLayout(
    //           mobileScreenLayout: MobileScreenLayout(),
    //           webScreenLayout: WebScreenLayout(),
    //         ),
    //       ),
    //     );
    //   }
    // } else {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   // show the error
    //   if (context.mounted) {
    //     // showSnackBar(context, res);
    //   }
    // }
  }

  selectImage() async {
    // Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      // _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                AppLogos.instagram,
                colorFilter:
                const ColorFilter.mode(primaryColor, BlendMode.srcIn),
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                    backgroundColor: primaryColor,
                  )
                      : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(
                        'https://i.stack.imgur.com/l60Hf.png'),
                    backgroundColor: secondaryColor,
                  ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your username',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: _usernameController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your bio',
                keyboardType: TextInputType.text,
                controller: _bioController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: AuthValidator.emailValidator,
                controller: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                keyboardType: TextInputType.text,
                validator: AuthValidator.passwordValidator,
                controller: _passwordController,
                obscureText: _obscurePasswordText,
                suffixIcon: IconButton(
                  icon: Icon(
                    !_obscurePasswordText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePasswordText = !_obscurePasswordText;
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Confirm your password',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                validator: AuthValidator.passwordValidator,
                controller: _passwordController,
                obscureText: _obscureConfirmPasswordText,
                suffixIcon: IconButton(
                  icon: Icon(
                    !_obscureConfirmPasswordText ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPasswordText = !_obscureConfirmPasswordText;
                    });
                  },
                ),
              ),

              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: CoreFlatButton(
                  text: 'Sign Up'.toUpperCase(),
                  isGradientBg: true,
                  onPressed: signUpUser,
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Already have an account?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Login.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }
}
