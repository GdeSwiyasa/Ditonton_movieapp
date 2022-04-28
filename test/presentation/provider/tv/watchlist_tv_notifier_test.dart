import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/tv/watchlist_tv_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_notifier_test.mocks.dart';

@GenerateMocks([GetWatchlistTV])
void main() {
  late WatchlistTVNotifier provider;
  late MockGetWatchlistTVShows mockGetWatchlistTVShows;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTVShows = MockGetWatchlistTVShows();
    provider = WatchlistTVNotifier(
      getWatchlistTV: mockGetWatchlistTVShows,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  group('watchlist tv show notifier', () {
    test('should change tv shows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetWatchlistTVShows.execute())
          .thenAnswer((_) async => Right(testWatchlistTVShow));
      // act
      await provider.fetchWatchlistTV();
      // assert
      expect(provider.watchlistState, RequestState.Loaded);
      expect(provider.watchlistTV, testWatchlistTVShow);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetWatchlistTVShows.execute())
          .thenAnswer((_) async => Left(DatabaseFailure("Can't get data")));
      // act
      await provider.fetchWatchlistTV();
      // assert
      expect(provider.watchlistState, RequestState.Error);
      expect(provider.message, "Can't get data");
      expect(listenerCallCount, 2);
    });
  });
}
