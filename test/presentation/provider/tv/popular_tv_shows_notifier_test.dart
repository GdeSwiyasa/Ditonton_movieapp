import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:ditonton/presentation/provider/tv/tv_popular_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'popular_tv_shows_notifier_test.mocks.dart';

@GenerateMocks([GetPopularTV])
void main() {
  late MockGetPopularTVShows mockGetPopularTVShows;
  late PopularTVNotifier notifier;
  late int listenerCallCount;
  setUp(() {
    listenerCallCount = 0;
    mockGetPopularTVShows = MockGetPopularTVShows();
    notifier = PopularTVNotifier(mockGetPopularTVShows)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  group('popular tv shows notifier', () {
    test('should change state to loading when usecase is called', () async {
      //arrage
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      //act
      notifier.fetchPopularTVShows();

      //assert
      expect(notifier.requestState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv shows data when data is gotten successfully',
        () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      await notifier.fetchPopularTVShows();
      // assert
      expect(notifier.requestState, RequestState.Loaded);
      expect(notifier.popularTVShows, testTVShowList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await notifier.fetchPopularTVShows();
      // assert
      expect(notifier.requestState, RequestState.Error);
      expect(notifier.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
