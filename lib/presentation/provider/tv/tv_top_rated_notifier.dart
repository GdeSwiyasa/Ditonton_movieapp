import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/get_top_rated_tv.dart';
import 'package:flutter/foundation.dart';

class TopRatedTVShowsNotifier extends ChangeNotifier {
  final GetTopRatedTV getTopRatedTVShows;

  TopRatedTVShowsNotifier({required this.getTopRatedTVShows});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<Tv> _tvShows = [];
  List<Tv> get tvShows => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTVShows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTVShows.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvShowsData) {
        _tvShows = tvShowsData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
