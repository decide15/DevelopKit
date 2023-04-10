class ddddd {
  ddddd();
  ddddd.fromJson(dynamic json){
    driverid = json['driverid'] ??'';
    token = json['token'] ??'';
    background = json['background'] ??0;
    appversion = json['appversion'] ??'';
    videoid = json['videoid'] ??'';

  }	String driverid = '';
  String token = '';
  num background = 0;
  String appversion = '';
  String videoid = '';

}
