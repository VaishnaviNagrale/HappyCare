class Patient {
  final String name;
  final String mobileNo;
  final String adharNo;
  final String address;
  final int age;
  final bool? gender;
  final bool? isPaidCheckupFees;

  Patient({
    required this.name,
    required this.mobileNo,
    required this.adharNo,
    required this.address,
    required this.age,
    required this.gender,
    required this.isPaidCheckupFees,
  });
}
