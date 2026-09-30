import 'package:json_annotation/json_annotation.dart';
 
part '../{{modelName.snakeCase()}}_request_model.g.dart';

@JsonSerializable()
class {{modelName.pascalCase()}}RequestModel{
   {{modelName.pascalCase()}}RequestModel({
    
  });
  factory {{modelName.pascalCase()}}RequestModel.fromJson(Map<String, dynamic> json) =>
      _${{modelName.pascalCase()}}RequestModelFromJson(json);

  Map<String, dynamic> toJson() => _${{modelName.pascalCase()}}RequestModelToJson(this);
}