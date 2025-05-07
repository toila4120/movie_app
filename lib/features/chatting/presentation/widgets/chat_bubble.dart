import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/chatting/domain/entities/chat_message.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = message.sender == MessageSender.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 0.7.sw,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 8.h,
        ),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isUser
              ? theme.splashColor.withValues(alpha: 0.2)
              : theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: theme.primaryColorLight,
          ),
        ),
        child: message.isLoading
            ? _buildLoadingIndicator(theme)
            : Text(
                message.message,
                style: TextStyle(
                  color: theme.primaryColorDark,
                  fontSize: 14.sp,
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message.message,
          style: TextStyle(
            color: theme.primaryColorDark,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(width: 8.w),
        SizedBox(
          width: 12.w,
          height: 12.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.primaryColorDark,
            ),
          ),
        ),
      ],
    );
  }
}
