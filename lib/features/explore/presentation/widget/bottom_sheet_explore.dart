part of '../../explore.dart';

class BottomSheetExplore extends StatelessWidget {
  const BottomSheetExplore({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.medium),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppBorderRadius.r20.w),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Center(
              child: Container(
                height: 4,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                "Sắp xếp và lọc",
                style: TextStyle(
                  color: AppColor.primary500,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.w,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: Colors.grey, thickness: 1),
            const SizedBox(height: 8),
            const Text(
              "Loại phim",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const ContainerLoaiPhim(),
            const SizedBox(height: 16),
            const Text(
              "Thể loại",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const ContainerTheLoai(),
            const SizedBox(height: 16),
            const Text(
              "Dịch thuật",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const ContainerDichThuat(),
            const SizedBox(height: 16),
            const Text(
              "Năm sản xuất",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const ContainerYear(),
            const SizedBox(height: 16),
            const Text(
              "Quốc gia",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const ContainerRegion(),
            const SizedBox(height: 16),
            const Text(
              "Sắp xếp",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const ContainerSort(),
            const SizedBox(height: 8),
            const Divider(color: Colors.grey, thickness: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: CustomAppButton(
                      onPressed: () {
                        context.read<ExploreBloc>().add(ResetFilterEvent());
                      },
                      padding: EdgeInsets.symmetric(
                        vertical: AppPadding.medium,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primary50,
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.r16.w),
                      ),
                      child: Text(
                        "Làm mới",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColor.primary500,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                ),
                SizedBox(width: AppPadding.medium),
                Expanded(
                  child: CustomAppButton(
                      onPressed: () {
                        context
                            .read<ExploreBloc>()
                            .add(const FilterMovieEvent(1));
                        context.pop();
                      },
                      padding: EdgeInsets.symmetric(
                        vertical: AppPadding.medium,
                      ),
                      decoration: BoxDecoration(
                        color: AppColor.primary500,
                        borderRadius:
                            BorderRadius.circular(AppBorderRadius.r16.w),
                      ),
                      child: Text(
                        "Áp dụng",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColor.white,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                )
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
