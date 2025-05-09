part of '../../authentication.dart';

class ButtonLoginWithGoogle extends StatelessWidget {
  const ButtonLoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    // Truy cập trạng thái "Remember me" từ state của LoginScreen
    final loginScreenState =
        context.findAncestorStateOfType<_LoginScreenState>();
    final isRememberMe = loginScreenState?._isRememberMe ?? false;

    print("Remember me status for Google login: $isRememberMe");

    return CustomAppButton(
      padding: EdgeInsets.symmetric(vertical: AppPadding.medium),
      splashColor: AppColor.greyScale200,
      onPressed: () {
        print("Đăng nhập Google với Remember me: $isRememberMe");
        context
            .read<AuthenticationBloc>()
            .add(AuthenticationGoogleLoginEvent(rememberMe: isRememberMe));
      },
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
            height: 24.w,
            width: 24.w,
          ),
          SizedBox(width: AppPadding.tiny),
          Text(
            'Login with Google',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.greyScale900,
            ),
          ),
        ],
      ),
    );
  }
}
