import 'dart:convert';

AdminSettingModel adminSettingApiFromJson(String str) => AdminSettingModel.fromJson(json.decode(str));
String adminSettingApiToJson(AdminSettingModel data) => json.encode(data.toJson());

class AdminSettingModel {
  AdminSettingModel({
    bool? status,
    String? message,
    Setting? setting,
  }) {
    _status = status;
    _message = message;
    _setting = setting;
  }

  AdminSettingModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _setting = json['setting'] != null ? Setting.fromJson(json['setting']) : null;
  }
  bool? _status;
  String? _message;
  Setting? _setting;
  AdminSettingModel copyWith({
    bool? status,
    String? message,
    Setting? setting,
  }) =>
      AdminSettingModel(
        status: status ?? _status,
        message: message ?? _message,
        setting: setting ?? _setting,
      );
  bool? get status => _status;
  String? get message => _message;
  Setting? get setting => _setting;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_setting != null) {
      map['setting'] = _setting?.toJson();
    }
    return map;
  }
}

Setting settingFromJson(String str) => Setting.fromJson(json.decode(str));
String settingToJson(Setting data) => json.encode(data.toJson());

class Setting {
  Setting({
    String? id,
    String? privacyPolicyLink,
    String? privacyPolicyText,
    int? withdrawCharges,
    int? withdrawLimit,
    String? createdAt,
    String? updatedAt,
    int? cancelOrderCharges,
    List<PaymentGateway>? paymentGateway,
    int? adminCommissionCharges,
    bool? isAddProductRequest,
    String? razorPayId,
    bool? razorPaySwitch,
    String? razorSecretKey,
    String? stripePublishableKey,
    String? stripeSecretKey,
    bool? stripeSwitch,
    bool? isUpdateProductRequest,
    bool? isFakeData,
    String? zegoAppId,
    String? zegoAppSignIn,
    PrivateKey? privateKey,
    String? flutterWaveId,
    bool? flutterWaveSwitch,
  }) {
    _id = id;
    _privacyPolicyLink = privacyPolicyLink;
    _privacyPolicyText = privacyPolicyText;
    _withdrawCharges = withdrawCharges;
    _withdrawLimit = withdrawLimit;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _cancelOrderCharges = cancelOrderCharges;
    _paymentGateway = paymentGateway;
    _adminCommissionCharges = adminCommissionCharges;
    _isAddProductRequest = isAddProductRequest;
    _razorPayId = razorPayId;
    _razorPaySwitch = razorPaySwitch;
    _razorSecretKey = razorSecretKey;
    _stripePublishableKey = stripePublishableKey;
    _stripeSecretKey = stripeSecretKey;
    _stripeSwitch = stripeSwitch;
    _isUpdateProductRequest = isUpdateProductRequest;
    _isFakeData = isFakeData;
    _zegoAppId = zegoAppId;
    _zegoAppSignIn = zegoAppSignIn;
    _privateKey = privateKey;
    _flutterWaveId = flutterWaveId;
    _flutterWaveSwitch = flutterWaveSwitch;
  }

