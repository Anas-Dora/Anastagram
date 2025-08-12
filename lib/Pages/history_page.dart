// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, non_constant_identifier_names, constant_identifier_names, list_remove_unrelated_type
import 'package:anastagram/Widgets/profile_name_tile.dart';
import 'package:anastagram/data/userdata.dart';
import 'package:hive/hive.dart';

import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  final String? userName;

  const HistoryPage({super.key, required this.userName});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

void deletePage(context, String profileName) async {}
Box<UserData> box = Hive.box<UserData>('userData');
UserData userData = box.get('mainUser') ?? UserData(profiles: []);
bool empety = false;

@override
void initState() {
  box;
  userData;
  empety = userData.profiles.isEmpty;
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191C20),
      appBar: AppBar(
        leading: Tooltip(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          message: "Zurück",
          textStyle: TextStyle(color: Colors.white),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Color(0xFFe1e2e8)),
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xff272a2f),
        title: Text(
          "Anastagram",
          style: TextStyle(
            color: Color(0xFFe1e2e8),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body:
          empety
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmarks_outlined,
                      size: 100,
                      color: Color(0xFFa0cafd),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Keine gespeicherte \nprofilen",
                      style: TextStyle(
                        color: Color(0xFFa0cafd),
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
                    child: ListView.builder(
                      itemCount: userData.profiles.length,
                      itemBuilder: (context, index) {
                        return ProfileNameTile(
                          profileName:
                              userData.profiles[index].name ?? "Unbenannt",
                          deleteProfile: () async {
                            userData.profiles.removeAt(index);
                            await box.put('mainUser', userData);
                            setState(() {
                              empety = userData.profiles.isEmpty;
                            });
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
