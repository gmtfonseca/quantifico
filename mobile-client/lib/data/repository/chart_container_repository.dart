import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChartContainerRepository {
  final SharedPreferences sharedPreferences;

  ChartContainerRepository({
    @required this.sharedPreferences,
  });

  Future<void> changeColor(String chartName, int color) async {
    await sharedPreferences.setString('${chartName}_color', color.toString());
  }

  int getColor(String chartName) {
    final color = sharedPreferences.getString('${chartName}_color');
    return color != null ? int.parse(color) : null;
  }

  Future<void> star(String chartName) async {
    final starred = getStarred();
    starred.add(chartName);
    await sharedPreferences.setStringList('starred', starred);
  }

  Future<void> unstar(String chartName) async {
    final starred = getStarred();
    starred.remove(chartName);
    await sharedPreferences.setStringList('starred', starred);
  }

  bool isStarred(String chartName) {
    final starred = sharedPreferences.getStringList('starred') ?? [];
    return starred.contains(chartName);
  }

  List<String> getStarred() {
    return sharedPreferences.getStringList('starred') ?? [];
  }
}
