import 'package:offline_first_chat_app/bootstrap.dart';
import 'package:offline_first_chat_app/src/app/app.dart';

void main() {
  const environentFileName = 'env/.env.qa';

  bootstrap(
    () => const App(),
    environentFileName,
  );
}
