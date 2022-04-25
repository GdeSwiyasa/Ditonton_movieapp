import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/entities/tv/tv_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/tv/get_tv_show_detail.dart';
import 'package:ditonton/domain/usecases/tv/get_watchlist_status_tv.dart';
import 'package:ditonton/domain/usecases/tv/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/tv/save_watchlist_tv.dart';
import 'package:flutter/cupertino.dart';

class TVShowDetailNotifier extends ChangeNotifier {
  final GetTVDetail getTVDetail;
  final GetTVRecommendations getTVRecommendations;
  final GetWatchListStatusTV getWatchListStatusTV;
  final SaveWatchlistTV saveWatchlist;
  final RemoveWatchlistTV removeWatchlist;

  TVShowDetailNotifier({
    required this.getTVDetail,
    required this.getTVRecommendations,
    required this.saveWatchlist,
    required this.getWatchListStatusTV,
    required this.removeWatchlist,
  });

  late TVDetail _tvShowDetail;
  TVDetail get tvShowDetail => _tvShowDetail;

  RequestState _tvShowState = RequestState.Empty;
  RequestState get tvShowState => _tvShowState;

  List<Tv> _tvShowRecommendations = [];
  List<Tv> get tvShowRecommendations => _tvShowRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchTVShowDetail(int id) async {
    _tvShowState = RequestState.Loading;
    notifyListeners();
    final detailTVResult = await getTVDetail.execute(id);
    final recommendationResult = await getTVRecommendations.execute(id);
    detailTVResult.fold((failure) {
      _tvShowState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvShow) {
      _recommendationState = RequestState.Loading;
      _tvShowDetail = tvShow;
      notifyListeners();

      recommendationResult.fold(
        (failure) {
          _recommendationState = RequestState.Error;
          _message = failure.message;
        },
        (tvShows) {
          _recommendationState = RequestState.Loaded;
          _tvShowRecommendations = tvShows;
        },
      );
      _tvShowState = RequestState.Loaded;
      notifyListeners();
    });
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TVDetail tvShow) async {
    final result = await saveWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> removeFromWatchlist(TVDetail tvShow) async {
    final result = await removeWatchlist.execute(tvShow);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tvShow.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusTV.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}