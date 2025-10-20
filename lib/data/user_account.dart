class UserAccount {
  final String name;
  final String employeeId;
  final String avatar;
  final String position;
  final String department;
  final String factory;
  final String birthDate;
  final String gender;
  final String email;
  final String phone;
  final String taxCode;
  final String address;
  final String notes;

  UserAccount({
    required this.name,
    required this.employeeId,
    required this.avatar,
    required this.position,
    required this.department,
    required this.factory,
    required this.birthDate,
    required this.gender,
    required this.email,
    required this.phone,
    required this.taxCode,
    required this.address,
    required this.notes,
  });

  factory UserAccount.demo() {
    return UserAccount(
      name: 'Phan Bảo Tín',
      employeeId: 'ID Nhân viên:13425252',
      avatar: 'https://via.placeholder.com/150',
      position: 'Lái xe',
      department: 'Điều vận',
      factory: 'Việt Trì',
      birthDate: '20/01/1990',
      gender: 'Nam',
      email: 'Van123@gmail.com',
      phone: '03456987189',
      taxCode: '092834927598',
      address: '100 P. Đông Các, Đống Đa, Đống Đa, Hà Nội',
      notes:
          'orem ipsum dolor sit amet, consectetur adipiscing elit. Cras a ligula orci',
    );
  }
}
