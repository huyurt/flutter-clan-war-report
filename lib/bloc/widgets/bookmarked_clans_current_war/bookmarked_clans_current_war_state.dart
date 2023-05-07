import 'package:equatable/equatable.dart';

import '../../../models/coc/clans_current_war_state_model.dart';

abstract class BookmarkedClansCurrentWarState extends Equatable {
  const BookmarkedClansCurrentWarState();

  @override
  List<Object?> get props => [];
}

class BookmarkedClansCurrentWarStateEmpty
    extends BookmarkedClansCurrentWarState {}

class BookmarkedClansCurrentWarStateLoading
    extends BookmarkedClansCurrentWarState {}

class BookmarkedClansCurrentWarStateCompleted
    extends BookmarkedClansCurrentWarState {}

class BookmarkedClansCurrentWarStateSuccess
    extends BookmarkedClansCurrentWarState {
  const BookmarkedClansCurrentWarStateSuccess({
    required this.clansCurrentWar,
  });

  final List<ClansCurrentWarStateModel?> clansCurrentWar;

  @override
  List<Object?> get props => [clansCurrentWar];

  @override
  String toString() =>
      'BookmarkedClansCurrentWarStateSuccess { clansCurrentWar: $clansCurrentWar }';
}

class BookmarkedClansCurrentWarStateError
    extends BookmarkedClansCurrentWarState {
  const BookmarkedClansCurrentWarStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
