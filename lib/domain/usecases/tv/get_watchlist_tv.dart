import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchlistTVShows {
  final TVRepository _repository;

  GetWatchlistTVShows(this._repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return _repository.getWatchlistTVShows();
  }
}
