import 'package:admin/api_calls.dart';
import 'package:admin/models/RecentFile.dart';
import 'package:admin/models/demo_memo_list.dart';
import 'package:admin/models/memo_list_view.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/memo/component/memo_lists_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants.dart';

class MemoLists extends StatefulWidget {
  final Function(bool) callBack;
  final MemoListView? memoListView;
  final int userId;

  const MemoLists({
    Key? key,
    required this.callBack,
    required this.memoListView,
    this.userId = 0,
  }) : super(key: key);

  @override
  State<MemoLists> createState() => _MemoListsState();
}

class _MemoListsState extends State<MemoLists> {
  DateTime lastDayLastMonth = DateTime.utc(DateTime.now().year, DateTime.now().month, 1).subtract(Duration(days: 1));
  DateTime chooseDate = DateTime.utc(DateTime.now().year, DateTime.now().month, 1).subtract(Duration(days: 1));

  List<bool> checklistBool = [];
  bool idSortAscending = true;
  bool dateSortAscending = true;
  List<MemoList>? memoListViewNew;

  @override
  void initState() {
    super.initState();
    memoListViewNew = widget.memoListView?.memoList;
  }

  @override
  void dispose() {
    super.dispose();
    checklistBool.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor/*secondaryColorLight*/,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Memo Lists",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          memoListViewNew!.isEmpty || memoListViewNew == null ?
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              child: Center(child: Text('No memo records found'),)
          )
              :
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            child: DataTable2(
              // onSelectAll: (checked) {
              //   setState(() {
              //     checklistBool.fillRange(0, checklistBool.length, checked);
              //     widget.callBack.call(checked!);
              //   });
              // },
              showCheckboxColumn: false,
              columnSpacing: defaultPadding,
              minWidth: 600,
              columns: [
                DataColumn2(
                  label: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Ref Num", style: TextStyle(color: textColor,),), Responsive.isMobile(context) ? SizedBox() : Icon(idSortAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down)],),
                  size: ColumnSize.M,
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      idSortAscending = !idSortAscending;
                      if (idSortAscending) {
                        // print('1 idSortAscending: $idSortAscending \ndateSortAscending: $dateSortAscending');
                        // dateSortAscending = true;
                        // memoListViewNew = widget.memoListView?.memoList;
                        // memoListViewNew = memoListViewNew?.reversed.toList();
                        memoListViewNew?.sort((a,b) => a.id.compareTo(b.id));
                      } else {
                        dateSortAscending = true;
                        // memoListViewNew = widget.memoListView?.memoList;
                        // print('3 idSortAscending: $idSortAscending \ndateSortAscending: $dateSortAscending');
                        // memoListViewNew = memoListViewNew?.reversed.toList();
                        memoListViewNew?.sort((a,b) => b.id.compareTo(a.id));
                      }

                    });
                  }
                ),
                DataColumn(
                  label: Text("Title"),
                ),
                DataColumn(
                  label: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Date", style: TextStyle(color: textColor,),), Responsive.isMobile(context) ? SizedBox() : Icon(dateSortAscending ? Icons.arrow_drop_up : Icons.arrow_drop_down)],),
                  onSort: (columnIndex, ascending) {
                    setState(() {
                      dateSortAscending = !dateSortAscending;
                      if (dateSortAscending) {
                        memoListViewNew?.sort((a,b) =>
                            a.dateCreated.compareTo(b.dateCreated)
                        );
                      } else {
                        memoListViewNew?.sort((a,b) =>
                            b.dateCreated.compareTo(a.dateCreated)
                        );
                      }
                      // memoListViewNew?.sort((a,b) =>
                      //   a.dateCreated.compareTo(b.dateCreated)
                      // );
                      // memoListViewNew[columnIndex].dateCreated; /// need to think how to update this object
                    });
                  }
                ),
                DataColumn2(
                  label: Text("Proposed By"),
                  size: ColumnSize.L
                ),
                DataColumn2(
                  label: Text("Attachment"),
                  size: ColumnSize.L
                ),
                DataColumn2(
                    label: Text("Status"),
                    size: ColumnSize.L
                ),
                // DataColumn(label: Checkbox(
                //   onChanged: (bool){},
                //   value: false,
                // ))
              ],
              rows: List.generate(
                memoListViewNew!.length,// demoRecentFiles.length,
                (index) {
                  for(int i = 0; i < memoListViewNew!.length; i++){
                    checklistBool.add(false);
                  }
                  return DataRow(
                    selected: checklistBool[index],
                    onSelectChanged: (checked) {
                      // print('saje test');
                      setState(() {
                        if (checked!) {
                          print('$index selected');
                        } else {
                          print('$index deselected');
                        }
                        checklistBool[index] = checked!;
                      });
                    },
                    cells: [
                      DataCell(Text(memoListViewNew![index].refNum.toString())),
                      DataCell(Text(memoListViewNew![index].title, maxLines: 2, overflow: TextOverflow.ellipsis,), onTap: () => _showMyDialog(context, memoListViewNew![index], widget.userId, widget.callBack)),
                      DataCell(Text(stringToDate(memoListViewNew![index].dateCreated)/*memoListViewNew![index].dateCreated*/), onTap: () => _showMyDialog(context, memoListViewNew![index], widget.userId, widget.callBack)),
                      DataCell(Text(memoListViewNew![index].creator.name), onTap: () => _showMyDialog(context, memoListViewNew![index], widget.userId, widget.callBack)),
                      DataCell(Text(memoListViewNew![index].attachment), onTap: () => _showMyDialog(context, memoListViewNew![index], widget.userId, widget.callBack)),
                      DataCell(Text(memoListViewNew![index].memoStatus == 'Pending None approval' ? 'Completed' : memoListViewNew![index].memoStatus, style: TextStyle(color: memoListViewNew![index].memoStatus == 'Pending None approval' ? Color(0xff49C0A8) : Colors.amber.shade600),), onTap: () => _showMyDialog(context, memoListViewNew![index], widget.userId, widget.callBack))
                      // DataCell(SizedBox()),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// DataRow recentFileDataRow(MemoItem memoItem, BuildContext context, int index) {
//   return DataRow(
//     // selected: ,
//     onSelectChanged: (checked) {
//       print('saje test');
//       // isChecked = checked!;
//     },
//     cells: [
//       DataCell(Text(memoItem.id!)),
//       DataCell(Text(memoItem.title!, maxLines: 2, overflow: TextOverflow.ellipsis,)),
//       DataCell(Text(memoItem.date!)),
//       DataCell(Text(memoItem.preparedBy!)),
//       DataCell(Text(memoItem.attachment!)),
//       DataCell(Text(memoItem.status!))
//       // DataCell(SizedBox()),
//     ],
//   );
// }

Future<void> openPdf(String id) async {
  if (!await launchUrl(
      ApiCalls().openPdf(id)//Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/get_pdf?memo_id=$id')
  )) {
    throw Exception('Could not launch');
  }
}

Future<void> openPdfSSP(String memo_ref) async {
  if (!await launchUrl(
      ApiCalls().openPdfSSP(memo_ref)//Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/get_pdf_ssp?memo_ref=$memo_ref')
  )) {
    throw Exception('Could not launch');
  }
}

Future<void> _showMyDialog(BuildContext context, MemoList memoItem, int userId, Function(bool) callback) async {
  // print(memoItem.attachment);
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => Dialog(
      child: MemoListDialog(memoItem: memoItem, userId: userId, callback: (submitted){
        if (submitted) {
          callback(true);
        }
      },),
    ),
  );
}

Future<void> openFile(String filename) async {
  if (!await launchUrl(
      // Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/download?file_name=$filename')
    ApiCalls().downloadFile(filename)
  )) {
    throw Exception('Could not launch');
  }
}

String stringToDate(String datetimeStr) {
  // DateFormat('E, d MMM yyyy HH:mm:ss').parse(datetimeStr);
  return DateFormat('E, d MMM yyyy HH:mm:ss').format(DateFormat('E, d MMM yyyy HH:mm:ss').parse(datetimeStr));
}
