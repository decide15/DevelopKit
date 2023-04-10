import 'dart:convert';

class Json2DartKit {
  late final bool _autoConvertToString;
  String? extendsClassName = "BaseModel";
  List<String>? superClassVariable = ["success", "status", "msg"];
  List<String> _clax = [];

  Json2DartKit(bool autoConvertToString) {
    _autoConvertToString = autoConvertToString;
  }

  String jsonObjToDart(String className, String jsonStr, bool autoConvertToString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    _jsonToClass(className, jsonMap, superClassVariable: superClassVariable, extendsClassName: extendsClassName);
    StringBuffer stringBuffer = StringBuffer();
    for (var o in _clax) {
      stringBuffer.write(o.toString());
      stringBuffer.write("\n");
    }
    return stringBuffer.toString();
  }

  _jsonToClass(String className, Map<String, dynamic> jsonMap, {String? extendsClassName, List<String>? superClassVariable}) {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write("class $className ");
    if (extendsClassName != null) {
      stringBuffer.write("extends $extendsClassName");
    }
    stringBuffer.write("{\n");
    stringBuffer.write(_buildConstructor(className, jsonMap, extendsClassName: extendsClassName, superClassVariable: superClassVariable));
    stringBuffer.write(_buildFromJson(className, jsonMap, extendsClassName: extendsClassName, superClassVariable: superClassVariable));
    stringBuffer.write("\n");
    stringBuffer.write(_buildToJson(className, jsonMap));
    stringBuffer.write("\n");
    jsonMap.forEach((key, value) {
      if (superClassVariable?.contains(key) != true) {
        stringBuffer.write("\t");
        stringBuffer.write(_getTypeName(key, value));
        stringBuffer.write(" ");
        stringBuffer.write(key);
        stringBuffer.write(" = ");
        stringBuffer.write(_getDefaultValue(value, key));
        stringBuffer.write(";\n");
      }
    });
    stringBuffer.write('\n}');
    stringBuffer.toString();
    if (!_clax.contains(stringBuffer.toString())) {
      _clax.insert(0, stringBuffer.toString());
    }
  }

  String _buildConstructor(String className, Map<String, dynamic> jsonMap, {String? extendsClassName, List<String>? superClassVariable}) {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write("\t$className();\n");
    return stringBuffer.toString();
  }

  String _buildFromJson(String className, Map<String, dynamic> jsonMap, {String? extendsClassName, List<String>? superClassVariable}) {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write("\t");
    stringBuffer.write(className);
    stringBuffer.write(".");
    stringBuffer.write("fromJson");
    stringBuffer.write("(");
    stringBuffer.write("dynamic json");
    stringBuffer.write(")");
    stringBuffer.write("{\n");
    if(extendsClassName!=null){
      stringBuffer.write("\tsuper.fromJson(json)");
      stringBuffer.write("\n");
    }
    jsonMap.forEach((key, value) {
      if (superClassVariable?.contains(key) != true) {
        stringBuffer.write("\t");
        stringBuffer.write(key);
        stringBuffer.write(" = ");
        stringBuffer.write(_obtainValueFromJson(key, value));
        stringBuffer.write(";\n");
      }
    });
    stringBuffer.write("\n}");
    return stringBuffer.toString();
  }

  String _obtainValueFromJson(String key, dynamic value) {
    StringBuffer stringBuffer = StringBuffer();
    if (_autoConvertToString && value is num) {
      stringBuffer.write("json['$key']?.toString() ??");
      stringBuffer.write(_getDefaultValue(value, key));
    } else if (value is Map) {
      stringBuffer.write("json['$key']==null? ${_getClassName(key)}() : ${_getClassName(key)}.fromJson(json['$key'])");
    } else {
      stringBuffer.write("json['$key'] ??");
      stringBuffer.write(_getDefaultValue(value, key));
    }

    return stringBuffer.toString();
  }

  String _getClassName(String key) {
    return key[0].toUpperCase() + key.substring(1);
  }

  String _getTypeName(String key, dynamic value) {
    if (value is String) {
      return "String";
    } else if (value is num) {
      if (_autoConvertToString) {
        return "String";
      } else {
        return "num";
      }
    } else if (value is bool) {
      return "bool";
    } else if (value is List) {
      return _getListTypeName(key, value);
    } else if (value is Map<String, dynamic>) {
      _jsonToClass(_getClassName(key), value);
      return _getClassName(key);
    } else {
      print('可恶！不支持的类型==========================');
      return "dynamic?";
    }
  }

  String _getListTypeName(String key, List value) {
    if (value.isNotEmpty && _isListOnlyOneType(key, value)) {
      return "List<${_getTypeName(key, value.first)}>";
    }
    return "List";
  }

//判断list是什么类型都有，还是只有一种类型
  bool _isListOnlyOneType(String key, List value) {
    String? tempType;
    for (var o in value) {
      String t = _getTypeName(key, o);
      if (tempType == null) {
        tempType = t;
      } else {
        if (tempType != t) {
          return false;
        }
      }
    }
    return true;
  }

  String _getDefaultValue(dynamic value, String key) {
    if (value is String) {
      return "''";
    } else if (value is num) {
      if (_autoConvertToString) {
        return "''";
      }
      return "0";
    } else if (value is bool) {
      return "false";
    } else if (value is List) {
      return "[]";
    } else if (value is Map) {
      return "${_getClassName(key)}()";
    } else {
      print('可恶！不支持的类型==========================');
      return "null";
    }
    return "List";
  }

  String _buildToJson(String className, Map<String, dynamic> jsonMap, {String? extendsClassName, List<String>? superClassVariable}) {
    StringBuffer stringBuffer = StringBuffer();
    stringBuffer.write("Map<String,dynamic> toJson(){\n");
    stringBuffer.write("\tfinal map = <String,dynamic>{};\n");
    if (extendsClassName != null) {
      stringBuffer.write("\tmap.addAll(super.toJson());");
    }
    jsonMap.forEach((key, value) {
      if(superClassVariable?.contains(key)!=true){
        stringBuffer.write("\tmap['$key'] = $key;\n");
      }
    });
    stringBuffer.write("\treturn map;\n");
    stringBuffer.write("}");
    return stringBuffer.toString();
  }


}
