import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io' as IO;

class AuthService {
  Dio dio = Dio();

  login(name, password) async{
    try {
      if(IO.Platform.isAndroid) {
        return await dio.post('http://10.0.2.2:3000/authenticate', data : {
          "name": name,
          "password": password
          }, options: Options(contentType: Headers.formUrlEncodedContentType )
        );
      } else {
        return await dio.post('http://172.20.10.4:3000/authenticate', data : {
          "name": name,
          "password": password
        },
        );
      }
    }
    on DioError catch(e) {
      Fluttertoast.showToast(msg: e.response?.data['msg'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
      );
    }
  }


  sendAudio(String file) async{
    try {

      print("test fonction sendaudio");
      // create FormData object to send data as multipart/form-data
      FormData formData = FormData.fromMap({
        "audio": await MultipartFile.fromFile(file, filename: "audio.wav"),
      });

      print(formData);


      if(IO.Platform.isAndroid) {
        return await dio.post('http://10.0.2.2:3000/audiosend', data : formData, options: Options(
          headers: { IO.HttpHeaders.contentTypeHeader: 'multipart/form-data' },
        ),
        );

      } else {
        return await dio.post('http://172.20.10.4:3000/audiosend', data : {
          "name": "audio",
          "audio": formData
        },
        );
      }
    }
    on DioError catch(e) {
      Fluttertoast.showToast(msg: e.response?.data['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }


}
