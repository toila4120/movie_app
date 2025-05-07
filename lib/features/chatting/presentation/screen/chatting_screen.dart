part of '../../chatting.dart';

class ChattingScreen extends StatefulWidget {
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // bool _isDebugMode = false;
  bool _hasBlocError = false;
  // String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Debug print
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("ChattingScreen initialized");
      try {
        final chatBloc = context.read<ChatBloc>();
        debugPrint("ChatBloc state: ${chatBloc.state}");
      } catch (e) {
        setState(() {
          _hasBlocError = true;
          // _errorMessage = e.toString();
        });
        debugPrint("ERROR accessing ChatBloc: $e");
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nếu có lỗi với BLoC, hiển thị màn hình lỗi
    if (_hasBlocError) {
      return _buildErrorScreen();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(),
            // Debug panel widget (only in debug mode)
            // if (_isDebugMode) _buildDebugPanel(),
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  // Scroll to bottom when messages change
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });
                },
                builder: (context, state) {
                  return ScrollConfiguration(
                    behavior: const DisableGlowBehavior(),
                    child: ListView(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      children: [
                        if (state.messages.isEmpty) _buildInitialPrompt(),
                        ...state.messages
                            .map((message) => ChatBubble(message: message)),
                        if (state.recommendations.isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'Phim đề xuất:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          ...state.recommendations.map(
                            (movie) => MovieRecommendationCard(movie: movie),
                          ),
                        ],
                        SizedBox(height: 16.h),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80.w,
                  color: Colors.red.shade300,
                ),
                SizedBox(height: 24.h),
                Text(
                  'Không thể tải Movie AI Assistant',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.h),
                Text(
                  'Đã xảy ra lỗi khi khởi tạo trợ lý AI. Vui lòng kiểm tra cài đặt và thử lại sau.',
                  style: TextStyle(fontSize: 14.sp),
                  textAlign: TextAlign.center,
                ),
                // if (_errorMessage != null && _isDebugMode) ...[
                //   SizedBox(height: 24.h),
                //   Container(
                //     padding: EdgeInsets.all(12.w),
                //     decoration: BoxDecoration(
                //       color: Colors.grey.shade200,
                //       borderRadius: BorderRadius.circular(8.r),
                //     ),
                //     child: Text(
                //       'Chi tiết lỗi: $_errorMessage',
                //       style: TextStyle(
                //         fontSize: 12.sp,
                //         fontFamily: 'monospace',
                //       ),
                //     ),
                //   ),
                // ],
                // SizedBox(height: 24.h),
                // ElevatedButton.icon(
                //   onPressed: () {
                //     setState(() {
                //       _isDebugMode = !_isDebugMode;
                //     });
                //   },
                //   icon: Icon(
                //       _isDebugMode ? Icons.visibility_off : Icons.bug_report),
                //   label: Text(_isDebugMode ? 'Ẩn chi tiết' : 'Hiện chi tiết'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildDebugPanel() {
  //   return Container(
  //     width: double.infinity,
  //     color: Colors.amber.withValues(alpha:0.3),
  //     padding: EdgeInsets.all(8.w),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text("DEBUG MODE",
  //             style: TextStyle(fontWeight: FontWeight.bold)),
  //         BlocBuilder<ChatBloc, ChatState>(
  //           builder: (context, state) {
  //             return Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text("Messages: ${state.messages.length}"),
  //                 Text("Recommendations: ${state.recommendations.length}"),
  //                 Text("Is Loading: ${state.isLoading}"),
  //                 Text("Error: ${state.error ?? 'None'}"),
  //               ],
  //             );
  //           },
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             setState(() {
  //               _isDebugMode = false;
  //             });
  //           },
  //           child: const Text("Hide Debug"),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Movie AI Assistant',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Debug button
          // IconButton(
          //   icon: const Icon(Icons.bug_report, size: 18),
          //   onPressed: () {
          //     setState(() {
          //       _isDebugMode = true;
          //     });
          //   },
          // ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              context.read<ChatBloc>().add(ClearChatEvent());
            },
            tooltip: 'Xóa cuộc trò chuyện',
          ),
        ],
      ),
    );
  }

  Widget _buildInitialPrompt() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color:
              Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Movie AI Assistant',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Tôi có thể giúp bạn tìm kiếm phim theo sở thích. Hãy mô tả loại phim bạn muốn xem hoặc đặt câu hỏi. Ví dụ:',
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 12.h),
            _buildSuggestionChip('Tôi muốn xem phim kinh dị Hàn Quốc'),
            _buildSuggestionChip(
                'Gợi ý phim hành động có nhiều cảnh đánh nhau'),
            _buildSuggestionChip('Phim về zombie hay nhất'),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String text) {
    return GestureDetector(
      onTap: () {
        try {
          context.read<ChatBloc>().add(SendMessageEvent(text));
          _messageController.clear();
        } catch (e) {
          debugPrint("ERROR sending message: $e");
          showToast(context, message: "Lỗi: $e");
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 13.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(8.w).copyWith(
            bottom: 8.h + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 3,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Hỏi về phim bạn muốn xem...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.r),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context)
                        .colorScheme
                        .surfaceVariant
                        .withValues(alpha: 0.5),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.send,
                  enabled: !state.isLoading,
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      try {
                        context
                            .read<ChatBloc>()
                            .add(SendMessageEvent(value.trim()));
                        _messageController.clear();
                      } catch (e) {
                        debugPrint("ERROR submitting message: $e");
                        showToast(context, message: "Lỗi: $e");
                      }
                    }
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                width: 48.w,
                height: 48.w,
                child: ElevatedButton(
                  onPressed: state.isLoading
                      ? null
                      : () {
                          final message = _messageController.text.trim();
                          if (message.isNotEmpty) {
                            try {
                              context
                                  .read<ChatBloc>()
                                  .add(SendMessageEvent(message));
                              _messageController.clear();
                            } catch (e) {
                              debugPrint("ERROR sending message: $e");
                              showToast(context, message: "Lỗi: $e");
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(12.w),
                    backgroundColor: AppColor.primary600,
                    foregroundColor: AppColor.white,
                  ),
                  child: state.isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Icon(Icons.send, size: 20.sp),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
