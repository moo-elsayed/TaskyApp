import 'package:get_it/get_it.dart';
import 'package:tasky_app/features/home/data/data_sources/remote_data_source/task_remote_data_source_imp.dart';
import '../../features/auth/data/repos/firebase_auth_repo_imp.dart';
import '../../features/home/data/repos/task_repo_imp.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<FirebaseAuthRepositoryImplementation>(
    FirebaseAuthRepositoryImplementation(),
  );

  getIt.registerSingleton<TaskRepositoryImplementation>(
    TaskRepositoryImplementation(TaskRemoteDataSourceImplementation()),
  );
}
