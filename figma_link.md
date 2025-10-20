
- Chức năng Thông báo : 
 + UI : @lib/presentation/base/notifications/ui/notification_screen.dart
 + Logic: @lib/presentation/base/notifications/bloc/notification_bloc.dart
https://www.figma.com/design/QZ2bn5bhKmVjpKWEr6bB1y/Gomep?node-id=1-3198&t=hC23gVOVWU5jQWy3-4

- Chức năng quản lý tài khoản
 + UI : @lib/presentation/base/personal/ui/account_screen.dart
 + Logic :@lib/presentation/base/personal/bloc/account_bloc.dart
https://www.figma.com/design/QZ2bn5bhKmVjpKWEr6bB1y/Gomep?node-id=1-2302&t=hC23gVOVWU5jQWy3-4
https://www.figma.com/design/QZ2bn5bhKmVjpKWEr6bB1y/Gomep?node-id=1-3026&t=hC23gVOVWU5jQWy3-4

- Đổi mật khẩu
 + @lib/presentation/auth/change_password/ui/change_password_screen.dart
 + @lib/presentation/auth/change_password/bloc/change_password_bloc.dart
https://www.figma.com/design/QZ2bn5bhKmVjpKWEr6bB1y/Gomep?node-id=1-3078&t=hC23gVOVWU5jQWy3-4
https://www.figma.com/design/QZ2bn5bhKmVjpKWEr6bB1y/Gomep?node-id=1-3108&t=hC23gVOVWU5jQWy3-4


- Custom popup thông báo
 + tạo riêng 1 stateless ở @lib/common/widgets/dialogs
https://www.figma.com/design/QZ2bn5bhKmVjpKWEr6bB1y/Gomep?node-id=1-3163&t=hC23gVOVWU5jQWy3-4


- Tìm kiếm quán ăn và search Google Map
 + Xử lý giống hoàn toàn 100% UI figma , các icon marker trên bản đồ đã có sẵn nhưng chưa đúng kích thước, hãy sửa lại cho đúng. Có 1 marker đang to hơn những market còn lại , biểu hiện marker đang được focus.
 + UI đã có viết sẵn ở : @lib/presentation/base/google_map/ui/map_screen.dart
 + logic : @lib/presentation/base/google_map/bloc/map_bloc.dart
https://www.figma.com/design/QZ2bn5bhKmVjpKWEr6bB1y/Gomep?node-id=1-3281&t=hC23gVOVWU5jQWy3-4

Hoàn thiện tất cả các tính năng tôi cung cấp, đối với UI thì phải giống figma hoàn toàn 100% , về logic thì tất cả xử lý ở bloc , handle các logic bằng việc stream . hạn chế sử dụng setState nhất có thể. 
- Thực hiện việc mapping function , api và stream data giống hoàn toàn @lib/presentation/main/bloc/main_bloc.dart 