abstract class AbstractFileReader<T> {
  final String filePath;

  AbstractFileReader({required this.filePath});

  Future<T> read();
}
