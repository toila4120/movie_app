import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/enum/loading_state.dart';
import 'package:movie_app/core/utils/show_toast.dart';
import 'package:movie_app/core/widget/widget.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthenticationBloc>().add(
          AuthenticationForgotPasswordEvent(
            email: _emailController.text.trim(),
          ),
        );
  }

  @override
  void dispose() {
    // _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.action.isForgotPassword()) {
          if (state.isLoading == LoadingState.loading) {
            // Đang xử lý, không cần làm gì
          } else if (state.isLoading == LoadingState.error &&
              state.error != null) {
            // Chỉ hiển thị lỗi khi có error và state là error
            showToast(context, message: state.error!);
          } else if (state.isLoading == LoadingState.finished) {
            showToast(context,
                message:
                    "Đã gửi email đặt lại mật khẩu. Vui lòng kiểm tra hộp thư của bạn.");
            Navigator.pop(context);
          }
        }
      },
      child: AppContainer(
        resizeToAvoidBottomInset: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const AppHeader(
              title: 'Quên mật khẩu',
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppPadding.large,
                vertical: AppPadding.large,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Nhập email của bạn để đặt lại mật khẩu',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: AppPadding.large),
                    AppTextField(
                      controller: _emailController,
                      hintText: 'Email',
                      textInputType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      onSubmitted: (_) => _resetPassword(),
                    ),
                    SizedBox(height: AppPadding.large),
                    BlocBuilder<AuthenticationBloc, AuthenticationState>(
                      buildWhen: (previous, current) =>
                          previous.isLoading != current.isLoading &&
                          current.action.isForgotPassword(),
                      builder: (context, state) {
                        return CustomAppButton(
                          text: 'Gửi email đặt lại mật khẩu',
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            vertical: AppPadding.medium,
                          ),
                          radius: AppBorderRadius.r16,
                          backgroundColor: AppColor.primary500,
                          textColor: Colors.white,
                          onPressed: state.isLoading == LoadingState.loading
                              ? null
                              : _resetPassword,
                          child: state.isLoading == LoadingState.loading
                              ? SizedBox(
                                  height: 16.w,
                                  width: 16.w,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeCap: StrokeCap.round,
                                  ),
                                )
                              : Text(
                                  'Gửi email đặt lại mật khẩu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
