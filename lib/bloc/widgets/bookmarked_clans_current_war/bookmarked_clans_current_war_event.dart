import 'package:equatable/equatable.dart';

import '../../../utils/enums/process_type_enum.dart';

abstract class BookmarkedClansCurrentWarEvent extends Equatable {}

abstract class BookmarkedClansCurrentWarBaseEvent
    extends BookmarkedClansCurrentWarEvent {
  BookmarkedClansCurrentWarBaseEvent({
    required this.process,
    required this.clanTagList,
  });

  final ProcessType process;
  final List<String> clanTagList;

  @override
  List<Object?> get props => [process, clanTagList];
}

class GetBookmarkedClansCurrentWar extends BookmarkedClansCurrentWarBaseEvent {
  GetBookmarkedClansCurrentWar({
    required super.process,
    required super.clanTagList,
  });
}
