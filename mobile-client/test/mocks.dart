import 'package:mockito/mockito.dart';
import 'package:quantifico/data/provider/token_local_provider.dart';
import 'package:quantifico/data/provider/user_local_provider.dart';
import 'package:quantifico/util/web_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockWebClient extends Mock implements WebClient {}

class MockTokenLocalProvider extends Mock implements TokenLocalProvider {}

class MockUserLocalProvider extends Mock implements UserLocalProvider {}

class MockSharedPreferences extends Mock implements SharedPreferences {}
