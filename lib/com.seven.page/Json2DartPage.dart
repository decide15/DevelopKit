import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Json2DartKit.dart';

class Json2DartPage extends StatefulWidget {
  Json2DartPage({super.key});

  @override
  State<Json2DartPage> createState() => _Json2DartPageState();
}

class _Json2DartPageState extends State<Json2DartPage> {
  TextEditingController jsonController = TextEditingController();
  TextEditingController classNameController = TextEditingController();
  late Json2DartKit jsonKit;
  var autoConvertToString = false;
  var buttonEnable = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print("ddddddddddddddddddddddd");
    jsonKit = Json2DartKit(autoConvertToString);
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Wrap(
            children: [
              buildCheckBox("把Num接受成String", (check) {
                setState(() {
                  autoConvertToString = !autoConvertToString;
                  jsonKit = Json2DartKit(autoConvertToString);
                });
              })
            ],
          ),
          TextField(
            maxLines: null,
            decoration: InputDecoration(border: InputBorder.none, hintText: "输入Class Name"),
            controller: classNameController,
            onChanged: textChange,
          ),
          ElevatedButton(onPressed: buttonEnable ? copyJson : null, child: Text("生成")),
          Expanded(
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(border: InputBorder.none, hintText: "输入json"),
              controller: jsonController,
              onChanged:textChange,
            ),
          )
        ],
      ),
    ));
  }

  void textChange(text) {
    setState(() {
      buttonEnable = (jsonController.text.isNotEmpty && jsonController.text.isNotEmpty) && isValidJson(jsonController.text);

    });
  }

  void copyJson() {
    var result = jsonKit.jsonObjToDart(classNameController.text, jsonController.text, autoConvertToString);
    Clipboard.setData(ClipboardData(text: result));
    EasyLoading.showSuccess("已复制到粘贴板");
  }
  void formatJson(){
  }
  Row buildCheckBox(String title, ValueChanged<bool?>? onChange) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: autoConvertToString,
          onChanged: onChange,
        ),
        Text(title)
      ],
    );
  }

  bool isValidJson(String jsonString) {
    try {
      jsonDecode(jsonString);
      return true;
    } catch (e) {
      return false;
    }
  }

}
