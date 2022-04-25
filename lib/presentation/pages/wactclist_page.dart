import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:flutter/material.dart';

class WatchlistPage extends StatelessWidget {
  static const ROUTE_NAME = '/watchlist-page';
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('Watchlist'),
              pinned: true,
              floating: true,
              bottom: TabBar(
                indicatorColor: kMikadoYellow,
                tabs: [
                  _buildTabBarItem('Movies', Icons.movie_creation_outlined),
                  _buildTabBarItem('TV Show', Icons.live_tv_rounded),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          children: <Widget>[
            WatchlistMoviesPage(),
            WatchlistTvPage(),
          ],
        ),
      )),
    );
  }

  Widget _buildTabBarItem(String title, IconData iconData) => Padding(
        padding: EdgeInsets.only(top: 4.0, bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData),
            SizedBox(
              width: 12.0,
            ),
            Text(title),
          ],
        ),
      );
}
