 import 'package:flutter_structure/features/splash/data/data_sources/remote/splash_remote_data_sources.dart';
import 'package:flutter_structure/features/splash/domain/repositories/splash_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SplashRepository)
class SplashRepositoryImp implements SplashRepository {
  SplashRepositoryImp({
    required this.splashRemoteDataSource,
  });
  final SplashRemoteDataSource splashRemoteDataSource;
}
