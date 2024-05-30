import 'package:admin/screens/memo/component/update_memo_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../api_calls.dart';
import '../../../models/memo_list_view.dart';

class MemoListDialog extends StatefulWidget {
  final MemoList memoItem;
  final int userId;
  final Function(bool)? callback;
  const MemoListDialog({Key? key, required this.memoItem, required this.userId, this.callback}) : super(key: key);

  @override
  State<MemoListDialog> createState() => _MemoListDialogState();
}

class _MemoListDialogState extends State<MemoListDialog> {
  bool editMemo = false;
  @override
  Widget build(BuildContext context) {
    return editMemo ? UpdateMemoForm(memoItem: widget.memoItem, callback: (submitted){
      if (submitted){
        widget.callback!(true);
      }
    },) : viewMemo();
  }

  Widget viewMemo(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Ref Num: ${widget.memoItem.refNum}' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
              widget.memoItem.creator.id != widget.userId? SizedBox() : TextButton(onPressed: widget.memoItem.memoStatus.toString() == 'Pending finance review' ||  widget.memoItem.memoStatus.toString() == 'Draft'? (){
                // Navigator.pop(context);
                setState(() {
                  editMemo = true;
                });
              } : null, child: Text("Edit Memo", style: TextStyle(color: Colors.white),), style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), backgroundColor: Colors.blueAccent),),
            ],),
            Text('Title' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            Text(widget.memoItem.title),
            Text('Date' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            Text(widget.memoItem.dateCreated),
            SizedBox(
              height: 70,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.blueAccent.shade100.withOpacity(0.1),
                          border: Border.all(color: Colors.blueAccent),
                          borderRadius: BorderRadius.circular(7)
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Proposed By' ,style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(widget.memoItem.creator.name),
                      ],)),
                  SizedBox(width: 5,),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 3),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: widget.memoItem.memoStatus.toString() == 'Pending None approval' ? Colors.green.shade100.withOpacity(0.1) : Colors.amber.shade100.withOpacity(0.1),
                          border: Border.all(color: widget.memoItem.memoStatus.toString() == 'Pending None approval' ? Colors.lightGreenAccent : Colors.amberAccent),
                          borderRadius: BorderRadius.circular(7)
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Status' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                        Text(widget.memoItem.memoStatus.toString() == 'Pending None approval' ? 'Completed' : widget.memoItem.memoStatus.toString()) ,
                      ],)),
                ],
              ),
            ),
            // Row(children: [
            //   Container(
            //       margin: EdgeInsets.symmetric(vertical: 3),
            //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //       decoration: BoxDecoration(
            //           color: Colors.blueAccent.shade100.withOpacity(0.1),
            //           border: Border.all(color: Colors.blueAccent),
            //           borderRadius: BorderRadius.circular(7)
            //       ),
            //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //         Text('Prepared By' ,style: TextStyle(fontWeight: FontWeight.bold),),
            //         Text(memoItem.creator.name),
            //       ],)),
            //   SizedBox(width: 5,),
            //   Container(
            //       margin: EdgeInsets.symmetric(vertical: 3),
            //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //       decoration: BoxDecoration(
            //           color: memoItem.memoStatus.toString() == 'Pending None approval' ? Colors.green.shade100.withOpacity(0.1) : Colors.amber.shade100.withOpacity(0.1),
            //           border: Border.all(color: memoItem.memoStatus.toString() == 'Pending None approval' ? Colors.lightGreenAccent : Colors.amberAccent),
            //           borderRadius: BorderRadius.circular(7)
            //       ),
            //       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //         Text('Status' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            //         Text(memoItem.memoStatus.toString() == 'Pending None approval' ? 'Completed' : memoItem.memoStatus.toString()) ,
            //       ],)),
            // ],),
            Divider(),
            Text('Attachment' ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            // Text(memoItem.attachment),
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 2,
                  crossAxisCount: 2,//memoItem.attachment.split(',').length == 1 ? 1 : memoItem.attachment.split(',').length == 2 ? 2 : 3,
                ),
                itemCount: widget.memoItem.attachment == "" ? 1 : widget.memoItem.attachment.split(',').length,
                itemBuilder: (BuildContext context, int index) {
                  return widget.memoItem.attachment == "" ? Center(child: Text('No attachment'),) : Padding(
                      padding: EdgeInsets.all(5),
                      child: ElevatedButton(
                        onPressed: () {
                          openFile(widget.memoItem.attachment.split(',')[index]);
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent)),
                        child: Container(
                          // width: 120,
                          // width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(5),
                          // height: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/doc_file.svg",
                                height: 30,
                                width: 30,
                              ),
                              const SizedBox(height: 15,),
                              Expanded(
                                child: Text(
                                  widget.memoItem.attachment.split(',')[index],
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  style: TextStyle(fontSize: 15, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    //   InkWell(
                    //   onTap: (){
                    //     openFile(memoItem.attachment.split(',')[index]);
                    //   },
                    //   child: DottedBorder(
                    //     borderType: BorderType.RRect,
                    //     radius: const Radius.circular(10),
                    //     dashPattern: const [10, 4],
                    //     strokeCap: StrokeCap.round,
                    //     color: Colors.white,//Colors.blue.shade400,
                    //     child: Container(
                    //       // width: 120,
                    //       // width: MediaQuery.of(context).size.width,
                    //       padding: const EdgeInsets.all(5),
                    //       // height: 120,
                    //       alignment: Alignment.center,
                    //       decoration: BoxDecoration(
                    //           color: Colors.transparent,
                    //           borderRadius: BorderRadius.circular(10)),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           SvgPicture.asset(
                    //             "assets/icons/pdf_file.svg",
                    //             height: 30,
                    //             width: 30,
                    //           ),
                    //           const SizedBox(height: 15,),
                    //           Expanded(
                    //             child: Text(
                    //               memoItem.attachment.split(',')[index],
                    //               textAlign: TextAlign.center,
                    //               overflow: TextOverflow.ellipsis,
                    //               softWrap: true,
                    //               style: TextStyle(fontSize: 15, color: Colors.white),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  );
                }
            ),
            Divider(),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.memoItem.approverList.length,
                itemBuilder: (context, index){
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 3),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.blueAccent.shade100.withOpacity(0.1),
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(7)
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                        Text('Approver ${index+1}' ,style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(widget.memoItem.approverList[index].approverName),
                      ],),
                      widget.memoItem.approverList[index].approved == 1 ? Text('Approved', style: TextStyle(color: Colors.lightGreen, fontWeight: FontWeight.bold),) : SizedBox()
                    ],),
                  );
                }
            ),
            Divider(),
            // Text('Approver 1' ,style: TextStyle(fontWeight: FontWeight.bold),),
            // Text(memoItem.approver_1.name),
            // Text('Approver 2' ,style: TextStyle(fontWeight: FontWeight.bold),),
            // Text(memoItem.approver_2.name),
            // Text('Approver 1' ,style: TextStyle(fontWeight: FontWeight.bold),),
            // Text(memoItem.approver_3.name),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(onPressed: (){Navigator.pop(context, 'Cancel');}, child: Text('Close', style: TextStyle(color: Colors.white),), style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), backgroundColor: Colors.blueAccent),),
              TextButton(onPressed: (){
                widget.memoItem.memoStatus == "3"
                    ? print('Cannot generate')
                    : widget.memoItem.memoType.name == 'SSP memo'
                    ? openPdfSSP(widget.memoItem.approvalsRef)
                    : openPdf(widget.memoItem.id.toString());
                }, child: Text("Generate Memo", style: TextStyle(color: Colors.white),), style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), backgroundColor: Colors.blueAccent),),
            ],),
            SizedBox(height: 7,)
          ],
        ),
      ),
    );
  }
}

Future<void> openFile(String filename) async {
  if (!await launchUrl(
    // Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/download?file_name=$filename')
      ApiCalls().downloadFile(filename)
  )) {
    throw Exception('Could not launch');
  }
}

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
