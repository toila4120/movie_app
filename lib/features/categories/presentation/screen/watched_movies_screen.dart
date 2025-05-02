import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/config/theme/theme.dart';
import 'package:movie_app/core/widget/widget.dart';
import 'package:movie_app/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:movie_app/features/home/home.dart';

class WatchedMoviesScreen extends StatelessWidget {
  const WatchedMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      resizeToAvoidBottomInset: true,
      child: Column(
        children: [
          const AppHeader(
            title: 'Phim đã xem',
          ),
          Expanded(
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                final watchedMovies = state.user?.watchedMovies ?? [];

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.large,
                    vertical: AppPadding.tiny,
                  ),
                  itemCount: watchedMovies.isEmpty ? 1 : watchedMovies.length,
                  itemBuilder: (context, index) {
                    if (watchedMovies.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppPadding.large),
                          child: const Text(
                            'Bạn chưa xem phim nào',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    }

                    final movie = watchedMovies[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: AppPadding.tiny),
                      child: ItemWatching(
                        watchedMovie: movie,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
