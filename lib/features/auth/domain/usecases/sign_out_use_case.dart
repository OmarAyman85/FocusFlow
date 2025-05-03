import 'package:focusflow/features/auth/domain/repositories/auth_repository.dart';
import 'package:focusflow/core/injection/injection_container.dart';

class SignOutUseCase {
  Future<void> call({void params}) async {
    return await sl<AuthRepository>().signOut();
  }
}
