import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:app/core/class/statusrequest.dart';
import 'package:app/core/function/checkinternet.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class Crud {
  // إعدادات افتراضية
  static const Duration _defaultTimeout = Duration(seconds: 30);
  static const Map<String, String> _defaultHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
    "User-Agent":
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36",
  };

  // دالة POST للبيانات العادية
  Future<Either<StatusRequest, dynamic>> postData(
    String linkurl,
    Map data, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      if (await checkInternet()) {
        final requestHeaders = {..._defaultHeaders, ...?headers};

        final response = await http
            .post(
              Uri.parse(linkurl),
              headers: requestHeaders,
              body: jsonEncode(data),
            )
            .timeout(timeout ?? _defaultTimeout);

        return _handleResponse(response);
      } else {
        return Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // دالة POST للملفات
  Future<Either<StatusRequest, dynamic>> postFile(
    String linkurl,
    Map data,
    File file, {
    Map<String, String>? headers,
    Duration? timeout,
    String fileFieldName = "file",
  }) async {
    try {
      if (await checkInternet()) {
        var request = http.MultipartRequest("POST", Uri.parse(linkurl));

        // إضافة headers
        final requestHeaders = {..._defaultHeaders, ...?headers};
        request.headers.addAll(requestHeaders);

        // إضافة الملف
        var length = await file.length();
        var stream = http.ByteStream(file.openRead());
        var multipartFile = http.MultipartFile(
          fileFieldName,
          stream,
          length,
          filename: basename(file.path),
        );
        request.files.add(multipartFile);

        // إضافة البيانات
        data.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // إرسال الطلب
        var streamedResponse = await request.send().timeout(
          timeout ?? _defaultTimeout,
        );
        var response = await http.Response.fromStream(streamedResponse);

        return _handleResponse(response);
      } else {
        return Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // دالة GET للاستعلام عن البيانات
  Future<Either<StatusRequest, dynamic>> getData(
    String linkurl,
    Map<String, dynamic> map, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Duration? timeout,
  }) async {
    try {
      if (await checkInternet()) {
        final requestHeaders = {..._defaultHeaders, ...?headers};

        // إضافة query parameters إذا وجدت
        Uri uri = Uri.parse(linkurl);
        if (queryParameters != null && queryParameters.isNotEmpty) {
          uri = uri.replace(queryParameters: queryParameters);
        }

        final response = await http
            .get(uri, headers: requestHeaders)
            .timeout(timeout ?? _defaultTimeout);

        return _handleResponse(response);
      } else {
        return Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // دالة PUT لتحديث البيانات
  Future<Either<StatusRequest, dynamic>> putData(
    String linkurl,
    Map data, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      if (await checkInternet()) {
        final requestHeaders = {..._defaultHeaders, ...?headers};

        final response = await http
            .put(
              Uri.parse(linkurl),
              headers: requestHeaders,
              body: jsonEncode(data),
            )
            .timeout(timeout ?? _defaultTimeout);

        return _handleResponse(response);
      } else {
        return Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // دالة PATCH لتحديث جزئي للبيانات
  Future<Either<StatusRequest, dynamic>> patchData(
    String linkurl,
    Map data, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      if (await checkInternet()) {
        final requestHeaders = {..._defaultHeaders, ...?headers};

        final response = await http
            .patch(
              Uri.parse(linkurl),
              headers: requestHeaders,
              body: jsonEncode(data),
            )
            .timeout(timeout ?? _defaultTimeout);

        return _handleResponse(response);
      } else {
        return Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // دالة DELETE لحذف البيانات
  Future<Either<StatusRequest, dynamic>> deleteData(
    String linkurl, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      if (await checkInternet()) {
        final requestHeaders = {..._defaultHeaders, ...?headers};

        final response = await http
            .delete(Uri.parse(linkurl), headers: requestHeaders)
            .timeout(timeout ?? _defaultTimeout);

        return _handleResponse(response);
      } else {
        return Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // دالة لرفع عدة ملفات
  Future<Either<StatusRequest, dynamic>> postMultipleFiles(
    String linkurl,
    Map data,
    List<File> files, {
    Map<String, String>? headers,
    Duration? timeout,
    String fileFieldName = "files",
  }) async {
    try {
      if (await checkInternet()) {
        var request = http.MultipartRequest("POST", Uri.parse(linkurl));

        // إضافة headers
        final requestHeaders = {..._defaultHeaders, ...?headers};
        request.headers.addAll(requestHeaders);

        // إضافة الملفات
        for (int i = 0; i < files.length; i++) {
          var file = files[i];
          var length = await file.length();
          var stream = http.ByteStream(file.openRead());
          var multipartFile = http.MultipartFile(
            '$fileFieldName[$i]',
            stream,
            length,
            filename: basename(file.path),
          );
          request.files.add(multipartFile);
        }

        // إضافة البيانات
        data.forEach((key, value) {
          request.fields[key] = value.toString();
        });

        // إرسال الطلب
        var streamedResponse = await request.send().timeout(
          timeout ?? _defaultTimeout,
        );
        var response = await http.Response.fromStream(streamedResponse);

        return _handleResponse(response);
      } else {
        return Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // دالة لتحميل الملفات
  Future<Either<StatusRequest, File>> downloadFile(
    String linkurl,
    String savePath, {
    Map<String, String>? headers,
    Duration? timeout,
    Function(int received, int total)? onProgress,
  }) async {
    try {
      if (await checkInternet()) {
        final requestHeaders = {..._defaultHeaders, ...?headers};

        final request = http.Request('GET', Uri.parse(linkurl));
        request.headers.addAll(requestHeaders);

        final streamedResponse = await request.send().timeout(
          timeout ?? _defaultTimeout,
        );

        if (streamedResponse.statusCode == 200) {
          final file = File(savePath);
          final sink = file.openWrite();

          int received = 0;
          final total = streamedResponse.contentLength ?? 0;

          await for (final chunk in streamedResponse.stream) {
            sink.add(chunk);
            received += chunk.length;
            onProgress?.call(received, total);
          }

          await sink.close();
          return Right(file);
        } else {
          return Left(StatusRequest.serverfailure);
        }
      } else {
        return Left(StatusRequest.offlinefailure);
      }
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  // دالة مساعدة لمعالجة الاستجابة
  Either<StatusRequest, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        dynamic responseBody = jsonDecode(response.body);
        return Right(responseBody);
      } catch (e) {
        // إذا لم يكن JSON صالح، إرجاع النص
        return Right({"message": response.body, "status": response.statusCode});
      }
    } else if (response.statusCode == 401) {
      return Left(StatusRequest.unauthorized);
    } else if (response.statusCode == 403) {
      return Left(StatusRequest.forbidden);
    } else if (response.statusCode == 404) {
      return Left(StatusRequest.notFound);
    } else if (response.statusCode >= 500) {
      return Left(StatusRequest.serverfailure);
    } else {
      return Left(StatusRequest.serverfailure);
    }
  }

  // دالة مساعدة لمعالجة الاستثناءات
  StatusRequest _handleException(dynamic exception) {
    if (exception is SocketException) {
      return StatusRequest.offlinefailure;
    } else if (exception is HttpException) {
      return StatusRequest.serverfailure;
    } else if (exception is FormatException) {
      return StatusRequest.serverfailure;
    } else {
      return StatusRequest.serverException;
    }
  }

  // دالة للحصول على حالة الاتصال
  Future<bool> isConnected() async {
    return await checkInternet();
  }
}
