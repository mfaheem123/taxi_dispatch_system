import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CliController extends GetxController {
  WebSocketChannel? channel;
  RxBool isConnected = false.obs;

  /// ✅ Dynamic extension connect
  void connectSocket(String extension) {
    /// Already connected? Then do nothing
    if (channel != null && isConnected.value) return;

    channel = WebSocketChannel.connect(
      Uri.parse(
        'ws://192.168.110.5:5000/websocket/cli?extension=$extension',
      ),
    );

    channel!.stream.listen(
          (data) {
        print("📩 Socket Data: $data");

        if (!isConnected.value) {
          isConnected.value = true;

          /// ✅ Open screen only once
          Get.offAllNamed('/socketScreen');
        }
      },
      onError: (error) {
        print("❌ Socket Error: $error");
        isConnected.value = false;
        channel = null;
      },
      onDone: () {
        print("🔌 Socket Disconnected");
        isConnected.value = false;
        channel = null;
      },
    );
  }

  void disconnectSocket() {
    channel?.sink.close();
    channel = null;
    isConnected.value = false;
  }

  @override
  void onClose() {
    disconnectSocket();
    super.onClose();
  }
}
