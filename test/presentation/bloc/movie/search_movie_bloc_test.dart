import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie/movie.dart';
import 'package:ditonton/domain/usecases/movie/search_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search/movie_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_movie_bloc_test.mocks.dart';

@GenerateMocks([MovieSearchBloc, SearchMovies])
void main() {
  late MockSearchMovies mockSearchMovies;
  late MovieSearchBloc movieSearchBloc;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    movieSearchBloc = MovieSearchBloc(
      searchMovies: mockSearchMovies,
    );
  });

  const query = "originalTitle";
  final movieList = <Movie>[];

  test("initial state should be empty", () {
    expect(movieSearchBloc.state, MovieSearchEmpty());
  });

  blocTest<MovieSearchBloc, MovieSearchState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchMovies.execute(query))
          .thenAnswer((_) async => Right(movieList));
      return movieSearchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(query)),
    expect: () => [MovieSearchLoading(), MovieSearchHasData(movieList)],
    verify: (bloc) {
      verify(mockSearchMovies.execute(query));
    },
  );

  group(
    'Search Movies BLoC Test',
    () {
      blocTest<MovieSearchBloc, MovieSearchState>(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockSearchMovies.execute(query))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return movieSearchBloc;
        },
        act: (bloc) => bloc.add(OnQueryChanged(query)),
        expect: () =>
            [MovieSearchLoading(), MovieSearchError('Server Failure')],
        verify: (bloc) {
          verify(mockSearchMovies.execute(query));
        },
      );
    },
  );
}
