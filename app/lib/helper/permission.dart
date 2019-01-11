import 'package:simple_permissions/simple_permissions.dart';

class PermissionHelper {
  PermissionHelper();
  Permission _permission;

  void setPermission(permission) {
    _permission = permission;
  }

  // 권한 확인
  Future<bool> checkPermission() async {
    return await SimplePermissions.checkPermission(_permission);
  }

  //권한 요청
  Future<PermissionStatus> requestPermission() async {
    return await SimplePermissions.requestPermission(_permission);
  }

  //권한 상태
  Future<PermissionStatus> getPermissionStatus() async {
    return await SimplePermissions.getPermissionStatus(_permission);
  }

  //설정 열기
  void openSetting() {
    SimplePermissions.openSettings();
  }
}
