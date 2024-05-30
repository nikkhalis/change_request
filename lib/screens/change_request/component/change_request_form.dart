import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../api_calls.dart';
import '../../login/login_screen.dart';

class ChangeRequestForm extends StatefulWidget {
  final void Function(String) onProjectNameSelected;

  const ChangeRequestForm({Key? key, required this.onProjectNameSelected, required GlobalKey<NavigatorState> navigatorKey}) : super(key: key);

  @override
  _ChangeRequestFormState createState() => _ChangeRequestFormState();
}

class _ChangeRequestFormState extends State<ChangeRequestForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> fileNames = [];
  List<bool> uploadStatus = [];
  List<File> attachmentFiles = [];
  List<PlatformFile> attachmentFilesWeb = [];

  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  String _userEmail = '';
  String _userName = '';
  String _projectName = '';
  String _changeName = '';
  DateTime? _dateRequested;
  String _vendorInCharge = '';
  String _changeDescription = '';
  String _changeReason = '';
  String _priority = '-';
  String _changeImpact = '';
  String? _fileNames;
  List<String> _priorityOptions = ['-','High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.white,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Requester\'s Name : ' + _userName,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              initialValue: _userName,
              enabled: false,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email Address : ' + _userEmail,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              initialValue: _userEmail,
              enabled: false,
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Project Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Project Name';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _projectName = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Change Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Change Name';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _changeName = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Date Requested',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dateRequested = pickedDate;
                    _dateController.text = _dateFormat.format(pickedDate);
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select Date Requested';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Vendor In Charge',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Vendor In Charge';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _vendorInCharge = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Change Description',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Change Description';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _changeDescription = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Change Reason',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Change Reason';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _changeReason = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _priority,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              items: _priorityOptions.map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _priority = value!;
                });
              },
              validator: (value) {
                if (value == '-' ) {
                  return 'Please select Priority';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Change Impact',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Change Impact';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _changeImpact = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            Text(
              'Attach Quotation (Optional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: fileNames.length,
                itemBuilder: (context, index){
                  return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(fileNames[index], overflow: TextOverflow.ellipsis,),
                    uploadStatus[index] ? IconButton(onPressed: (){
                      deleteFile(fileNames[index])
                          .then((value){
                        setState(() {
                          if (value == 'success') {
                            if (kIsWeb){
                              attachmentFilesWeb.removeAt(index);
                            } else {
                              attachmentFiles.removeAt(index);
                            }
                            fileNames.removeAt(index);
                            _fileNames = fileNames.join(",");
                          }
                        });
                      })
                          .onError((error, stackTrace) {});
                    }, icon: Icon(Icons.delete)) : Container(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), height: 25, width: 25, child: CircularProgressIndicator(strokeWidth: 2,))
                  ],);
                }
            ),
            InkWell(
              onTap: () async {
                pickFile();
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [10, 4],
                strokeCap: StrokeCap.round,
                color: Colors.blueGrey,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  height: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder,
                        color: Colors.blue,
                        size: 40,
                      ),
                      const SizedBox(height: 15,),
                      Text(
                        'Select Document',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 18.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _submitForm();
                  _clearForm();
                }
              },
              child: Text('Submit'),
            ),
            SizedBox(height: 18.0),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    Map<String, dynamic> requestData = {
      'userName': _userName,
      'userEmail': _userEmail,
      'projectName': _projectName,
      'changeName': _changeName,
      'dateRequested': _dateRequested.toString(),
      'vendorInCharge': _vendorInCharge,
      'changeDescription': _changeDescription,
      'changeReason': _changeReason,
      'priority': _priority,
      'changeImpact': _changeImpact,
      'fileNames': _fileNames,
    };

    var url = Uri.parse('http://localhost:5000/submit_change_request');
    var response = await http.post(
      url,
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Change request submitted successfully'),
          duration: Duration(seconds: 4),
        ),
      );

      widget.onProjectNameSelected(_projectName);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to submit change request. Please try again later.'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userName = prefs.getString('name') ?? '';
      _userEmail = prefs.getString('email') ?? '';
      _projectName = prefs.getString('project_name') ?? '';
    });
  }

  Future<void> pickFile () async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(withReadStream: true);

      if (result != null) {
        if (kIsWeb){
          setState(() {
            String newFileName = result.files.single.name;
            fileNames.add(newFileName);
            uploadStatus.add(false);
            uploadFileWeb(result.files.single, newFileName)
                .then((value) {
              setState(() {
                if (value != '') {
                  attachmentFilesWeb.add(result.files.single);
                  _fileNames = (fileNames.join(","));
                  uploadStatus[uploadStatus.length - 1] = true;
                  fileNames[fileNames.length - 1] = value;
                } else {
                  fileNames.removeLast();
                  uploadStatus.removeLast();
                }
              });
            })
                .onError((error, stackTrace) {
              print(error);
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File failed to upload', style: TextStyle(
                        color: Colors.white),),
                    backgroundColor: Colors.redAccent,),
                );
                fileNames.removeLast();
                uploadStatus.removeLast();
              });
            });
          });
        } else {
          setState(() {
            String newFileName = result.files.single.name;
            fileNames.add(newFileName);
            uploadStatus.add(false);
            uploadFile(File(result.files.single.path!))
                .then((value) {
              setState(() {
                if (value != '') {
                  attachmentFiles.add(File(result.files.single.path!));
                  _fileNames = (fileNames.join(","));
                  uploadStatus[uploadStatus.length - 1] = true;
                  fileNames[fileNames.length - 1] = value;
                } else {
                  fileNames.removeLast();
                  uploadStatus.removeLast();
                }
              });
            })
                .onError((error, stackTrace) {
              print(error);
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('File failed to upload', style: TextStyle(
                        color: Colors.white),),
                    backgroundColor: Colors.redAccent,),
                );
                fileNames.removeLast();
                uploadStatus.removeLast();
              });
            });
          });
        }
      } else {
        // User canceled the picker
      }
    } catch (e){
      print(e);
    }
  }

  Future<String> uploadFile(File attachment) async {
    Uri url = ApiCalls().upload();
    var request = new http.MultipartRequest('POST', url);
    final httpImage = http.MultipartFile.fromBytes(
        'file', await attachment.readAsBytes(), filename: attachment.path
        .split("/")
        .last);
    request.files.add(httpImage);
    final response = await request.send();
    String fileName = '';
    if (response.statusCode == 200) {
      final temp = await response.stream
          .transform(utf8.decoder)
          .first
          .whenComplete(() => null);
      fileName = jsonDecode(temp)['fileName'];
      return fileName;
    } else {
      return Future.error("failed");
    }
  }

  Future<String> uploadFileWeb(PlatformFile attachment, String filename) async {
    Map<String, String> headers = {
      "Access-Control-Allow-Origin": "*"
    };
    Uri url = ApiCalls().upload();
    var request = new http.MultipartRequest('POST', url,);
    final httpImage = http.MultipartFile(
      'file', attachment.readStream!, attachment.size,
      filename: attachment.name,);
    request.files.add(httpImage);
    request.headers.addAll(headers);
    final response = await request.send();
    String fileName = '';
    String result = await response.stream.bytesToString();
    final jsonData = jsonDecode(result);

    if (response.statusCode == 200) {
      fileName = jsonData['fileName'];
      return fileName;
    } else {
      return Future.error("failed");
    }
  }

  Future<String> deleteFile(String filename) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Authorization': '${prefs.getString('token')}'
    };
    Uri url = ApiCalls().deleteFile(filename);
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      return 'success';
    } else {
      return Future.error('Error');
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    setState(() {
      _changeName = '';
      _dateRequested = null;
      _vendorInCharge = '';
      _changeDescription = '';
      _changeReason = '';
      _priority = '-';
      _changeImpact = '';
      _fileNames = '';
      fileNames.clear();
      uploadStatus.clear();
      attachmentFiles.clear();
      attachmentFilesWeb.clear();
      _dateController.clear();
    });
  }
}
