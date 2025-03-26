part of '../../authencation.dart';

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
          showToast(context, message: state.error!);
        } else if (state.isLoading.isFinished) {
          context.go(AppRouter.homeTabPath);
        }
      },
      child: AppContainer(
        resizeToAvoidBottomInset: true,
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.large,
                  vertical: AppPadding.large,
                ),
                child: ScrollConfiguration(
                  behavior: const DisableGlowBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: TextStyle(
                            fontSize: SizeConfig.getResponsive(24),
                            fontWeight: FontWeight.w700,
                            color: AppColor.greyScale900,
                          ),
                        ),
                        SizedBox(height: AppPadding.large),
                        AppTextField(
                          controller: _nameController,
                          hintText: 'Name',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(AppPadding.small),
                            child: Image.asset(
                              AppImage.icPerson,
                              height: SizeConfig.getResponsive(20),
                              width: SizeConfig.getResponsive(20),
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
                              height: SizeConfig.getResponsive(20),
                              width: SizeConfig.getResponsive(20),
                            ),
                          ),
                        ),
                        SizedBox(height: AppPadding.large),
                        AppTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: _isObscureText,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(AppPadding.small),
                            child: Image.asset(
                              AppImage.icKey,
                              height: SizeConfig.getResponsive(20),
                              width: SizeConfig.getResponsive(20),
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
                              height: SizeConfig.getResponsive(20),
                              width: SizeConfig.getResponsive(20),
                            ),
                          ),
                        ),
                        SizedBox(height: AppPadding.large),
                        AppTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm Password',
                          obscureText: _isObscureText,
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(AppPadding.small),
                            child: Image.asset(
                              AppImage.icKey,
                              height: SizeConfig.getResponsive(20),
                              width: SizeConfig.getResponsive(20),
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
                              height: SizeConfig.getResponsive(20),
                              width: SizeConfig.getResponsive(20),
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
                                context
                                    .read<AuthenticationBloc>()
                                    .add(AuthenticationRegisterEvent(
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      passwordConfirm:
                                          _confirmPasswordController.text,
                                    ));
                              },
                              radius: AppBorderRadius.r8,
                              backgroundColor: AppColor.primary200,
                              child: state.isLoading.isLoading
                                  ? SizedBox(
                                      height: SizeConfig.getResponsive(20),
                                      width: SizeConfig.getResponsive(20),
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeCap: StrokeCap.round,
                                      ),
                                    )
                                  : Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: SizeConfig.getResponsive(14),
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
                                fontSize: SizeConfig.getResponsive(14),
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
                                fontSize: SizeConfig.getResponsive(14),
                                fontWeight: FontWeight.w500,
                                color: AppColor.greyScale500,
                              ),
                            ),
                            SizedBox(width: AppPadding.superTiny),
                            CustomAppButton(
                              onPressed: () {
                                context.go(AppRouter.loginScreenPath);
                              },
                              text: 'Login',
                              textStyle: TextStyle(
                                fontSize: SizeConfig.getResponsive(14),
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
