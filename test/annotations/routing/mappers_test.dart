import 'package:portal/annotations/routing/routing_annotation.dart';
import 'package:test/test.dart';

void main() {
  test("All mappers should return the correct method as string", () {
    GetMapping getMapping = GetMapping("/route");
    expect(getMapping.getMethodAsString(), equals("GET"));

    PostMapping postMapping = PostMapping("/route");
    expect(postMapping.getMethodAsString(), equals("POST"));

    PutMapping putMapping = PutMapping("/route");
    expect(putMapping.getMethodAsString(), equals("PUT"));

    DeleteMapping deleteMapping = DeleteMapping("/route");
    expect(deleteMapping.getMethodAsString(), equals("DELETE"));

    OptionsMapping optionsMapping = OptionsMapping("/route");
    expect(optionsMapping.getMethodAsString(), equals("OPTIONS"));

    TraceMapping traceMapping = TraceMapping("/route");
    expect(traceMapping.getMethodAsString(), equals("TRACE"));

    PatchMapping patchMapping = PatchMapping("/route");
    expect(patchMapping.getMethodAsString(), equals("PATCH"));

    ConnectMapping connectMapping = ConnectMapping("/route");
    expect(connectMapping.getMethodAsString(), equals("CONNECT"));

    HeadMapping headMapping = HeadMapping("/route");
    expect(headMapping.getMethodAsString(), equals("HEAD"));
  });
}
