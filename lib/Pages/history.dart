// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, non_constant_identifier_names, constant_identifier_names, list_remove_unrelated_type

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Models/user_data.dart';
import '../Models/profile.dart';
import 'pages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchHistory extends StatefulWidget {
  final userName;
  final pPicture;

  const SearchHistory({super.key, required this.userName, required this.pPicture});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

void deletePage(context, String profileName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<Profile> profiles =
      Provider.of<UserData>(context, listen: false).profiles;
  profiles.removeWhere((profile) => profile.name == profileName);
  List items = profiles.map((e) => e.toJson()).toList();
  prefs.setString('pages', jsonEncode(items));
}

class _SearchHistoryState extends State<SearchHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Tooltip(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            color: Colors.black54,
          ),
          message: "Zurück",
          textStyle: TextStyle(color: Colors.white),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.blue[800]),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Anastagram",
          style: TextStyle(
            color: Colors.blue[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body:
          (Provider.of<UserData>(context).profiles.isEmpty)
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmarks_outlined,
                      size: 100,
                      color: Colors.blue[800],
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Keine gespeicherte \nprofilen",
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: Consumer<UserData>(
                      builder: (BuildContext context, userData, Widget? child) {
                        return ListView.builder(
                          itemCount: userData.profiles.length,
                          itemBuilder: (context, index) {
                            return Pages(
                              profileName: userData.profiles[index].name,
                              deleteProfile: () async {
                                setState(() {
                                  userData.deleteProfile(
                                    userData.profiles[index],
                                  );
                                });
                             /*   deletePage(
                                  context,
                                  userData.profiles[index].name!,
                                );*/
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
