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
                padding:
                    const EdgeInsets.symmetric(horizontal: AppPadding.large),
                child: ScrollConfiguration(
                  behavior: const DisableGlowBehavior(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppPadding.large),
                        const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColor.greyScale900,
                          ),
                        ),
                        const SizedBox(height: AppPadding.large),
                        AppTextField(
                          controller: _nameController,
                          hintText: 'Name',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(AppPadding.small),
                            child: Image.asset(
                              AppImage.icPerson,
                              height: 20,
                              width: 20,
                            ),
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
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppPadding.large),
                        AppTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: _isObscureText,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(AppPadding.small),
                            child: Image.asset(
                              AppImage.icKey,
                              height: 20,
                              width: 20,
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
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppPadding.large),
                        AppTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm Password',
                          obscureText: _isObscureText,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(AppPadding.small),
                            child: Image.asset(
                              AppImage.icKey,
                              height: 20,
                              width: 20,
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
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppPadding.large),
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          builder: (context, state) {
                            return CustomAppButton(
                              padding: const EdgeInsets.symmetric(
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
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeCap: StrokeCap.round,
                                      ),
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.white,
                                      ),
                                    ),
                            );
                          },
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
                          padding: const EdgeInsets.symmetric(
                              vertical: AppPadding.medium),
                          splashColor: AppColor.greyScale200,
                          onPressed: () {},
                          radius: AppBorderRadius.r8,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.r8),
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
                                context.go(AppRouter.loginScreenPath);
                              },
                              text: 'Login',
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
