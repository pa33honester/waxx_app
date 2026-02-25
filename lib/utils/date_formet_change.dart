import 'package:intl/intl.dart';

String formatDate(String inputDate) {
  final inputFormat = DateFormat('M/d/yyyy, hh:mm:ss a');
  final outputFormat = DateFormat('dd MMM yyyy');

  final parsedDate = inputFormat.parse(inputDate);
  final formattedDate = outputFormat.format(parsedDate);

  return formattedDate;
}
