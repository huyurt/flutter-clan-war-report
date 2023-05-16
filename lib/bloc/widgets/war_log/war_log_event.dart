import 'package:equatable/equatable.dart';

abstract class WarLogEvent extends Equatable {}

abstract class WarLogBaseEvent extends WarLogEvent {
  WarLogBaseEvent({required this.clanTag});

  final String clanTag;

  @override
  List<Object?> get props => [clanTag];
}

class GetWarLog extends WarLogBaseEvent {
  GetWarLog({required super.clanTag});
}
