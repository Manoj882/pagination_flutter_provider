
import 'package:json_annotation/json_annotation.dart';
part 'employee.g.dart';
@JsonSerializable()
class Employee {
    @JsonKey(name: "id")
    final int? id;
    @JsonKey(name: "name")
    final String? name;
    @JsonKey(name: "phone")
    final String? phone;
    @JsonKey(name: "email")
    final String? email;

    Employee({
        this.id,
        this.name,
        this.phone,
        this.email,
    });

    factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);

    Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}