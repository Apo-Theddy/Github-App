import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:github_app/core/color/app_color.dart';
import 'package:github_app/features/repo/data/models/repo_model.dart';
import 'package:github_app/features/repo/di/container.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/favorite_repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/repo_bloc.dart';
import 'package:github_app/features/repo/presentation/bloc/repo_event.dart';
import 'package:github_app/features/repo/presentation/bloc/repo_state.dart';
import 'package:github_app/features/repo/presentation/widgets/repo_card.dart';
import 'package:github_app/gen/assets.gen.dart';
import 'package:github_app/shared/widgets/group_repos_widget.dart';
import 'package:github_app/shared/widgets/loading_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class RepoPage extends StatefulWidget {
  const RepoPage({super.key});

  @override
  State<RepoPage> createState() => _RepoPageState();
}

class _RepoPageState extends State<RepoPage>
    with AutomaticKeepAliveClientMixin {
  final Debouncer _debouncer = Debouncer();
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      children: [
        TextField(
          style: TextStyle(fontSize: 14),
          onChanged: _handleSearch,
          decoration: InputDecoration(
            hintText: 'Search user repositories',
            suffixIcon: Icon(Icons.send_outlined),
            fillColor: Color(AppColor.secondary),
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Icon(Icons.star_outline),
            SizedBox(width: 8),
            Text('Top Repositories'),
          ],
        ),
        SizedBox(height: 10),
        BlocBuilder<RepoBloc, RepoState>(
          builder: (context, state) {
            if (state is RepoLoadingState) {
              return LoadingWidget();
            }

            if (state is RepoErrorState) {
              switch (state.code) {
                case 404:
                  return _buildNotFoundData();
                case 403:
                  return _buildUnauthorizedData();
                case 429:
                  return _buildToManyRequestsData();
                default:
                  return Text('Error: ${state.message}');
              }
            }

            if (state is RepoLoadedState) {
              return GroupReposWidget(
                repos: state.repos,
                scrollController: _scrollController,
              );
            }

            if (state is ListRepoLoadedState) {
              return GroupReposWidget(
                repos: state.repos.items,
                scrollController: _scrollController,
              );
            }
            return Text('No Data Available');
          },
        ),
      ],
    );
  }

  Widget _buildToManyRequestsData() {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          '429',
          style: GoogleFonts.sedgwickAve(
            fontSize: size.width * 0.2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Assets.images.octocatNotFoundIcon.image(width: size.width * 0.5),
        SizedBox(height: 20),
        Text(
          'Too Many Requests',
          style: GoogleFonts.sedgwickAve(
            fontSize: size.width * 0.1,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildUnauthorizedData() {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          '403',
          style: GoogleFonts.sedgwickAve(
            fontSize: size.width * 0.2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Assets.images.octocatNotFoundIcon.image(width: size.width * 0.5),
        SizedBox(height: 20),
        Text(
          'Unauthorized Access',
          style: GoogleFonts.sedgwickAve(
            fontSize: size.width * 0.1,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildNotFoundData() {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: 20),
        Text(
          '404',
          style: GoogleFonts.sedgwickAve(
            fontSize: size.width * 0.2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Assets.images.octocatNotFoundIcon.image(width: size.width * 0.5),
        SizedBox(height: 20),
        Text(
          'User Not Found',
          style: GoogleFonts.sedgwickAve(
            fontSize: size.width * 0.1,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _handleSearch(String query) {
    query = query.trim();
    if (query.isEmpty) {
      RepoBloc.of(context).add(GetTopReposEvent());
      return;
    } else {
      const duration = Duration(milliseconds: 500);
      _debouncer.debounce(
        duration: duration,
        onDebounce: () {
          RepoBloc.of(context).add(GetReposEventByUsername(query));
        },
      );
    }
  }
}
