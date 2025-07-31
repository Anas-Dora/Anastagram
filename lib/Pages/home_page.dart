// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:anastagram/Widget/DottedLinePainter.dart';
import 'package:hive/hive.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/InstagramApi.dart';
import '../Widget/profileimage.dart';

import '../data/userdata.dart';
import '../Widget/NetworkVideoPlayer.dart';
import '../Widget/CustomAppbar.dart';
import '../Widget/Dialog.dart';
import 'Images.dart';
import 'Videos.dart';
import '../data/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController usernameController = TextEditingController();
  final InstagramApi instagramApi = InstagramApi();

  String? profileImageUrl;
  int followers = 0;
  int following = 0;
  int stories = 0;
  String username = "";
  bool isReloading = false;
  bool isPrivate = false;
  bool isSaved = false;
  String saveText = "Speichern";
  List<Map<String, String>> mediaItems = [];

  @override
  void initState() {
    super.initState();
    usernameController.addListener(() => setState(() {}));
    Hive.openBox<UserData>('userData');
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  void saveProfile() {
    final box = Hive.box<UserData>('userData');
    UserData? userData = box.get('mainUser') ?? UserData();

    String newName = usernameController.text.trim();
    bool nameExists = userData.profiles.any((p) => p.name == newName);
    saveText = "gespeichert";

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Profilname darf nicht leer sein.',
            style: TextStyle(color: Color(0xff2e3135)),
          ),
          backgroundColor: Color(0xffe1e2e8),
          behavior: SnackBarBehavior.floating,

          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isSaved = false;
      });
      return;
    }

    if (nameExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ein Profil mit diesem Namen existiert bereits.',
            style: TextStyle(color: Color(0xff2e3135)),
          ),
          backgroundColor: Color(0xffe1e2e8),
          behavior: SnackBarBehavior.floating,

          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isSaved = false;
      });
      return;
    }
    try {
      userData.profiles.add(Profile(name: newName));
      box.put('mainUser', userData);
      setState(() {
        isSaved = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profil "$newName" erfolgreich gespeichert!',
            style: TextStyle(color: Color(0xff2e3135)),
          ),
          backgroundColor: Color(0xffe1e2e8),
          behavior: SnackBarBehavior.floating,

          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Fehler beim Speichern des Profils: $e',
            style: TextStyle(color: Color(0xff2e3135)),
          ),
          backgroundColor: Color(0xffe1e2e8),
          behavior: SnackBarBehavior.floating,

          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isSaved = false;
      });
    }
  }

  void unSaveProfile() {
    final box = Hive.box<UserData>('userData');
    UserData? userData = box.get('mainUser') ?? UserData();

    String newName = usernameController.text.trim();
    bool nameExists = userData.profiles.any((p) => p.name == newName);
    saveText = "Speichern";

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profilname darf nicht leer sein.',
            style: TextStyle(color: Color(0xff2e3135)),
          ),
          backgroundColor: Color(0xffe1e2e8),
          behavior: SnackBarBehavior.floating,

          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isSaved = false;
      });
      return;
    }

    if (!nameExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Profil nicht gespeichert.',
            style: TextStyle(color: Color(0xff2e3135)),
          ),
          backgroundColor: Color(0xffe1e2e8),
          behavior: SnackBarBehavior.floating,

          duration: Duration(seconds: 2),
        ),
      );
      setState(() {
        isSaved = false;
      });
      return;
    }

    userData.profiles.removeWhere((p) => p.name == newName);
    box.put('mainUser', userData);
    setState(() {
      isSaved = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Profil "$newName" erfolgreich entfernt!',
          style: TextStyle(color: Color(0xff2e3135)),
        ),
        backgroundColor: Color(0xffe1e2e8),
        behavior: SnackBarBehavior.floating,

        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _fetchUserDetails(String username) async {
    setState(() => isReloading = true);
    await instagramApi.getApi(username);
    setState(() {
      profileImageUrl = instagramApi.picURL;
      followers = instagramApi.followers ?? 0;
      following = instagramApi.following ?? 0;
      stories = instagramApi.itemsCount ?? 0;
      mediaItems = instagramApi.mediaItems;
      isPrivate = instagramApi.isPrivate ?? false;
      isReloading = false;
      saveText = "Speichern";
    });
  }

  void submit() {
    final box = Hive.box<UserData>('userData');
    UserData? userData = box.get('mainUser') ?? UserData();
    _fetchUserDetails(username);
    Navigator.of(context).pop(usernameController.text);

    bool nameExists = userData.profiles.any((p) => p.name == username);

    if (nameExists) {
      saveText = "gespeichert";
      setState(() {
        isSaved = true;
      });
    } else {
      saveText = "Speichern";
      setState(() {
        isSaved = false;
      });
    }
  }

  void _resetValues() {
    setState(() {
      usernameController.clear();
      profileImageUrl = null;
      followers = 0;
      following = 0;
      stories = 0;
      username = "";
      mediaItems.clear();
      isPrivate = false;
      isSaved = false;
      saveText = "Speichern";
    });
  }

  String _formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate | ${timeago.format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191C20),
      appBar: CustomizedAppbar(
        profileImageUrl: profileImageUrl,
        username: username,
        resetValues: _resetValues,
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: ListView(
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF194975), width: 5),
                  ),
                  child: ClipOval(
                    child:
                        profileImageUrl == null
                            ? Image.asset(
                              "images/test.jpg",
                              fit: BoxFit.cover,
                              width: 300,
                              height: 300,
                            )
                            : ProfileImage(profileImage: profileImageUrl!),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffa0cafd),
                  ),
                ),
                SizedBox(height: 10),
                if (isReloading)
                  CircularProgressIndicator(color: Color(0xFFa0cafd))
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem('Stories', stories),
                      const SizedBox(width: 20),
                      _buildStatItem("Followers", followers),
                      const SizedBox(width: 20),
                      _buildStatItem("Following", following),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: isSaved ? unSaveProfile : saveProfile,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Color(0xff003258),
                  ),
                  label: Text(
                    saveText,
                    style: TextStyle(color: Color(0xff003258)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffa0cafd),
                  ),
                ),
                SizedBox(height: 15),
                Divider(color: Color(0xff2E3135), thickness: 2),
                SizedBox(height: 20),
                if (isPrivate)
                  Text(
                    'IST PRIVAT',
                    style: TextStyle(
                      color: Color(0xff93000a),
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  _buildMediaList(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _resetValues();
          await DialogHelper.openDialog(
            context: context,
            usernameController: usernameController,
            submit: submit,
            onUsernameChanged: (newUser) {
              setState(() {
                username = newUser;
              });
            },
          );
        },
        backgroundColor: Color(0xff194975),
        child: Icon(Icons.search, color: Color(0xffD1E4FF)),
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xffa0cafd),
          ),
        ),
        Text(label, style: TextStyle(fontSize: 16, color: Color(0xffa0cafd))),
      ],
    );
  }

  Widget _buildMediaList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: mediaItems.length,
      itemBuilder: (context, index) {
        final item = mediaItems[index];
        final time = item["time"];

        String formattedTime =
            time != null ? _formatDateTime(time) : 'Keine Zeit';

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item["type"] == "image")
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryImages(image: item["url"]!),
                      ),
                    );
                  },
                  child: Image.network(item["url"]!),
                ),
              if (item["type"] == "video")
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryVideos(video: item["url"]),
                      ),
                    );
                  },
                  child: NetworkVideoPlayer(url: item["url"]!),
                ),
              if (time != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Zeit: $formattedTime',
                    style: TextStyle(fontSize: 14, color: Color(0xffa0cafd)),
                  ),
                ),
              SizedBox(height: 10),
              CustomPaint(
                size: Size(double.infinity, 1),
                painter: DottedLinePainter(),
              ),
            ],
          ),
        );
      },
    );
  }
}
