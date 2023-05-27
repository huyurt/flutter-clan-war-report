import 'package:equatable/equatable.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constants/app_constants.dart';

class SearchClansRequestModel extends Equatable {
  const SearchClansRequestModel({
    required this.clanName,
    this.locationId,
    this.minMembers,
    this.maxMembers,
    this.minClanLevel,
    this.after,
    this.before,
  });

  final String clanName;
  final int? locationId;
  final int? minMembers;
  final int? maxMembers;
  final int? minClanLevel;
  final String? after;
  final String? before;

  SearchClansRequestModel copyWith({
    String? clanName,
    int? locationId,
    int? minMembers,
    int? maxMembers,
    int? minClanLevel,
    String? after,
    String? before,
  }) =>
      SearchClansRequestModel(
        clanName: clanName ?? this.clanName,
        locationId: locationId ?? this.locationId,
        minMembers: minMembers ?? this.minMembers,
        maxMembers: maxMembers ?? this.maxMembers,
        minClanLevel: minClanLevel ?? this.minClanLevel,
        after: after ?? this.after,
        before: before ?? this.before,
      );

  @override
  List<Object?> get props =>
      [clanName, minMembers, maxMembers, minClanLevel, after];

  bool get isDefault {
    if ((locationId == null || locationId == -1) &&
        (minMembers == null || minMembers == AppConstants.minMembersFilter) &&
        (maxMembers == null || maxMembers == AppConstants.maxMembersFilter) &&
        (minClanLevel == null ||
            minClanLevel == AppConstants.minClanLevelFilter)) {
      return true;
    }
    return false;
  }
}
