import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramc/core/server/auth_methods.dart';
import 'package:instagramc/core/utils/design_utils.dart';
import 'package:instagramc/core/widgets/core_flat_button.dart';
import 'package:instagramc/core/widgets/text_field_input.dart';
import 'package:instagramc/screen/login_screen.dart';
import 'package:instagramc/screen/responsive/mobile_screen_layout.dart';
import 'package:instagramc/screen/responsive/responsive_layout.dart';
import 'package:instagramc/screen/responsive/web_screen_layout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  bool _readOnly = false;
  Uint8List? _image;

  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;

  final signUpFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // defaultUser();
  }

  void defaultUser() {
    setState(() {
      _usernameController.text = "Rashaduzzaman Ananda";
      _bioController.text = "Flutter Developer";
      _emailController.text = "rashad@gmail.com";
      _passwordController.text = "123456";
      _confirmPasswordController.text = "123456";
    });
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
      _readOnly = true;
    });
    if (signUpFormKey.currentState!.validate() && _image != null) {
      if (_passwordController.text != _confirmPasswordController.text) {
        // "Password and Confirm Password didn't match".errorSnackBar();
        showSnackBar(context, "Password and Confirm Password didn't match");
      } else {
        String message = await AuthMethods().registrationInFirebase(
            userName: _usernameController.text,
            userBio: _bioController.text,
            userEmail: _emailController.text,
            userPassword: _passwordController.text,
            file: _image!);
        if (message == success) {
          setState(() {
            _isLoading = false;
            _readOnly = false;
          });
          // navigate to the home screen
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                ),
              ),
            );
          }
        } else {
          setState(() {
            _isLoading = false;
            _readOnly = false;
          });
          // show the error
          if (context.mounted) {
            showSnackBar(context, message);
          }
        }
      }
    } else if (signUpFormKey.currentState!.validate() && _image == null) {
      showSnackBar(context, "Select Profile Picture");
      setState(() {
        _isLoading = false;
        _readOnly = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _readOnly = false;
      });
    }
  }

  selectImage() async {
    Uint8List pickedImage = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Form(
              key: signUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                    readOnly: _readOnly,
                    hintText: 'Enter your username',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    controller: _usernameController,
                    validator: AuthValidator.nameValidator,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    readOnly: _readOnly,
                    hintText: 'Enter your bio',
                    keyboardType: TextInputType.text,
                    controller: _bioController,
                    validator: AuthValidator.emptyNullValidator,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFieldInput(
                    readOnly: _readOnly,
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
                    readOnly: _readOnly,
                    hintText: 'Enter your password',
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    validator: AuthValidator.passwordValidator,
                    controller: _passwordController,
                    obscureText: _obscurePasswordText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_obscurePasswordText
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                    readOnly: _readOnly,
                    hintText: 'Confirm your password',
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    validator: AuthValidator.passwordValidator,
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPasswordText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        !_obscureConfirmPasswordText
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPasswordText =
                              !_obscureConfirmPasswordText;
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
                      onPressed: () => signUpUser(),
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
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
