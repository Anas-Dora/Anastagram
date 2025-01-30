// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';

import 'package:anastagram/Widget/CustomAppbar.dart';
import 'package:anastagram/Widget/Dialog.dart';
import 'package:anastagram/Widget/DottedLinePainter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../Models/InstagramApi.dart';
import '../Models/profileimage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../Models/user_data.dart';
import '../Models/NetworkVideoPlayer.dart';
import '../Pages/Images.dart';
import '../Pages/Videos.dart';
import '../Models/profile.dart';

class TestHomePage extends StatefulWidget {
  const TestHomePage({super.key});

  @override
  TestHomePageState createState() => TestHomePageState();
}

class TestHomePageState extends State<TestHomePage> {
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
  late SharedPreferences prefs;
  List<Map<String, String>> mediaItems = [];

  @override
  void initState() {
    super.initState();
    usernameController.addListener(() => setState(() {}));
    setupPages();
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
  }

  setupPages() async {
    prefs = await SharedPreferences.getInstance();
    String? stringPages = prefs.getString('pages');
    List pagesList = jsonDecode(stringPages!);
    for (var userPage in pagesList) {
      setState(() {
        Provider.of<UserData>(
          context,
          listen: false,
        ).profiles.add(Profile().fromJson(userPage));
      });
    }
  }

  void savePages() {
    List items =
        Provider.of<UserData>(
          context,
          listen: false,
        ).profiles.map((e) => e.toJson()).toList();
    prefs.setString('pages', jsonEncode(items));
  }

  void deletePage(String profileName) {
    List<Profile> profiles =
        Provider.of<UserData>(context, listen: false).profiles;
    profiles.removeWhere((profile) => profile.name == profileName);
    List items = profiles.map((e) => e.toJson()).toList();
    prefs.setString('pages', jsonEncode(items));
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

  Future<void> _toggleSaveProfile() async {
    setState(() => isSaved = !isSaved);
    if (profileImageUrl != null) {
      setState(() {
        if (isSaved) {
          Provider.of<UserData>(
            context,
            listen: false,
          ).profiles.add(Profile(name: username));
          savePages();
        } else {
          Provider.of<UserData>(
            context,
            listen: false,
          ).profiles.removeWhere((profile) => profile.name == username);
          deletePage(username);
        }
      });
    }
  }

  String _formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate = DateFormat('HH:mm').format(dateTime);
    return '$formattedDate | ${timeago.format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomizedAppbar(
        profileImageUrl: profileImageUrl,
        username: username,
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
                    border: Border.all(color: Color(0xFF1565C0), width: 5),
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
                    color: Colors.blue[800],
                  ),
                ),
                SizedBox(height: 10),
                if (isReloading)
                  CircularProgressIndicator(color: Colors.blue[800])
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
                    color: isSaved ? Colors.white : Colors.blue[800],
                  ),
                  label: Text(
                    isSaved ? "gespeichert" : "Speichern",
                    style: TextStyle(
                      color: isSaved ? Colors.white : Colors.blue[800],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSaved ? Colors.blue[800] : Colors.white,
                    side: isSaved ? null : BorderSide(color: Color(0xFF1565C0)),
                  ),
                ),
                SizedBox(height: 15),
                Divider(color: Colors.blue[800], thickness: 2),
                SizedBox(height: 20),
                if (isPrivate)
                  Text(
                    'IST PRIVAT',
                    style: TextStyle(
                      color: Colors.blue[800],
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
        backgroundColor: Colors.blue[800],
        child: Icon(Icons.search, color: Colors.white),
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
            color: Colors.blue[800],
          ),
        ),
        Text(label, style: TextStyle(fontSize: 16, color: Colors.blue[800])),
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
                    style: TextStyle(fontSize: 14, color: Colors.blue[800]),
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
