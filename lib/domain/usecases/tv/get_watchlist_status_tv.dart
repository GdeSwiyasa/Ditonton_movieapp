import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchListStatusTVShow {
  final TVRepository repository;

  GetWatchListStatusTVShow(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
