// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:async';

import 'package:anastagram/Widget/DottedLinePainter.dart';
import 'package:hive/hive.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/InstagramApi.dart';
import '../Widget/profileimage.dart';

import '../Models/userdata.dart';
import '../Widget/NetworkVideoPlayer.dart';
import '../Widget/CustomAppbar.dart';
import '../Widget/Dialog.dart';
import 'Images.dart';
import 'Videos.dart';
import '../Models/profile.dart';

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
  List<Map<String, String>> mediaItems = [];

  @override
  void initState() {
    super.initState();
    usernameController.addListener(() => setState(() {}));
    setupPages();
    Hive.openBox<UserData>('userData');
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  setupPages() async {}

  void savePages() {}

  void deletePage(String profileName) {}

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
    });
  }

  void submit() {
    _fetchUserDetails(username);
    Navigator.of(context).pop(usernameController.text);
    if (profileImageUrl != null) {
      isSaved = false;
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
    });
  }

  String _formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate | ${timeago.format(dateTime)}';
  }

  void _toggleSaveProfile() async {
    final box = Hive.box<UserData>('userData');
    UserData? userData = box.get('mainUser') ?? UserData();

    String newName = usernameController.text.trim();
    bool nameExists = userData.profiles.any((p) => p.name == newName);

    if (!nameExists && newName.isNotEmpty) {
      userData.profiles.add(Profile(name: newName));
      await box.put('mainUser', userData);
    }

    setState(() {
      isSaved = true;
    });
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
                  onPressed: _toggleSaveProfile,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: Color(0xff003258),
                  ),
                  label: Text(
                    isSaved ? "gespeichert" : "Speichern",
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
