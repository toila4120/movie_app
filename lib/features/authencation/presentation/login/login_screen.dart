import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/constants/app_image.dart';
import 'package:movie_app/core/widget/widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isRememberMe = false;
  bool _isObscureText = true;
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
                  )),
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
            CustomAppButton(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.medium),
              onPressed: () {
                context.go(AppRouter.homeTabPath);
              },
              radius: AppBorderRadius.r8,
              backgroundColor: AppColor.primary200,
              child: const Text(
                'Login',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColor.white),
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
              onPressed: () {},
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
                  onPressed: () {},
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
