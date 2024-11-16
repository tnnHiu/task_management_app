**Ứng dụng Quản lý Thời gian và Hiệu suất Cá nhân**

# Tính năng chính

1. Quản lý nhiệm vụ và sự kiện (obli)
2. Đồng bộ hóa lịch (obli)
3. Nhắc nhở thông minh (obli)
4. Phân tích hiệu suất cơ bản (prio)
5. Chế độ tập trung (prio)
6. Phân tích nâng cao (optn)
7. Tích hợp công cụ bên thứ ba (optn)

## 1. Quản lý nhiệm vụ và sự kiện:

- **Tạo và chỉnh sửa nhiệm vụ**: Người dùng có thể tạo nhiệm vụ với tiêu đề, mô tả chi tiết, thời hạn hoàn thành và mức độ ưu tiên.
- **Danh sách nhiệm vụ**: Nhiệm vụ được phân loại theo ngày, tuần, tháng hoặc theo dự án.
- **Tạo sự kiện**: Người dùng có thể thêm các sự kiện vào lịch, bao gồm thời gian bắt đầu và kết thúc, địa điểm và ghi chú.
- **Lọc và tìm kiếm**: Tính năng lọc và tìm kiếm nhiệm vụ/sự kiện theo từ khóa, mức độ ưu tiên, hoặc thời gian.

## 2. Đồng bộ hóa lịch:

- Tích hợp lịch: Tích hợp với các dịch vụ lịch như Google Calendar, Outlook để đồng bộ hóa sự kiện và nhiệm vụ.
- Đồng bộ hai chiều: Khi người dùng cập nhật hoặc thêm nhiệm vụ/sự kiện trong ứng dụng, nó sẽ tự động đồng bộ với lịch của người dùng và ngược lại.
- Thông báo và nhắc nhở: Gửi thông báo hoặc nhắc nhở người dùng về nhiệm vụ hoặc sự kiện sắp đến.

## 3. Phân tích hiệu suất:

- Theo dõi thời gian: Ghi lại thời gian dành cho mỗi nhiệm vụ/sự kiện.
- Biểu đồ hiệu suất: Cung cấp các biểu đồ và thống kê về thời gian làm việc, hiệu suất theo tuần, tháng, và năm.
- Phân tích năng suất: Đánh giá hiệu suất cá nhân dựa trên thời gian hoàn thành nhiệm vụ và đưa ra báo cáo chi tiết.
- Gợi ý cải thiện: Đưa ra đề xuất cải thiện hiệu suất dựa trên dữ liệu theo dõi.

## 4. Nhắc nhở thông minh:

- Nhắc nhở tùy chỉnh: Người dùng có thể thiết lập nhắc nhở cho từng nhiệm vụ/sự kiện.
- Nhắc nhở dựa trên thói quen: Hệ thống tự động tạo nhắc nhở dựa trên thói quen và lịch trình của người dùng, như nhắc nhở hoàn thành nhiệm vụ còn lại cuối ngày.
- Nhắc nhở qua nhiều kênh: Nhắc nhở có thể được gửi qua thông báo đẩy, email, hoặc SMS.

## 5. Chế độ tập trung (Focus Mode):

- Không làm phiền: Khi kích hoạt, chế độ này sẽ tắt tất cả thông báo và hạn chế các ứng dụng gây phân tâm.
- Hẹn giờ tập trung: Người dùng có thể thiết lập thời gian tập trung cho một nhiệm vụ cụ thể (ví dụ: 25 phút Pomodoro).
- Thống kê thời gian tập trung: Theo dõi thời gian đã sử dụng trong chế độ tập trung và hiển thị trong báo cáo hiệu suất.

## 6.Tích hợp công cụ bên thứ ba 

- Tích hợp với ứng dụng ghi chú: Như Evernote, Google Keep để lưu trữ ý tưởng hoặc ghi chú quan trọng liên quan đến nhiệm vụ.
- Tích hợp với ứng dụng quản lý tài liệu: Như Google Drive, Dropbox để đính kèm tài liệu liên quan đến nhiệm vụ/sự kiện

# Công nghệ
- React Native
- Firebase (noSQL)

# Công nghệ sử dụng
- Flutter
- Firebase

# Hướng dẫn chạy ứng dụng
## Với người dùng android.
  - Chạy máy ảo android, hoặc là cắm máy điện thoại hệ điều hành android sau đó chạy lệnh ở terminal "flutter run" chọn máy mình mình muốn chạy
## Với người dùng web.
  - chạy lệnh "flutter run" và chọn trình duyệt muốn chạy
## Thiết lập thư viện
  Vào file pubspec.yaml 
```
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^3.6.0
  cloud_firestore: ^5.4.5
  flutter_bloc: ^8.1.6
  intl: ^0.19.0
  equatable: ^2.0.5
  flutter_slidable: ^3.1.1
  firebase_auth: ^5.3.2
  google_sign_in: ^6.2.2
  table_calendar: ^3.1.2
  http: ^1.2.2
  googleapis: ^13.2.0
  googleapis_auth: ^1.6.0
  url_launcher: ^6.3.1
  hexcolor: ^3.0.1
  google_fonts: ^6.2.1
```
và chạy lệnh "flutter pub get" để chạy các thư viện
