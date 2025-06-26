import 'package:shared_preferences/shared_preferences.dart';

class StoreObject<T> {
  final String key;
  final T? initialValue;

  StoreObject({required this.key, this.initialValue}) {
    if (initialValue != null) {
      get().then((value) {
        if (value == null) set(initialValue as T);
      });
    }
  }

  Future<T?> get() async {
    final prefs = await SharedPreferences.getInstance();

    if (T == String) return prefs.getString(key) as T?;
    if (T == int) return prefs.getInt(key) as T?;
    if (T == bool) return prefs.getBool(key) as T?;
    if (T == double) return prefs.getDouble(key) as T?;
    if (T == List<String>) return prefs.getStringList(key) as T?;

    throw UnsupportedError('Unsupported type $T');
  }

  Future<void> set(T value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      throw UnsupportedError('Unsupported type $T');
    }
  }

  Future<void> remove() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  @override
  String toString() => '$key: $T';
}
