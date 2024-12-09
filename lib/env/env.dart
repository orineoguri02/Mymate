import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(
      varName:
          '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')
  static const String apiKey = _Env.apiKey;
}
