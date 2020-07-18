import 'package:quantifico/data/model/auth/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLocalProvider {
  final SharedPreferences sharedPreferences;
  static const emailKey = 'user_email';
  static const nameKey = 'user_name';

  const UserLocalProvider({this.sharedPreferences});

  void setUser(User user) {
    sharedPreferences.setString(emailKey, user.email);
    sharedPreferences.setString(nameKey, user.name);
  }

  void clearUser() {
    sharedPreferences.remove(emailKey);
    sharedPreferences.remove(nameKey);
  }

  User getUser() {
    final email = sharedPreferences.getString(emailKey);
    final name = sharedPreferences.getString(nameKey);
    return User(
      email: email,
      name: name,
    );
  }
}
