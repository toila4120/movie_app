part of '../../authentication.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.isLoading.isError) {
          showToast(context, message: state.error!);
        } else if (state.isLoading.isFinished) {
          context.read<AppBloc>().add(FetchUserEvent(uid: state.user!.uid));
          context.go(AppRouter.splashLoginScreenPath);
        }
      },
      child: AppContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.large),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.greyScale900,
                ),
              ),
              SizedBox(height: AppPadding.large),
              AppTextField(
                controller: _emailController,
                hintText: 'Email',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(AppPadding.small),
                  child: Image.asset(
                    AppImage.icEmail,
                    height: 20.w,
                    width: 20.w,
                  ),
                ),
              ),
              SizedBox(height: AppPadding.large),
              AppTextField(
                controller: _passwordController,
                hintText: 'Password',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(AppPadding.small),
                  child: Image.asset(
                    AppImage.icKey,
                    height: 20.w,
                    width: 20.w,
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
                    height: 20.w,
                    width: 20.w,
                  ),
                ),
                obscureText: _isObscureText,
              ),
              SizedBox(height: AppPadding.medium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        height: 20.w,
                        width: 20.w,
                        child: Center(
                          child: Transform.scale(
                            scale: 20.w / 24,
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
                        ),
                      ),
                      SizedBox(width: AppPadding.superTiny),
                      Text(
                        'Remember me',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.greyScale500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.greyScale500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppPadding.large),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return CustomAppButton(
                    padding: EdgeInsets.symmetric(vertical: AppPadding.medium),
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(
                            AuthenticationLoginEvent(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                            ),
                          );
                    },
                    radius: AppBorderRadius.r8,
                    backgroundColor: AppColor.primary200,
                    child: state.isLoading.isLoading
                        ? SizedBox(
                            height: 16.w,
                            width: 16.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeCap: StrokeCap.round,
                            ),
                          )
                        : Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.white,
                            ),
                          ),
                  );
                },
              ),
              SizedBox(height: AppPadding.medium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
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
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.greyScale500,
                    ),
                  ),
                  SizedBox(width: AppPadding.tiny),
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                      color: AppColor.greyScale200,
                      height: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppPadding.medium),
              const ButtonLoginWithGoogle(),
              SizedBox(height: AppPadding.medium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.greyScale500,
                    ),
                  ),
                  SizedBox(width: AppPadding.superTiny),
                  CustomAppButton(
                    onPressed: () {
                      context.push(AppRouter.registerScreenPath);
                    },
                    text: 'Sign up',
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.primary500,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
