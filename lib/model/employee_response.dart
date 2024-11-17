import 'package:json_annotation/json_annotation.dart';
import 'package:pagination_example/model/employee.dart';
part 'employee_response.g.dart';


@JsonSerializable()
class EmployeeResponse {
  @JsonKey(name: "success")
  final bool? success;
  @JsonKey(name: "data")
  final List<Employee>? data;

  EmployeeResponse({
    this.success,
    this.data
  });

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) => _$EmployeeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeResponseToJson(this);
}