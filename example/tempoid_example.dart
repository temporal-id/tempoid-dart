import 'package:tempoid/tempoid.dart';

void main() {
  for (int i = 0; i < 10; i++) {
    final id = TempoId.generate();
    print('ID: $id');
  }
}
