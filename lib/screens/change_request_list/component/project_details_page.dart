import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../api_calls.dart';

class ProjectDetailsPage extends StatelessWidget {
  final Map<String, dynamic> projectData;

  const ProjectDetailsPage({Key? key, required this.projectData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoTile(title: 'Project Name', value: projectData['project_name']),
              _buildInfoTile(title: 'Change Name', value: projectData['change_name']),
              _buildInfoTile(title: 'Date Requested', value: projectData['date_requested']),
              _buildInfoTile(title: 'Vendor In Charge', value: projectData['vendor_in_charge']),
              _buildInfoTile(title: 'Change Description', value: projectData['change_description']),
              _buildInfoTile(title: 'Change Reason', value: projectData['change_reason']),
              _buildInfoTile(title: 'Priority', value: projectData['priority']),
              _buildInfoTile(title: 'Change Impact', value: projectData['change_impact']),
              _buildFileTile(title: 'Attached Quotation', fileName: projectData['file_name']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({required String title, required String value}) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileTile({required String title, required String? fileName}) {
    return fileName != null
        ? SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            TextButton(
              onPressed: () {
                openFile(projectData['file_name'].toString());
              },
              child: Text(
                fileName,
                style: TextStyle(
                  // decoration: TextDecoration.underline,
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        : SizedBox();
  }

  Future<void> openFile(String filename) async {
    if (!await launchUrl(
      // Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/openpdf?file_name=$filename')
        ApiCalls().viewFile(filename)
    )) {
      throw Exception('Could not launch');
    }
  }

}
