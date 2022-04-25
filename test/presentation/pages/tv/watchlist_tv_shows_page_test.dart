import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/presentation/pages/tv/watchlist_tv_page.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'watchlist_tv_shows_page_test.mocks.dart';

@GenerateMocks([WatchlistTVNotifier])
void main() {
  late MockWatchlistTVNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockWatchlistTVNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<WatchlistTVNotifier>.value(
      value: mockNotifier,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group('watchlist tv shows', () {
    testWidgets('watchlist tv shows should display',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
      when(mockNotifier.watchlistTV).thenReturn(testTVList);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

      expect(find.byType(TvCardList), findsWidgets);
    });

    testWidgets('message for feedback should display when data is empty',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.Loaded);
      when(mockNotifier.watchlistTVShows).thenReturn(<Tv>[]);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

      expect(find.text('Add your favorite movie!'), findsOneWidget);
    });

    testWidgets('loading indicator should display when getting data',
        (WidgetTester tester) async {
      when(mockNotifier.watchlistState).thenReturn(RequestState.Loading);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTvPage()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
