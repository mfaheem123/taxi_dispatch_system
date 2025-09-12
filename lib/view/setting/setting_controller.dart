


import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class SettingController  extends GetxController{
  // Add your methods and properties here


  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Template Settings functionality

  /// String variable
  String? selectedTemplateTitle;
  String? selectedTemplate;
  String? tagAssigned;

  /// text field controllers
   final templateTitleController = HtmlEditorController();

  void insertTagValue({value}) async {
    String currentText = await templateTitleController.getText();

    if (currentText.trim().isEmpty || currentText.trim() == "<p></p>") {
      // 👇 Agar text empty hai
      templateTitleController.setText("<p>{{value}}</p>");
    } else {
      // 👇 Agar text already hai
      templateTitleController.insertText(" {{$value}} ");
    }
    update();
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo Template Settings functionality

}