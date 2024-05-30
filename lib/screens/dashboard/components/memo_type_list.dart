// import 'package:admin/models/dashboard_model.dart';
// import 'package:flutter/material.dart';
// import 'dart:math' as math;
//
// import '../../../constants.dart';
// import 'chart.dart';
// import 'memo_type_list_item.dart';
//
// class MemoType extends StatelessWidget {
//   DashboardModel memoData;
//   MemoType({
//     Key? key, required this.memoData
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     List<Color> generatedColors = colorListGenerator();
//
//     return Container(
//       padding: EdgeInsets.all(defaultPadding),
//       decoration: BoxDecoration(
//         color: secondaryColor/*secondaryColorLight*/,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//       ),
//       child:
//       // ListView.builder(
//       //     itemCount: memoData.dashboard.length,
//       //     itemBuilder: (context, index){
//       //       return Column(
//       //         children: [
//       //         StorageInfoCard(
//       //               svgSrc: "assets/icons/Documents.svg",
//       //               title: memoData.dashboard[index].typeName,
//       //               amountOfFiles: "1.3GB",
//       //               numOfFiles: memoData.dashboard[index].frequency,
//       //             ),
//       //         ],
//       //       );
//       //     }
//       // )
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "Memo Type/s",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           SizedBox(height: defaultPadding),
//           Chart(dashboardModel: memoData, generatedColors: generatedColors,),
//           ListView.builder(
//             shrinkWrap: true,
//               itemCount: memoData.memoDetails.length,
//               itemBuilder: (context, index){
//                 return Column(
//                   children: [
//                   MemoTypeListItem(
//                         svgSrc: "assets/icons/Documents.svg",
//                         iconColor: generatedColors[index],
//                         title: memoData.memoDetails[index].typeName,
//                         amountOfFiles: "",
//                         numOfFiles: memoData.memoDetails[index].frequency,
//                       ),
//                   ],
//                 );
//               }
//           ),
//           // StorageInfoCard(
//           //   svgSrc: "assets/icons/Documents.svg",
//           //   title: "Documents Files",
//           //   amountOfFiles: "1.3GB",
//           //   numOfFiles: 1328,
//           // ),
//           // StorageInfoCard(
//           //   svgSrc: "assets/icons/media.svg",
//           //   title: "Media Files",
//           //   amountOfFiles: "15.3GB",
//           //   numOfFiles: 1328,
//           // ),
//           // StorageInfoCard(
//           //   svgSrc: "assets/icons/folder.svg",
//           //   title: "Other Files",
//           //   amountOfFiles: "1.3GB",
//           //   numOfFiles: 1328,
//           // ),
//           // StorageInfoCard(
//           //   svgSrc: "assets/icons/unknown.svg",
//           //   title: "Unknown",
//           //   amountOfFiles: "1.3GB",
//           //   numOfFiles: 140,
//           // ),
//         ],
//       ),
//     );
//   }
//
//   List<Color> colorListGenerator() {
//     List<Color> generatedColor = [];
//
//     memoData.memoDetails.forEach((element) {
//       generatedColor.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
//     });
//
//     return generatedColor;
//   }
// }
