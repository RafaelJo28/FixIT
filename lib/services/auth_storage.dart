// Persistent storage for the FixIT auth token and basic user profile.
//
// Backed by `shared_preferences`. All data survives app restarts but is
// cleared on logout or app uninstall.
import 'package:shared_preferences/shared_preferences.dart';

/// Keys used in SharedPreferences.
class _Keys {
  static const token = 'fixit_auth_token';
  static const phone = 'fixit_user_phone';
  static const userRole = 'fixit_user_role';
  static const userName = 'fixit_user_name';
  static const isVendor = 'fixit_user_is_vendor';
}

/// Singleton wrapper around SharedPreferences.
class AuthStorage {
  AuthStorage._();

  static final AuthStorage instance = AuthStorage._();
  SharedPreferences? _prefs;

  /// Initializes the underlying SharedPreferences instance.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    if (_prefs == null) {
      throw StateError('AuthStorage not initialized. Call AuthStorage.instance.init() first.');
    }
    return _prefs!;
  }

  /// The JWT/auth token, or null if not logged in.
  String? get token => _p.getString(_Keys.token);

  /// The phone number of the logged-in user (E.164 format).
  String? get phone => _p.getString(_Keys.phone);

  /// The logged-in user's role: 'customer' or 'vendor'.
  String? get role => _p.getString(_Keys.userRole);

  /// The logged-in user's display name.
  String? get name => _p.getString(_Keys.userName);

  /// Whether the logged-in user is a vendor.
  bool get isVendor => _p.getBool(_Keys.isVendor) ?? false;

  /// Persists login state after a successful OTP verification.
  Future<void> saveLogin({
    required String token,
    required String phone,
    required String role,
    String? name,
  }) async {
    await _p.setString(_Keys.token, token);
    await _p.setString(_Keys.phone, phone);
    await _p.setString(_Keys.userRole, role);
    if (name != null) {
      await _p.setString(_Keys.userName, name);
    }
    await _p.setBool(_Keys.isVendor, role == 'vendor');
  }

  /// Clears all persisted auth data.
  Future<void> clear() async {
    await _p.remove(_Keys.token);
    await _p.remove(_Keys.phone);
    await _p.remove(_Keys.userRole);
    await _p.remove(_Keys.userName);
    await _p.remove(_Keys.isVendor);
  }
}