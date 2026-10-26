enum OpportunityStatus {
  open('Open'),
  closed('Closed');

  const OpportunityStatus(this.label);

  final String label;

  static OpportunityStatus fromLabel(String label) => values.firstWhere(
        (status) => status.label.toLowerCase() == label.toLowerCase(),
    orElse: () => OpportunityStatus.open,
  );
}