  Setting.fromJson(dynamic json) {
    _id = json['_id'];
    _privacyPolicyLink = json['privacyPolicyLink'];
    _privacyPolicyText = json['privacyPolicyText'];
    _withdrawCharges = json['withdrawCharges'];
    _withdrawLimit = json['withdrawLimit'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _cancelOrderCharges = json['cancelOrderCharges'];
    if (json['paymentGateway'] != null) {
      _paymentGateway = [];
      json['paymentGateway'].forEach((v) {
        _paymentGateway?.add(PaymentGateway.fromJson(v));
      });
    }
    _adminCommissionCharges = json['adminCommissionCharges'];
    _isAddProductRequest = json['isAddProductRequest'];
    _razorPayId = json['razorPayId'];
    _razorPaySwitch = json['razorPaySwitch'];
    _razorSecretKey = json['razorSecretKey'];
    _stripePublishableKey = json['stripePublishableKey'];
    _stripeSecretKey = json['stripeSecretKey'];
    _stripeSwitch = json['stripeSwitch'];
    _isUpdateProductRequest = json['isUpdateProductRequest'];
    _isFakeData = json['isFakeData'];
    _zegoAppId = json['zegoAppId'];
    _zegoAppSignIn = json['zegoAppSignIn'];
    _privateKey = json['privateKey'] != null ? PrivateKey.fromJson(json['privateKey']) : null;
    _flutterWaveId = json['flutterWaveId'];
    _flutterWaveSwitch = json['flutterWaveSwitch'];
  }
  String? _id;
  String? _privacyPolicyLink;
  String? _privacyPolicyText;
  int? _withdrawCharges;
  int? _withdrawLimit;
  String? _createdAt;
  String? _updatedAt;
  int? _cancelOrderCharges;
  List<PaymentGateway>? _paymentGateway;
  int? _adminCommissionCharges;
  bool? _isAddProductRequest;
  String? _razorPayId;
  bool? _razorPaySwitch;
  String? _razorSecretKey;
  String? _stripePublishableKey;
  String? _stripeSecretKey;
  bool? _stripeSwitch;
  bool? _isUpdateProductRequest;
  bool? _isFakeData;
  String? _zegoAppId;
  String? _zegoAppSignIn;
  PrivateKey? _privateKey;
  String? _flutterWaveId;
  bool? _flutterWaveSwitch;
  Setting copyWith({
    String? id,
    String? privacyPolicyLink,
    String? privacyPolicyText,
    int? withdrawCharges,
    int? withdrawLimit,
    String? createdAt,
    String? updatedAt,
    int? cancelOrderCharges,
    List<PaymentGateway>? paymentGateway,
    int? adminCommissionCharges,
    bool? isAddProductRequest,
    String? razorPayId,
    bool? razorPaySwitch,
    String? razorSecretKey,
    String? stripePublishableKey,
    String? stripeSecretKey,
    bool? stripeSwitch,
    bool? isUpdateProductRequest,
    bool? isFakeData,
    String? zegoAppId,
    String? zegoAppSignIn,
    PrivateKey? privateKey,
    String? flutterWaveId,
    bool? flutterWaveSwitch,
  }) =>
      Setting(
        id: id ?? _id,
        privacyPolicyLink: privacyPolicyLink ?? _privacyPolicyLink,
        privacyPolicyText: privacyPolicyText ?? _privacyPolicyText,
        withdrawCharges: withdrawCharges ?? _withdrawCharges,
        withdrawLimit: withdrawLimit ?? _withdrawLimit,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        cancelOrderCharges: cancelOrderCharges ?? _cancelOrderCharges,
        paymentGateway: paymentGateway ?? _paymentGateway,
        adminCommissionCharges: adminCommissionCharges ?? _adminCommissionCharges,
        isAddProductRequest: isAddProductRequest ?? _isAddProductRequest,
        razorPayId: razorPayId ?? _razorPayId,
        razorPaySwitch: razorPaySwitch ?? _razorPaySwitch,
        razorSecretKey: razorSecretKey ?? _razorSecretKey,
        stripePublishableKey: stripePublishableKey ?? _stripePublishableKey,
        stripeSecretKey: stripeSecretKey ?? _stripeSecretKey,
        stripeSwitch: stripeSwitch ?? _stripeSwitch,
        isUpdateProductRequest: isUpdateProductRequest ?? _isUpdateProductRequest,
        isFakeData: isFakeData ?? _isFakeData,
        zegoAppId: zegoAppId ?? _zegoAppId,
        zegoAppSignIn: zegoAppSignIn ?? _zegoAppSignIn,
        privateKey: privateKey ?? _privateKey,
        flutterWaveId: flutterWaveId ?? _flutterWaveId,
        flutterWaveSwitch: flutterWaveSwitch ?? _flutterWaveSwitch,
      );
  String? get id => _id;
  String? get privacyPolicyLink => _privacyPolicyLink;
  String? get privacyPolicyText => _privacyPolicyText;
  int? get withdrawCharges => _withdrawCharges;
  int? get withdrawLimit => _withdrawLimit;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get cancelOrderCharges => _cancelOrderCharges;
  List<PaymentGateway>? get paymentGateway => _paymentGateway;
  int? get adminCommissionCharges => _adminCommissionCharges;
  bool? get isAddProductRequest => _isAddProductRequest;
  String? get razorPayId => _razorPayId;
  bool? get razorPaySwitch => _razorPaySwitch;
  String? get razorSecretKey => _razorSecretKey;
  String? get stripePublishableKey => _stripePublishableKey;
  String? get stripeSecretKey => _stripeSecretKey;
  bool? get stripeSwitch => _stripeSwitch;
  bool? get isUpdateProductRequest => _isUpdateProductRequest;
  bool? get isFakeData => _isFakeData;
  String? get zegoAppId => _zegoAppId;
  String? get zegoAppSignIn => _zegoAppSignIn;
  PrivateKey? get privateKey => _privateKey;
  String? get flutterWaveId => _flutterWaveId;
  bool? get flutterWaveSwitch => _flutterWaveSwitch;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['privacyPolicyLink'] = _privacyPolicyLink;
    map['privacyPolicyText'] = _privacyPolicyText;
    map['withdrawCharges'] = _withdrawCharges;
    map['withdrawLimit'] = _withdrawLimit;
    map['createdAt'] = _createdAt;
    map['updatedAt'] = _updatedAt;
    map['cancelOrderCharges'] = _cancelOrderCharges;
    if (_paymentGateway != null) {
      map['paymentGateway'] = _paymentGateway?.map((v) => v.toJson()).toList();
    }
    map['adminCommissionCharges'] = _adminCommissionCharges;
    map['isAddProductRequest'] = _isAddProductRequest;
    map['razorPayId'] = _razorPayId;
    map['razorPaySwitch'] = _razorPaySwitch;
    map['razorSecretKey'] = _razorSecretKey;
    map['stripePublishableKey'] = _stripePublishableKey;
    map['stripeSecretKey'] = _stripeSecretKey;
    map['stripeSwitch'] = _stripeSwitch;
    map['isUpdateProductRequest'] = _isUpdateProductRequest;
    map['isFakeData'] = _isFakeData;
    map['zegoAppId'] = _zegoAppId;
    map['zegoAppSignIn'] = _zegoAppSignIn;
    if (_privateKey != null) {
      map['privateKey'] = _privateKey?.toJson();
    }
    map['flutterWaveId'] = _flutterWaveId;
    map['flutterWaveSwitch'] = _flutterWaveSwitch;
    return map;
  }
}

