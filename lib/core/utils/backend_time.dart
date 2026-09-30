class BackendTime {
  const BackendTime._();

  static DateTime parse(String value) {
    final normalized = value.endsWith('Z')
        ? value
        : '${value}Z';

    return DateTime.parse(normalized).toUtc();
  }
}