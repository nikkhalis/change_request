import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String? svgSrc, title;
  // final String? totalStorage;
  final int? numOfUsers;
  // final int? percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    // this.totalStorage,
    this.numOfUsers,
    // this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Total Users",
    numOfUsers: 13,
    svgSrc: "assets/icons/user.svg",
    // totalStorage: "1.9GB",
    color: primaryColor,
    // percentage: 35,
  ),
  CloudStorageInfo(
    title: "Google Drive",
    numOfUsers: 28,
    svgSrc: "assets/icons/google_drive.svg",
    // totalStorage: "2.9GB",
    color: Color(0xFFFFA113),
    // percentage: 35,
  ),
  CloudStorageInfo(
    title: "One Drive",
    numOfUsers: 32,
    svgSrc: "assets/icons/one_drive.svg",
    // totalStorage: "1GB",
    color: Color(0xFFA4CDFF),
    // percentage: 10,
  ),
  CloudStorageInfo(
    title: "One Drive",
    numOfUsers: 18,
    svgSrc: "assets/icons/one_drive.svg",
    // totalStorage: "1GB",
    color: Color(0xFFA4CDFF),
    // percentage: 10,
  ),

];