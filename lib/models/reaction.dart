class Reaction {
  final String reaction;
  final int quantity;

  Reaction({this.reaction, this.quantity});

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      reaction: json['reaction'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
        'reaction': reaction,
        'quantity': quantity,
      };
}
