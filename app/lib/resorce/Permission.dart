import 'package:air/helper/permission.dart';
import 'package:simple_permissions/simple_permissions.dart';

class PermissionResource {
  PermissionHelper _permissionHelper;
  PermissionStatus _permissionStatus;

  PermissionResource() {
    _permissionHelper = new PermissionHelper();
  }

  Future<void> permissionCheck() async {
    _permissionHelper.setPermission(Permission.AccessFineLocation);
    await _permissionHelper.checkPermission();
    await _permissionHelper.requestPermission();
    _permissionStatus = await _permissionHelper.getPermissionStatus();
    if (_permissionStatus != PermissionStatus.authorized) {
      _permissionHelper.openSetting();
    }
  }
}
