import 'package:flutter_structure/core/network/error/failure.dart';
 import 'package:injectable/injectable.dart';
 import 'package:flutter_structure/core/network/api/network_apis_constants.dart';
import 'package:flutter_structure/core/network/network_helper.dart';
import 'package:flutter_structure/core/network/base_handling.dart';

abstract class {{name.pascalCase()}}RemoteDataSources {
   
}

@Injectable(as: {{name.pascalCase()}}RemoteDataSources)
class {{name.pascalCase()}}RemoteDataSourcesImpl
    implements {{name.pascalCase()}}RemoteDataSources {
 {{name.pascalCase()}}RemoteDataSourcesImpl(this.networkHelper);
  final NetworkHelper networkHelper;

  

  
}
