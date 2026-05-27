import 'package:anastagram/features/profile/domain/profile_overview.dart';

class HomeUiState {
  const HomeUiState({
    required this.username,
    required this.profile,
    required this.isLoading,
    required this.isSaved,
  });

  factory HomeUiState.initial() {
    return const HomeUiState(
      username: '',
      profile: null,
      isLoading: false,
      isSaved: false,
    );
  }

  final String username;
  final ProfileOverview? profile;
  final bool isLoading;
  final bool isSaved;

  bool get hasProfile => profile != null;

  HomeUiState copyWith({
    String? username,
    ProfileOverview? profile,
    bool clearProfile = false,
    bool? isLoading,
    bool? isSaved,
  }) {
    return HomeUiState(
      username: username ?? this.username,
      profile: clearProfile ? null : (profile ?? this.profile),
      isLoading: isLoading ?? this.isLoading,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

