part of '../../authencation.dart';

class ButtonLoginWithGoogle extends StatelessWidget {
  const ButtonLoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomAppButton(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.medium),
      splashColor: AppColor.greyScale200,
      onPressed: () {
        context
            .read<AuthenticationBloc>()
            .add(AuthenticationGoogleLoginEvent());
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
    );
  }
}
