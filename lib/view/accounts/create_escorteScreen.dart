import 'package:flutter/material.dart';


class EscortScreen extends StatefulWidget {
  @override
  _EscortScreenState createState() => _EscortScreenState();
}

class _EscortScreenState extends State<EscortScreen> {
  bool isActive = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  List<FileItem> fileItems = [
    FileItem(date: 'NMI/DO/YYYY', batch: '0', docTitle: 'F:4/FGUAL', fileName: '4/FGUA/RINIO'),
    FileItem(date: 'NMI/DO/YYYY', batch: '0', docTitle: 'P:AT', fileName: 'PAT'),
    FileItem(date: 'NMI/DO/YYYY', batch: '0', docTitle: 'FIRSTAID', fileName: 'FIRSTAID'),
    FileItem(date: 'NMI/DO/YYYY', batch: '0', docTitle: 'DB3', fileName: 'DB5'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Text(
                    'ESCORT',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // ESCORT INFORMATION section
                Text(
                  'ESCORT INFORMATION',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                // Active toggle
                Row(
                  children: [
                    Text('ACTIVE'),
                    SizedBox(width: 10),
                    Switch(
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // Information fields
                _buildInfoField('NAME', nameController),
                _buildInfoField('MOBILE #', mobileController),
                _buildInfoField('EMAIL', emailController),
                _buildInfoField('DOB', dobController),
                _buildInfoField('ADDRESS', addressController, maxLines: 3),

                Divider(thickness: 1, height: 30),

                // File upload sections
                Text(
                  'EXPRINT DATE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                ...fileItems.map((item) => _buildFileItem(item)).toList(),

                SizedBox(height: 30),

                // Save button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Save functionality
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      child: Text('SAVE', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxWidth: 500),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(FileItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.date),
                SizedBox(height: 5),
                Text('BATCH # ${item.batch}'),
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DOCUMENT TITLE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(item.docTitle),
                SizedBox(height: 10),
                Text(
                  'FILE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(item.fileName),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {
                    // File selection functionality
                  },
                  child: Text('Choose File | NO FILE CHOSEN'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FileItem {
  final String date;
  final String batch;
  final String docTitle;
  final String fileName;

  FileItem({
    required this.date,
    required this.batch,
    required this.docTitle,
    required this.fileName,
  });
}