// chat_message.dart
class ChatMessage {
  final String id;
  final String message;
  final bool isSent;
  final String time;
  final bool isRead;
  final DateTime timestamp;
  final MessageType type;
  final String? imageUrl;
  final String? fileUrl;
  final String? fileName;

  ChatMessage({
    String? id,
    required this.message,
    required this.isSent,
    required this.time,
    this.isRead = false,
    DateTime? timestamp,
    this.type = MessageType.text,
    this.imageUrl,
    this.fileUrl,
    this.fileName,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp = timestamp ?? DateTime.now();

  // Copy with method
  ChatMessage copyWith({
    String? id,
    String? message,
    bool? isSent,
    String? time,
    bool? isRead,
    DateTime? timestamp,
    MessageType? type,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      isSent: isSent ?? this.isSent,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
    );
  }

  // From JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String?,
      message: json['message'] as String,
      isSent: json['isSent'] as bool,
      time: json['time'] as String,
      isRead: json['isRead'] as bool? ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      imageUrl: json['imageUrl'] as String?,
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'isSent': isSent,
      'time': time,
      'isRead': isRead,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'imageUrl': imageUrl,
      'fileUrl': fileUrl,
      'fileName': fileName,
    };
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, message: $message, isSent: $isSent, time: $time, isRead: $isRead)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Message Type Enum
enum MessageType {
  text,
  image,
  file,
  location,
  audio,
  video,
}