import 'package:logger/logger.dart';

var logger = Logger(
    printer: PrettyPrinter(
        colors: true, dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
