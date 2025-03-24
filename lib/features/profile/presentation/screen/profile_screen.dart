part of '../../profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      resizeToAvoidBottomInset: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomAppButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              context.go(AppRouter.loginScreenPath);
            },
            text: 'Logout',
          ),
        ],
      ),
    );
  }
}
