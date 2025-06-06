part of '../../authentication.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isObscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.isLoading.isError) {
          if (state.error != null) {
            showToast(context, message: state.error!);
          } else {
            showToast(context, message: 'Đã xảy ra lỗi không xác định');
          }
        } else if (state.isLoading.isFinished && state.action.isRegister()) {
          context.read<AppBloc>().add(FetchUserEvent(uid: state.user!.uid));
          context.go(AppRouter.selectGenreScreenPath);
        }
      },
      child: AppContainer(
        resizeToAvoidBottomInset: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.large,
                  vertical: AppPadding.large,
                ),
                child: ScrollConfiguration(
                  behavior: const DisableGlowBehavior(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đăng ký',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: AppPadding.large),
                        AppTextField(
                          controller: _nameController,
                          hintText: 'Tên',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(AppPadding.small),
                            child: Image.asset(
                              AppImage.icPerson,
                              height: 20.w,
                              width: 20.w,
                            ),
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
                          obscureText: _isObscureText,
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
                              _isObscureText
                                  ? AppImage.icEyeOff
                                  : AppImage.icEye,
                              height: 20.w,
                              width: 20.w,
                            ),
                          ),
                        ),
                        SizedBox(height: AppPadding.large),
                        AppTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Xác nhận mật khẩu',
                          obscureText: _isObscureText,
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
                              _isObscureText
                                  ? AppImage.icEyeOff
                                  : AppImage.icEye,
                              height: 20.w,
                              width: 20.w,
                            ),
                          ),
                        ),
                        SizedBox(height: AppPadding.large),
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          builder: (context, state) {
                            return CustomAppButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: AppPadding.medium),
                              onPressed: () {
                                context.read<AuthenticationBloc>().add(
                                      AuthenticationRegisterEvent(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                        passwordConfirm:
                                            _confirmPasswordController.text,
                                      ),
                                    );
                              },
                              radius: AppBorderRadius.r8,
                              backgroundColor: AppColor.primary500,
                              child: state.isLoading.isLoading
                                  ? SizedBox(
                                      height: 20.w,
                                      width: 20.w,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeCap: StrokeCap.round,
                                      ),
                                    )
                                  : Text(
                                      'Đăng ký',
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
                              'Đã có tài khoản?',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.greyScale500,
                              ),
                            ),
                            SizedBox(width: AppPadding.superTiny),
                            CustomAppButton(
                              onPressed: () {
                                context.go(AppRouter.loginScreenPath);
                              },
                              text: 'Đăng nhập',
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
