/// 약관 동의 정보 앱 내부 모델.
class TermsInfoModel {
  const TermsInfoModel({
    required this.termsOfService,
    required this.privacyPolicy,
    required this.push,
    required this.marketing,
  });

  final bool termsOfService;
  final bool privacyPolicy;
  final bool push;
  final bool marketing;
}
