import 'package:intl/intl.dart';

class FormatHelper {
  static String compactNumber(int number) {
    return NumberFormat.compact().format(number);
  }

  static String timeAgo(DateTime dateTime) {
    final duration = DateTime.now().difference(dateTime);
    if (duration.inDays >= 30) {
      return '${(duration.inDays / 30).floor()} tháng trước';
    } else if (duration.inDays >= 1) {
      return '${duration.inDays} ngày trước';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours} giờ trước';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
