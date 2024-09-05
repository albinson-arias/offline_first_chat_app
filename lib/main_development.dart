import 'package:offline_first_chat_app/bootstrap.dart';
import 'package:offline_first_chat_app/src/app/app.dart';

void main() async {
  const environentFileName = 'env/.env.dev';

  await bootstrap(
    () => const App(),
    environentFileName,
  );
}