PrivateKey privateKeyFromJson(String str) => PrivateKey.fromJson(json.decode(str));
String privateKeyToJson(PrivateKey data) => json.encode(data.toJson());

class PrivateKey {
  PrivateKey({
    String? type,
    String? projectId,
    String? privateKeyId,
    String? privateKey,
    String? clientEmail,
    String? clientId,
    String? authUri,
    String? tokenUri,
    String? authProviderX509CertUrl,
    String? clientX509CertUrl,
    String? universeDomain,
  }) {
    _type = type;
    _projectId = projectId;
    _privateKeyId = privateKeyId;
    _privateKey = privateKey;
    _clientEmail = clientEmail;
    _clientId = clientId;
    _authUri = authUri;
    _tokenUri = tokenUri;
    _authProviderX509CertUrl = authProviderX509CertUrl;
    _clientX509CertUrl = clientX509CertUrl;
    _universeDomain = universeDomain;
  }

  PrivateKey.fromJson(dynamic json) {
    _type = json['type'];
    _projectId = json['project_id'];
    _privateKeyId = json['private_key_id'];
    _privateKey = json['private_key'];
    _clientEmail = json['client_email'];
    _clientId = json['client_id'];
    _authUri = json['auth_uri'];
    _tokenUri = json['token_uri'];
    _authProviderX509CertUrl = json['auth_provider_x509_cert_url'];
    _clientX509CertUrl = json['client_x509_cert_url'];
    _universeDomain = json['universe_domain'];
  }
  String? _type;
  String? _projectId;
  String? _privateKeyId;
  String? _privateKey;
  String? _clientEmail;
  String? _clientId;
  String? _authUri;
  String? _tokenUri;
  String? _authProviderX509CertUrl;
  String? _clientX509CertUrl;
  String? _universeDomain;
  PrivateKey copyWith({
    String? type,
    String? projectId,
    String? privateKeyId,
    String? privateKey,
    String? clientEmail,
    String? clientId,
    String? authUri,
    String? tokenUri,
    String? authProviderX509CertUrl,
    String? clientX509CertUrl,
    String? universeDomain,
  }) =>
      PrivateKey(
        type: type ?? _type,
        projectId: projectId ?? _projectId,
        privateKeyId: privateKeyId ?? _privateKeyId,
        privateKey: privateKey ?? _privateKey,
        clientEmail: clientEmail ?? _clientEmail,
        clientId: clientId ?? _clientId,
        authUri: authUri ?? _authUri,
        tokenUri: tokenUri ?? _tokenUri,
        authProviderX509CertUrl: authProviderX509CertUrl ?? _authProviderX509CertUrl,
        clientX509CertUrl: clientX509CertUrl ?? _clientX509CertUrl,
        universeDomain: universeDomain ?? _universeDomain,
      );
  String? get type => _type;
  String? get projectId => _projectId;
  String? get privateKeyId => _privateKeyId;
  String? get privateKey => _privateKey;
  String? get clientEmail => _clientEmail;
  String? get clientId => _clientId;
  String? get authUri => _authUri;
  String? get tokenUri => _tokenUri;
  String? get authProviderX509CertUrl => _authProviderX509CertUrl;
  String? get clientX509CertUrl => _clientX509CertUrl;
  String? get universeDomain => _universeDomain;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['project_id'] = _projectId;
    map['private_key_id'] = _privateKeyId;
    map['private_key'] = _privateKey;
    map['client_email'] = _clientEmail;
    map['client_id'] = _clientId;
    map['auth_uri'] = _authUri;
    map['token_uri'] = _tokenUri;
    map['auth_provider_x509_cert_url'] = _authProviderX509CertUrl;
    map['client_x509_cert_url'] = _clientX509CertUrl;
    map['universe_domain'] = _universeDomain;
    return map;
  }
}

PaymentGateway paymentGatewayFromJson(String str) => PaymentGateway.fromJson(json.decode(str));
String paymentGatewayToJson(PaymentGateway data) => json.encode(data.toJson());

class PaymentGateway {
  PaymentGateway({
    String? name,
  }) {
    _name = name;
  }

  PaymentGateway.fromJson(dynamic json) {
    _name = json['name'];
  }
  String? _name;
  PaymentGateway copyWith({
    String? name,
  }) =>
      PaymentGateway(
        name: name ?? _name,
      );
  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    return map;
  }
}
