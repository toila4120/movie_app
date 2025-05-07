import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_app/config/router/app_router.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/features/chatting/domain/entities/movie_recommendation.dart';
import 'package:movie_app/features/movie/presentation/bloc/movie_bloc.dart';

class MovieRecommendationCard extends StatelessWidget {
  final MovieRecommendation movie;

  const MovieRecommendationCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      color: theme.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: theme.primaryColorLight,
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: InkWell(
        onTap: () => _navigateToMovieDetails(context),
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                movie.description,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: theme.textTheme.bodySmall?.color,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _navigateToMovieDetails(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primary600,
                    foregroundColor: AppColor.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                  ),
                  child: const Text('Xem chi tiết'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMovieDetails(BuildContext context) {
    context.read<MovieBloc>().add(FetchMovieDetailEvent(slug: movie.slug));
    context.push(AppRouter.movieDetailPath);
  }
}
