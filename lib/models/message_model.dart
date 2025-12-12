class DeliveryStatus {
  final InAppDelivery? inApp;
  final SmsDelivery? sms;
  final EmailDelivery? email;

  DeliveryStatus({
    this.inApp,
    this.sms,
    this.email,
  });

  factory DeliveryStatus.fromJson(Map<String, dynamic> json) {
    return DeliveryStatus(
      inApp: json['inApp'] != null
          ? InAppDelivery.fromJson(json['inApp'] as Map<String, dynamic>)
          : null,
      sms: json['sms'] != null
          ? SmsDelivery.fromJson(json['sms'] as Map<String, dynamic>)
          : null,
      email: json['email'] != null
          ? EmailDelivery.fromJson(json['email'] as Map<String, dynamic>)
          : null,
    );
  }
}

class InAppDelivery {
  final bool sent;
  final bool read;
  final DateTime? sentAt;

  InAppDelivery({
    required this.sent,
    required this.read,
    this.sentAt,
  });

  factory InAppDelivery.fromJson(Map<String, dynamic> json) {
    return InAppDelivery(
      sent: json['sent'] as bool? ?? false,
      read: json['read'] as bool? ?? false,
      sentAt: json['sentAt'] != null
          ? DateTime.parse(json['sentAt'] as String)
          : null,
    );
  }
}

class SmsDelivery {
  final bool sent;

  SmsDelivery({
    required this.sent,
  });

  factory SmsDelivery.fromJson(Map<String, dynamic> json) {
    return SmsDelivery(
      sent: json['sent'] as bool? ?? false,
    );
  }
}

class EmailDelivery {
  final bool sent;

  EmailDelivery({
    required this.sent,
  });

  factory EmailDelivery.fromJson(Map<String, dynamic> json) {
    return EmailDelivery(
      sent: json['sent'] as bool? ?? false,
    );
  }
}

class MessageModel {
  final String id;
  final String sender;
  final String senderModel;
  final String senderName;
  final String recipient;
  final String recipientModel;
  final String recipientName;
  final String subject;
  final String message;
  final String deliveryMethod; // "in-app", "sms", "email", "all"
  final DeliveryStatus deliveryStatus;
  final bool isRead;
  final String familyName;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageModel({
    required this.id,
    required this.sender,
    required this.senderModel,
    required this.senderName,
    required this.recipient,
    required this.recipientModel,
    required this.recipientName,
    required this.subject,
    required this.message,
    required this.deliveryMethod,
    required this.deliveryStatus,
    required this.isRead,
    required this.familyName,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      senderModel: json['senderModel'] as String? ?? '',
      senderName: json['senderName'] as String? ?? '',
      recipient: json['recipient'] as String? ?? '',
      recipientModel: json['recipientModel'] as String? ?? '',
      recipientName: json['recipientName'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      message: json['message'] as String? ?? '',
      deliveryMethod: json['deliveryMethod'] as String? ?? 'in-app',
      deliveryStatus: DeliveryStatus.fromJson(
        json['deliveryStatus'] as Map<String, dynamic>? ?? {},
      ),
      isRead: json['isRead'] as bool? ?? false,
      familyName: json['familyName'] as String? ?? '',
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}

class SendMessageResponse {
  final MessageModel message;
  final Map<String, dynamic> deliveryStatus;

  SendMessageResponse({
    required this.message,
    required this.deliveryStatus,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      message: MessageModel.fromJson(json['message'] as Map<String, dynamic>),
      deliveryStatus: json['deliveryStatus'] as Map<String, dynamic>? ?? {},
    );
  }
}

