SettingsModel? settingsModel;
class SettingsModel{
  final int productId;
  final int orderId; 
  final int orderInvoice; 
  SettingsModel( {
    required this.productId,
    required this.orderId,
    required this.orderInvoice,
  });

  SettingsModel copyWith({
    int? productId,
    int? orderInvoice,
    int? orderId,
  
  }){
    return SettingsModel(
      productId: productId ?? this.productId,
      orderId: orderId ?? this.orderId,
      orderInvoice: orderInvoice??this.orderInvoice,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'productId': productId,
      'orderId':orderId,
    };
  }

  factory SettingsModel.fromMap(dynamic map) {
    return SettingsModel(
      productId: map['productId'] as int,
      orderId: map['orderId'] as int,
      orderInvoice: map['orderInvoice'] as int,
    );
  }


}