import 'package:anastagram/Widgets/custom_appbar.dart';
import 'package:anastagram/Widgets/media/media_list.dart';
import 'package:anastagram/Widgets/profile_actions.dart';
import 'package:anastagram/Widgets/profile_header.dart';
import 'package:anastagram/Widgets/profile_stats.dart';
import 'package:anastagram/Widgets/story_tray_list.dart';
import 'package:anastagram/Widgets/user_input_dialog.dart';
import 'package:anastagram/data/story_models.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../controllers/home_controller.dart';
import '../data/userdata.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController();

  String? profileImageUrl;
  int followers = 0;
  int following = 0;
  int stories = 0;
  String username = "";
  bool isReloading = false;
  bool isPrivate = false;
  bool isSaved = false;
  String saveText = "Speichern";
  final highlightStories = <StoryBundle>[];
  List<String> highlightsTitel = [];
  List<String> highlightsAvatarUrl = [];
  List<String> highlightsId = [];
  List<Map<String, String>> storieItems = [];

  @override
  void initState() {
    super.initState();
    Hive.openBox<UserData>('userData');
  }

  void _updateProfileData(
    picUrl,
    f,
    fo,
    s,
    List<Map<String, String>> newStorieItems,
    List<String> newHighlightsTitles,
    List<String> newHighlightsAvatar,
    List<String> newHighlightsId,
    bool priv,
  ) {
    setState(() {
      profileImageUrl = picUrl;
      followers = f;
      following = fo;
      stories = s;

      storieItems = newStorieItems;
      highlightsTitel = newHighlightsTitles;
      highlightsAvatarUrl = newHighlightsAvatar;
      highlightsId = newHighlightsId;

      highlightStories.clear();

      for (int i = 0; i < highlightsAvatarUrl.length; i++) {
        final avatar = highlightsAvatarUrl[i];
        final title = i < highlightsTitel.length ? highlightsTitel[i] : '';
        final storieId = i < highlightsId.length ? highlightsId[i] : '';

        highlightStories.add(
          StoryBundle(title: title, avatarUrl: avatar, storieId: storieId),
        );
      }

      isPrivate = priv;
      isReloading = false;
    });
  }

  void _resetValues() {
    setState(() {
      profileImageUrl = null;
      followers = 0;
      following = 0;
      stories = 0;
      username = "";
      storieItems.clear();
      isPrivate = false;
      isSaved = false;
      saveText = "Speichern";
    });
  }

  Future<void> _showUserInputDialog() async {
    final profileName = await showDialog<String>(
      context: context,
      builder: (_) => const UserInputDialog(),
    );

    if (profileName != null && profileName.isNotEmpty) {
      setState(() {
        username = profileName.trim();
        isReloading = true;
      });

      controller.fetchUserDetails(username, _updateProfileData);
      setState(() {
        isSaved = controller.isProfileSaved(username);
        saveText = isSaved ? "gespeichert" : "Speichern";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191C20),
      appBar: CustomAppbar(
        profileImageUrl: profileImageUrl,
        username: username,
        resetValues: _resetValues,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          ProfileHeader(profileImageUrl: profileImageUrl, username: username),
          const SizedBox(height: 10),
          isReloading
              ? Center(
                  child: CircularProgressIndicator(color: Color(0xFFa0cafd)),
                )
              : ProfileStats(
                  stories: stories,
                  followers: followers,
                  following: following,
                ),
          const SizedBox(height: 20),
          Center(
            child: ProfileActions(
              isSaved: isSaved,
              saveText: saveText,
              onSave: () => controller.saveProfile(username, context, () {
                setState(() {
                  isSaved = true;
                  saveText = "gespeichert";
                });
              }),
              onUnsave: () => controller.unSaveProfile(username, context, () {
                setState(() {
                  isSaved = false;
                  saveText = "Speichern";
                });
              }),
            ),
          ),
          const SizedBox(height: 20),
          (isPrivate == true || profileImageUrl == null)
              ? Text("")
              : StoryTrayList(stories: highlightStories),
          Divider(color: Color(0xff2E3135), thickness: 2),
          const SizedBox(height: 20),
          isPrivate
              ? Text(
                  'IST PRIVAT',
                  style: TextStyle(
                    color: Color(0xff93000a),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
              : buildMediaList(storieItems, context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _resetValues();
          await _showUserInputDialog();
        },
        backgroundColor: Color(0xff194975),
        child: Icon(Icons.search, color: Color(0xffD1E4FF)),
      ),
    );
  }
}
