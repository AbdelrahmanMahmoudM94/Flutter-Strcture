import 'package:equatable/equatable.dart';

class BaseEntity<T> extends Equatable {
  const BaseEntity({
    this.message,
    this.statusCode,
    this.data,
    this.totalRecords,
    this.hasMorePages,
  });
  final String? message;
  final int? statusCode;
  final T? data;

  final int? totalRecords;
  final bool? hasMorePages;

  @override
  List<Object?> get props => <Object?>[];
}
