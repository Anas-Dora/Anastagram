import 'package:flutter/material.dart';

class StoryTray extends StatefulWidget {
  const StoryTray({
    super.key,
    required this.avatarUrl,
    required this.label,
    required this.onTapAsync,
  });

  final String avatarUrl;
  final String label;
  final Future<void> Function() onTapAsync;

  @override
  State<StoryTray> createState() => _StoryTrayState();
}

class _StoryTrayState extends State<StoryTray> {
  bool _isLoading = false;

  Future<void> _handleTap() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    await widget.onTapAsync();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _handleTap,
            child: Stack(
              children: [
                if (_isLoading)
                  SizedBox(
                    width: 70,
                    height: 70,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Color(0xff003258),
                      backgroundColor: Colors.white24,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFa0cafd),
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(widget.avatarUrl),
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
