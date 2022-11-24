enum Status {
  todo(0),
  inProgress(1),
  done(2);

  final int status;

  const Status(this.status);

  factory Status.fromValue(int value) =>
      Status.values.firstWhere((element) => element.status == value);
}
