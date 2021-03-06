import 'package:equatable/equatable.dart';

class Seasons extends Equatable {
  final int id;
  final String? posterPath;
  final int seasonNumber;
  final int episodeCount;
  Seasons({
    required this.id,
    required this.posterPath,
    required this.seasonNumber,
    required this.episodeCount,
  });

  @override
  List<Object?> get props => [id, posterPath, seasonNumber, episodeCount];
}
