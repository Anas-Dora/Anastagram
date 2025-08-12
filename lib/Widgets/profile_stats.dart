import 'package:anastagram/Widgets/stat_item.dart';
import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int stories;
  final int followers;
  final int following;

  const ProfileStats({
    super.key,
    required this.stories,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildStatItem('Stories', stories),
        const SizedBox(width: 20),
        buildStatItem('Followers', followers),
        const SizedBox(width: 20),
        buildStatItem('Following', following),
      ],
    );
  }
}
