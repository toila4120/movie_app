import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/config/theme/theme.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLength;

  const ExpandableText({
    super.key,
    required this.text,
    this.maxLength = 120,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    String firstPart = widget.text;

    if (widget.text.length > widget.maxLength) {
      firstPart = widget.text.substring(0, widget.maxLength);
    }
    if (widget.text.length < widget.maxLength) {
      isExpanded = true;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: AppColor.greyScale900,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(text: isExpanded ? widget.text : "$firstPart... "),
            if (!isExpanded)
              TextSpan(
                text: "Thêm",
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      isExpanded = true;
                    });
                  },
              ),
          ],
        ),
      ),
    );
  }
}
