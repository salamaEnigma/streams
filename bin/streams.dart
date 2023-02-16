import 'dart:async';

void main(List<String> arguments) async {
  await for (final char in getNames()
      .timeout(
        const Duration(
          seconds: 3,
        ),
        onTimeout: (sink) {
          print("Timeout");
          sink.add("Enigma Timeout");
        },
      )
      .transform(
        StreamTransformer<String, String>.fromHandlers(
          handleError: (error, stackTrace, sink) {
            sink.add("Enigma Error");
            sink.close();
          },
          handleDone: (sink) {
            print("Stream is Done");
            sink.close();
          },
        ),
      )
      .transform(
        LetterStream(),
      )) {
    print(char);
  }
}

Stream<String> getNames() async* {
  yield "John";
  await Future.delayed(const Duration(seconds: 1));
  yield "Doe";
  await Future.delayed(const Duration(seconds: 3));
  yield "Jill";
  await Future.delayed(const Duration(seconds: 1));
  yield "Valentine";
}

class LetterStream extends StreamTransformerBase<String, String> {
  @override
  Stream<String> bind(Stream<String> stream) {
    return stream.asyncExpand(
      (event) async* {
        for (int i = 0; i < event.length; i++) {
          yield event[i];
        }
      },
    );
  }
}

class CapitalStream extends StreamTransformerBase<String, String> {
  @override
  Stream<String> bind(Stream<String> stream) {
    return stream.asyncExpand(
      (event) async* {
        yield event.toUpperCase();
      },
    );
  }
}
