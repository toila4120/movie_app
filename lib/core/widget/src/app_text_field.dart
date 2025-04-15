part of '../widget.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? prefixIcon, suffixIcon;
  final String hintText;
  final bool obscureText;
  final bool enabled;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputType? textInputType;
  final int? maxLength;
  final Function(String)? onTextChange, onSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.hintText = "",
    this.obscureText = false,
    this.enabled = true,
    this.focusNode,
    this.nextFocusNode,
    this.textInputType,
    this.onTextChange,
    this.onSubmitted,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onTextChange,
      onSubmitted: widget.onSubmitted,
      focusNode: _focusNode,
      maxLines: widget.maxLength ?? 1,
      minLines: 1,
      inputFormatters: widget.inputFormatters,
      style: TextStyle(
        // color: AppColor.secondLight,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
      ),
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(
          left: widget.prefixIcon == null ? AppPadding.large : 0.0,
          right: widget.suffixIcon == null ? AppPadding.large : 0.0,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.r16.w),
          borderSide: const BorderSide(
            color: AppColor.blue,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.r16.w),
          borderSide: const BorderSide(
            color: AppColor.buttonDisabled,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.r16.w),
          borderSide: const BorderSide(
            color: AppColor.buttonDisabled,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.r16.w),
          borderSide: const BorderSide(
            color: AppColor.buttonDisabled,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.r16.w),
          borderSide: const BorderSide(
            color: AppColor.red,
          ),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: AppColor.subsidiaryLight,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
      ),
      enabled: widget.enabled,
      autofocus: false,
      showCursor: true,
      cursorColor: AppColor.blue,
      cursorErrorColor: AppColor.red,
      cursorRadius: const Radius.circular(60),
      keyboardType: widget.textInputType ?? TextInputType.text,
      textInputAction: widget.nextFocusNode == null
          ? TextInputAction.done
          : TextInputAction.next,
    );
  }
}
