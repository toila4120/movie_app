part of '../../authencation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRememberMe = false;
  bool _isObscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _errorMessage;

  Future<void> _loginWithEmail() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (userCredential.user != null) {
        if (mounted) {
          context.go(AppRouter.homeTabPath);
        }
      } else {
        setState(() {
          _errorMessage = "Login failed: No user data returned.";
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.code);
      });
    } catch (e, stackTrace) {
      setState(() {
        _errorMessage = "Unexpected error: $e";
      });
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        print("User logged in with Google: ${userCredential.user!.uid}");
        if (mounted) {
          print("Navigating to ${AppRouter.homeTabPath}");
          context.go(AppRouter.homeTabPath);
        }
      } else {
        setState(() {
          _errorMessage = "Google login failed: No user data returned.";
        });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e.code);
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Unexpected error: $e";
      });
      print("Detailed error: $e");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppPadding.large),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColor.greyScale900,
              ),
            ),
            const SizedBox(height: AppPadding.large),
            AppTextField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(AppPadding.small),
                child: Image.asset(
                  AppImage.icEmail,
                  height: 24,
                  width: 24,
                ),
              ),
            ),
            const SizedBox(height: AppPadding.large),
            AppTextField(
              controller: _passwordController,
              hintText: 'Password',
              prefixIcon: Padding(
                padding: const EdgeInsets.all(AppPadding.small),
                child: Image.asset(
                  AppImage.icKey,
                  height: 24,
                  width: 24,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
                icon: Image.asset(
                  _isObscureText ? AppImage.icEyeOff : AppImage.icEye,
                  height: 20,
                  width: 20,
                ),
              ),
              obscureText: _isObscureText,
            ),
            const SizedBox(height: AppPadding.medium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: Checkbox(
                        value: _isRememberMe,
                        onChanged: (value) {
                          setState(() {
                            _isRememberMe = value!;
                          });
                        },
                        shape: const CircleBorder(),
                        activeColor: AppColor.primary400,
                        checkColor: AppColor.white,
                        side: const BorderSide(
                          color: AppColor.greyScale300,
                          width: 1,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppPadding.superTiny),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.greyScale500,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.greyScale500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppPadding.large),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: AppPadding.medium),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            CustomAppButton(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.medium),
              onPressed: _loginWithEmail,
              radius: AppBorderRadius.r8,
              backgroundColor: AppColor.primary200,
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColor.white,
                ),
              ),
            ),
            const SizedBox(height: AppPadding.medium),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: AppColor.greyScale200,
                    height: 1,
                  ),
                ),
                SizedBox(width: AppPadding.tiny),
                Text(
                  'Or',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.greyScale500,
                  ),
                ),
                SizedBox(width: AppPadding.tiny),
                Expanded(
                  child: Divider(
                    thickness: 1,
                    color: AppColor.greyScale200,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppPadding.medium),
            CustomAppButton(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.medium),
              splashColor: AppColor.greyScale200,
              onPressed: _loginWithGoogle,
              radius: AppBorderRadius.r8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppBorderRadius.r8),
                border: Border.all(
                  color: AppColor.greyScale200,
                ),
              ),
              backgroundColor: AppColor.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImage.icGoogle,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: AppPadding.tiny),
                  const Text(
                    'Login with Google',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColor.greyScale900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppPadding.medium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.greyScale500,
                  ),
                ),
                const SizedBox(width: AppPadding.superTiny),
                CustomAppButton(
                  onPressed: () {
                    context.go(AppRouter.registerScreenPath);
                  },
                  text: 'Sign up',
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primary500,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
