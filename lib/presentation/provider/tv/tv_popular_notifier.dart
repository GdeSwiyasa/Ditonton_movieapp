import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:flutter/cupertino.dart';

class PopularTVShowsNotifier extends ChangeNotifier {
  final GetPopularTVShows usecase;
  PopularTVShowsNotifier(this.usecase);

  RequestState _requestState = RequestState.Empty;
  RequestState get requestState => _requestState;

  List<Tv> _popularTVShows = [];
  List<Tv> get popularTVShows => _popularTVShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTVShows() async {
    _requestState = RequestState.Loading;
    notifyListeners();

    final result = await usecase.execute();

    result.fold((failure) {
      _message = failure.message;
      _requestState = RequestState.Error;
      notifyListeners();
    }, (popular) {
      _popularTVShows = popular;
      _requestState = RequestState.Loaded;
      notifyListeners();
    });
  }
}
