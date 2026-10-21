 import 'package:flutter_structure/core/network/network_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart';
 

abstract class SplashRemoteDataSource {
}

@Injectable(as:  SplashRemoteDataSource)
class SplashRemoteDataSourceImpl implements SplashRemoteDataSource {
   SplashRemoteDataSourceImpl(this.networkHelper);
  final NetworkHelper networkHelper;

  
}
