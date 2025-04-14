import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SelectedPorject extends StatefulWidget {
  const SelectedPorject({super.key});

  @override
  State<SelectedPorject> createState() => _SelectedPorjectState();
}

class _SelectedPorjectState extends State<SelectedPorject> {
  late TextEditingController _selectProjectController;
  @override
  void initState() {
    _selectProjectController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Row(
        spacing: 30,
        children: [
          Expanded(
            child: TextFormField(
              readOnly: true,
              controller: _selectProjectController,
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Select Project')),
        ],
      ),
    );
  }

  _selectProject()async {
    final result =await FilePicker.platform.getDirectoryPath();
    if(result!=null){

    }

  }

  @override
  void dispose() {
    _selectProjectController.dispose();
    super.dispose();
  }
}
