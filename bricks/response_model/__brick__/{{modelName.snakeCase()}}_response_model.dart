import 'package:json_annotation/json_annotation.dart';
part '../{{modelName.snakeCase()}}_response_model.g.dart';

@JsonSerializable()
class {{modelName.pascalCase()}}ResponseModel extends {{modelName.pascalCase()}}Entity {
   {{modelName.pascalCase()}}ResponseModel({
    
  });
  factory  {{modelName.pascalCase()}}ResponseModel.fromJson(Map<String, dynamic> json) =>
      _${{modelName.pascalCase()}}ResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _${{modelName.pascalCase()}}ResponseModelToJson(this);
}
