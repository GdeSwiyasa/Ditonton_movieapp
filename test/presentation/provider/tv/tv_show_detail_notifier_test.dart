import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:ditonton/presentation/provider/tv/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'tv_show_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetWatchListStatusTV,
  SaveWatchlistTV,
  RemoveWatchlistTV,
])
void main() {
  late TVDetailNotifier provider;
  late MockGetTVShowDetail mockGetTVShowDetail;
  late MockGetTVShowRecommendations mockGetTVShowRecommendations;
  late MockGetWatchListStatusTVShow mockGetWatchlistStatus;
  late MockSaveWatchlistTVShow mockSaveWatchlist;
  late MockRemoveWatchlistTVShow mockRemoveWatchlist;

  late int listenerCallCount;

  setUp(() {
    mockGetTVShowDetail = MockGetTVShowDetail();
    mockGetTVShowRecommendations = MockGetTVShowRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTVShow();
    mockSaveWatchlist = MockSaveWatchlistTVShow();
    mockRemoveWatchlist = MockRemoveWatchlistTVShow();
    listenerCallCount = 0;
    provider = TVDetailNotifier(
      getTVDetail: mockGetTVShowDetail,
      getTVRecommendations: mockGetTVShowRecommendations,
      getWatchListStatusTV: mockGetWatchlistStatus,
      removeWatchlist: mockRemoveWatchlist,
      saveWatchlist: mockSaveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  void _arrageUseCase() {
    when(mockGetTVShowDetail.execute(tId))
        .thenAnswer((_) async => Right(testTVShowDetailResponseEntity));
    when(mockGetTVShowRecommendations.execute(tId))
        .thenAnswer((_) async => Right(testTVShowList));
  }

  group('Get TVShow Detail', () {
    test('should get data from the usecase', () async {
      //arrage
      _arrageUseCase();
      //act
      await provider.fetchTVDetail(tId);
      //assert
      verify(mockGetTVShowDetail.execute(tId));
    });

    test('should change state to loading when usecase is called', () {
      //arrage
      _arrageUseCase();
      //act
      provider.fetchTVDetail(tId);
      //assert
      expect(provider.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv show when data is gotten successfully', () async {
      //arrage
      _arrageUseCase();
      //act
      await provider.fetchTVDetail(tId);
      //assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.tvDetail, testTVShowDetailResponseEntity);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation movies when data is gotten successfully',
        () async {
      // arrange
      _arrageUseCase();
      // act
      await provider.fetchTVDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.tvRecommendations, testTVShowList);
    });
  });

  group('Get TVShow Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrageUseCase();
      // act
      await provider.fetchTVDetail(tId);
      // assert
      verify(mockGetTVShowRecommendations.execute(tId));
      expect(provider.tvRecommendations, testTVShowList);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrageUseCase();
      // act
      await provider.fetchTVDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvRecommendations, testTVShowList);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVShowDetailResponseEntity));
      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTVDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVShowDetailResponseEntity))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testTVShowDetailResponseEntity.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTVShowDetailResponseEntity);
      // assert
      verify(mockSaveWatchlist.execute(testTVShowDetailResponseEntity));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testTVShowDetailResponseEntity))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testTVShowDetailResponseEntity.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(testTVShowDetailResponseEntity);
      // assert
      verify(mockRemoveWatchlist.execute(testTVShowDetailResponseEntity));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVShowDetailResponseEntity))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTVShowDetailResponseEntity.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(testTVShowDetailResponseEntity);
      // assert
      verify(mockGetWatchlistStatus.execute(testTVShowDetailResponseEntity.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVShowDetailResponseEntity))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTVShowDetailResponseEntity.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(testTVShowDetailResponseEntity);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTVShowList));
      // act
      await provider.fetchTVDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
