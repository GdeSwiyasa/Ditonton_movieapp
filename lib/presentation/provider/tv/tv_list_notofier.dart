import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_now_playing_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_popular_tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:flutter/cupertino.dart';

class TVListNotifier extends ChangeNotifier {
  var _nowPlayingTVShows = <Tv>[];
  List<Tv> get nowPlayingTVShows => _nowPlayingTVShows;

  var _popularTVShows = <Tv>[];
  List<Tv> get popularTVShows => _popularTVShows;

  var _topRatedTVShows = <Tv>[];
  List<Tv> get topRatedTVShows => _topRatedTVShows;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  RequestState _popularTVShowsState = RequestState.Empty;
  RequestState get popularTVShowsState => _popularTVShowsState;

  RequestState _topRatedTVState = RequestState.Empty;
  RequestState get topRatedTVState => _topRatedTVState;

  String _message = '';
  String get message => _message;

  final GetNowPlayingTV getNowPlayingTVShows;
  final GetPopularTV getPopularTVShows;
  final GetTopRatedTV getTopRatedTVShows;
  TVListNotifier({
    required this.getNowPlayingTVShows,
    required this.getPopularTVShows,
    required this.getTopRatedTVShows,
  });

  Future<void> fetchNowPlayingTVShows() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();

    final result = await getNowPlayingTVShows.execute();
    result.fold((failure) {
      _nowPlayingState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvShows) {
      _nowPlayingState = RequestState.Loaded;
      _nowPlayingTVShows = tvShows;
      notifyListeners();
    });
  }

  Future<void> fetchPopularTVShows() async {
    _popularTVShowsState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTVShows.execute();
    result.fold(
      (failure) {
        _popularTVShowsState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvShowsData) {
        _popularTVShowsState = RequestState.Loaded;
        _popularTVShows = tvShowsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTVShows() async {
    _topRatedTVState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVShows.execute();
    result.fold((failure) {
      _topRatedTVState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (topRated) {
      _topRatedTVState = RequestState.Loaded;
      _topRatedTVShows = topRated;
      notifyListeners();
    });
  }
}
