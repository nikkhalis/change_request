import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api_calls.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin/screens/change_request_list/component/project_details_page.dart';

class ChangeRequestListTable extends StatefulWidget {
  final Function callback;

  const ChangeRequestListTable({Key? key, required this.callback}) : super(key: key);

  @override
  State<ChangeRequestListTable> createState() => _ChangeRequestListTableState();
}

class _ChangeRequestListTableState extends State<ChangeRequestListTable> {
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowHeight: 70,
          dataRowMinHeight: 40,
          columns: [
            DataColumn(label: Text(
                'No.', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(
                'Project Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(
                'Change Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(
                'Date Requested',
                style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(
                'Vendor in Charge',
                style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(
                'Change Description',
                style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(
                'Change Reason',
                style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(
                'Priority', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(
                'Change Impact',
                style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text(
                'Attached Quotation', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: _data.map<DataRow>((item) {
            return DataRow(
              cells: [
                DataCell(Text(item['id'].toString())),
                DataCell(
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ProjectDetailsPage(projectData: item)),
                      );
                    },
                    child: Text(
                      item['project_name'].toString(),
                      style: TextStyle(
                        // decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(Text(item['change_name'].toString())),
                DataCell(Text(item['date_requested'].toString())),
                DataCell(Text(item['vendor_in_charge'].toString())),
                DataCell(Text(item['change_description'].toString())),
                DataCell(Text(item['change_reason'].toString())),
                DataCell(Text(item['priority'].toString())),
                DataCell(Text(item['change_impact'].toString())),
                DataCell(
                  item['file_name'] != null
                      ? TextButton(
                    onPressed: () {
                      openFile(item['file_name'].toString());
                    },
                    child: Text(
                      item['file_name'].toString(),
                      style: TextStyle(
                        // decoration: TextDecoration.underline,
                        color: Colors.green,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                      : Text(
                    '   No quotation attached',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('email') ?? '';
    String apiUrl = '${ApiCalls().viewChangeRequests()}?user_email=$userEmail';
    try {
      final http.Response response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _data = data
              .asMap()
              .entries
              .map((entry) =>
          {
            'id': entry.key + 1,
            'project_name': entry.value['project_name'],
            'change_name': entry.value['change_name'],
            'date_requested': entry.value['date_requested'],
            'vendor_in_charge': entry.value['vendor_in_charge'],
            'change_description': entry.value['change_description'],
            'change_reason': entry.value['change_reason'],
            'priority': entry.value['priority'],
            'change_impact': entry.value['change_impact'],
            'file_name': entry.value['file_name'],
          }).toList();
        });
      } else {
        throw Exception(
            'Failed to fetch project: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch project: $e');
    }
  }


  Future<void> openFile(String filename) async {
    if (!await launchUrl(
      // Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/open_pdf?file_name=$filename')
        ApiCalls().viewFile(filename)
    )) {
      throw Exception('Could not open');
    }
  }


}
