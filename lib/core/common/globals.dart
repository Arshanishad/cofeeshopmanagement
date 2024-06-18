import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String currentUserEmail="";
String currentUserID="";
String currentUserName="";
SharedPreferences? prefs;
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
var h;
var w;
