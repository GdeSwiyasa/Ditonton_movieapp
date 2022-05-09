import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv/tv.dart';
import 'package:ditonton/domain/usecases/tv/search_tv.dart';
import 'package:ditonton/presentation/bloc/tv/tv_search/tv_search_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_tv_bloc_test.mocks.dart';

@GenerateMocks([TvSearchBloc, SearchTV])
void main() {
  late MockSearchTv mockSearchTv;
  late TvSearchBloc tvSearchBloc;

  setUp(() {
    mockSearchTv = MockSearchTv();
    tvSearchBloc = TvSearchBloc(
      TvSearch: mockSearchTv,
    );
  });

  const query = "originalTitle";
  final tvList = <Tv>[];

  test("initial state should be empty", () {
    expect(tvSearchBloc.state, TvSearchEmpty());
  });

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Loaded] when data is gotten successfully',
    build: () {
      when(mockSearchTv.execute(query)).thenAnswer((_) async => Right(tvList));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(OnQueryChanged(query)),
    expect: () => [TvSearchLoading(), TvSearchHasData(tvList)],
    verify: (bloc) {
      verify(mockSearchTv.execute(query));
    },
  );

  group(
    'Search Tv BLoC Test',
    () {
      blocTest<TvSearchBloc, TvSearchState>(
        'Should emit [Loading, Error] when get search is unsuccessful',
        build: () {
          when(mockSearchTv.execute(query))
              .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
          return tvSearchBloc;
        },
        act: (bloc) => bloc.add(OnQueryChanged(query)),
        expect: () => [TvSearchLoading(), TvSearchError('Server Failure')],
        verify: (bloc) {
          verify(mockSearchTv.execute(query));
        },
      );
    },
  );
}
