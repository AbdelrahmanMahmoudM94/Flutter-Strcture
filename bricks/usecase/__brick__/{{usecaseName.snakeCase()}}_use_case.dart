import 'package:flutter_structure/core/domain/usecase/base_usecase.dart';
import 'package:flutter_structure/features/shared/entity/base_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_structure/core/network/base_handling.dart';
@injectable
class {{usecaseName.pascalCase()}}UseCase implements
      void UseCase<{{typeName.pascalCase()}}{{#hasParams}}, {{paramTypeName.pascalCase()}}{{/hasParams}}> {

  {{usecaseName.pascalCase()}}UseCase({
    required this.{{repoName.camelCase()}}Repository,
  });

  final {{repoName.pascalCase()}}Repository
      {{repoName.camelCase()}}Repository;

  @override
  Future<CustomResponseType<{{typeName.pascalCase()}}>> call(
    {{#hasParams}}
    {{paramTypeName.pascalCase()}} {{paramTypeName.camelCase()}},
    {{/hasParams}}
  ) async {
    return {{repoName.camelCase()}}Repository
        .{{functionName.camelCase()}}(
      {{#hasParams}}
      {{paramTypeName.camelCase()}}: {{paramTypeName.camelCase()}},
      {{/hasParams}}
    );
  }
}
