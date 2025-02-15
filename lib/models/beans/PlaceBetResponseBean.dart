
class PlaceBetResponseBean {
  String betId;
  String betPlacementStatus;

  PlaceBetResponseBean({
    required this.betId,
    required this.betPlacementStatus,
  });

  factory PlaceBetResponseBean.fromJson(Map<String, dynamic> json) {
    return PlaceBetResponseBean(
      betId: json['betId'] as String,
      betPlacementStatus: json['betPlacementStatus'] as String,
    );
  }
}
