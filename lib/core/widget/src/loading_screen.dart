part of '../widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppImage.loadingAnimation,
              gaplessPlayback: true,
            ),
            const SizedBox(height: 20),
            Text(
              'Đang tải dữ liệu...',
              style: TextStyle(
                fontSize: 18.w,
                // color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
