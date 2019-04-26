class Employee {
  final String id;
  final String employeeName;
  final String employeeSalary;
  final String employeeAge;
  final String profileImage;

  Employee(
      {this.id,
      this.employeeName,
      this.employeeSalary,
      this.employeeAge,
      this.profileImage});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        id: json['id'],
        employeeName: json['employee_name'],
        employeeSalary: json['employee_salary'],
        employeeAge: json['employee_age'],
        profileImage: json['profile_image']);
  }

  @override
  String toString() {
    return 'Employee{id: $id, employeeName: $employeeName, employeeSalary: $employeeSalary, employeeAge: $employeeAge, profileImage: $profileImage}';
  }
}
