class AppSettingsModel {
  final String contactNum1;
  final String contactNum2;
  final num deliveryCost;
  final String learnVideo;
  final int appStatus;
  final String message;
  final int type;
  final num minVal;
  final String deliverTime;
  final String androidVersion;

  const AppSettingsModel({
    this.contactNum1 = '',
    this.contactNum2 = '',
    this.deliveryCost = 0,
    this.learnVideo = '',
    this.appStatus = 1,
    this.message = '',
    this.type = 0,
    this.minVal = 0,
    this.deliverTime = '',
    this.androidVersion = '',
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      contactNum1: json['contact_num1']?.toString() ?? '',
      contactNum2: json['contact_num2']?.toString() ?? '',
      deliveryCost: _toNum(json['delevir_cost']),
      learnVideo: json['learn_video']?.toString() ?? '',
      appStatus: _toInt(json['app_status']),
      message: json['message']?.toString() ?? '',
      type: _toInt(json['type']),
      minVal: _toNum(json['min_val']),
      deliverTime: json['deliver_time']?.toString() ?? '',
      androidVersion: json['android_version']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static num _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}
