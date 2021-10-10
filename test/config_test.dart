import 'package:test/test.dart';
import 'package:workoutnote/business_logic/ConfigProvider.dart';
import 'package:workoutnote/utils/Utils.dart';

void main() {
  group('Testing ConfigProvider', () {
    var configProvider = ConfigProvider();
    test('login', () {
      // configProvider.login('ilyosbek@nsl.inha.ac.kr', '654321').then((value) {
      //   expect(configProvider.myemail == 'ilyosbek@nsl.inha.ac.kr', true);
      // });
      configProvider.updatePreferences("ilyos199822@gmail.com", "Mark", "1998-06-22", "m", false).then((value) {
        if (value) expect(userPreferences!.getString("name") == "Mark", true);
      });
    });
  });
}
