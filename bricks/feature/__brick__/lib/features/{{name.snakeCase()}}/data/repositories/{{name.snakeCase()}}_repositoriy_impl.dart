 import 'package:injectable/injectable.dart';
import 'package:flutter_structure/features/{{name.snakeCase()}}/data/data_sources/remote/{{name.snakeCase()}}_remote_data_sources.dart';
import 'package:flutter_structure/features/{{name.snakeCase()}}/domain/repositories/{{name.snakeCase()}}_repository.dart';

@Injectable(as: {{name.pascalCase()}}Repository)
class {{name.pascalCase()}}RepositoryImp implements {{name.pascalCase()}}Repository {
  {{name.pascalCase()}}RepositoryImp({
    required this.{{name.camelCase()}}RemoteDataSources,
   });
  final {{name.pascalCase()}}RemoteDataSources {{name.camelCase()}}RemoteDataSources;
   
}
