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
  bool _isAuthSuccess = false; // Theo dõi trạng thái đăng nhập
  bool _isCategoriesLoaded = false; // Theo dõi trạng thái tải danh mục
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    // _emailController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (context.read<CategoriesBloc>().state.categories.isNotEmpty) {
      _isCategoriesLoaded = true;
    }

    // Check for saved credentials
    context.read<AuthenticationBloc>().add(CheckSavedCredentialsEvent());
  }

  void _setTextFieldValues(String? email, String? password) {
    if (!_isDisposed && mounted) {
      setState(() {
        if (email != null) _emailController.text = email;
        if (password != null) _passwordController.text = password;
      });
    }
  }

  void _navigateIfReady(BuildContext context) {
    if (_isAuthSuccess && _isCategoriesLoaded) {
      context.read<AppBloc>().add(FetchUserEvent(
          uid: context.read<AuthenticationBloc>().state.user!.uid));
      context.go(AppRouter.splashLoginScreenPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.isLoading.isError) {
              showToast(context, message: state.error!);
            } else if (state.isLoading.isFinished && state.action.isLogin()) {
              _isAuthSuccess = true;
              showToast(context, message: "Đăng nhập thành công");
              _navigateIfReady(context);
            }

            // Fill in saved credentials if available
            if (state.savedEmail != null && state.savedPassword != null) {
              _setTextFieldValues(state.savedEmail, state.savedPassword);
              if (mounted) {
                setState(() {
                  _isRememberMe = state.isRememberMe;
                });
              }
            }
          },
        ),
        BlocListener<CategoriesBloc, CategoriesState>(
          listener: (context, state) {
            if (state.loadingState == LoadingState.finished) {
              _isCategoriesLoaded = true;
              _navigateIfReady(context);
            } else if (state.loadingState == LoadingState.error) {
              showToast(context,
                  message: state.errorMessage ?? 'Lỗi khi tải danh mục');
            }
          },
        ),
      ],
      child: AppContainer(
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  child: Image.asset(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    AppImage.backgroundLogin,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppPadding.small),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.large),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đăng nhập',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
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
                    hintText: 'Mật khẩu',
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
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isRememberMe = !_isRememberMe;
                              });
                            },
                            child: Row(
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
                                  'Ghi nhớ tôi',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.greyScale500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Quên mật khẩu?',
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
                        padding:
                            EdgeInsets.symmetric(vertical: AppPadding.medium),
                        onPressed: () {
                          context.read<AuthenticationBloc>().add(
                                AuthenticationLoginEvent(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  rememberMe: _isRememberMe,
                                ),
                              );
                        },
                        radius: AppBorderRadius.r8,
                        backgroundColor: AppColor.primary500,
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
                                'Đăng nhập',
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
                        'Hoặc',
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
                        'Không có tài khoản?',
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
                        text: 'Đăng ký',
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
          ],
        ),
      ),
    );
  }
}
