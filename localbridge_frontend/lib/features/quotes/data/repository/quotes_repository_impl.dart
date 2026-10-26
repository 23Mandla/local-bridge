import 'dart:async';

import 'package:fpdart/fpdart.dart';

import 'package:localbridge_frontend/core/errors/failure_error.dart';
import 'package:localbridge_frontend/core/ids/demo_id_generator.dart';
import 'package:localbridge_frontend/core/time/date_labels.dart';
import 'package:localbridge_frontend/core/time/demo_clock.dart';
import 'package:localbridge_frontend/features/opportunities/domain/entities/opportunity.dart';
import 'package:localbridge_frontend/features/profile/domain/entities/business_profile.dart';
import 'package:localbridge_frontend/features/profile/domain/repo_contract/business_profile_repository.dart';
import 'package:localbridge_frontend/utils/mock_interceptor.dart';

import '../../domain/entities/quote.dart';
import '../../domain/entities/quote_draft_request.dart';
import '../../domain/entities/quote_status.dart';
import '../../domain/quote_submission_validator.dart';
import '../../domain/repo_contract/quotes_repository.dart';

/// In-memory quotations for the demo.
///
/// A single instance is registered in GetIt so the entrepreneur and buyer
/// screens share the same quote state; every change is pushed to the watchers.
class QuotesRepositoryImpl implements QuotesRepository {
  QuotesRepositoryImpl({
    required BusinessProfileRepository profileRepository,
    required DemoIdGenerator idGenerator,
    List<Quote>? seedQuotes,
  }) : _profileRepository = profileRepository,
       _idGenerator = idGenerator {
    _quotes.addAll(
      seedQuotes ?? _demoQuotes(_profileRepository.currentProfile),
    );
  }

  final BusinessProfileRepository _profileRepository;
  final DemoIdGenerator _idGenerator;
  final List<Quote> _quotes = <Quote>[];
  final StreamController<void> _changes = StreamController<void>.broadcast();

  @override
  Stream<List<Quote>> watchMyQuotes() async* {
    yield _sorted(_quotes);
    yield* _changes.stream.map((_) => _sorted(_quotes));
  }

  @override
  Stream<List<Quote>> watchBuyerQuotes() async* {
    List<Quote> submitted() =>
        _sorted(_quotes.where((quote) => !quote.status.isDraft).toList());
    yield submitted();
    yield* _changes.stream.map((_) => submitted());
  }

  @override
  Stream<Quote?> watchQuote(String quoteId) async* {
    yield _quoteOrNull(quoteId);
    yield* _changes.stream.map((_) => _quoteOrNull(quoteId));
  }

  @override
  Stream<Quote?> watchQuoteForOpportunity(String opportunityId) async* {
    yield _quoteForOpportunity(opportunityId);
    yield* _changes.stream.map((_) => _quoteForOpportunity(opportunityId));
  }

  @override
  Future<Either<FailureError, Quote>> getOrCreateDraft(
    QuoteDraftRequest request,
  ) async {
    final existing = _quoteForOpportunity(request.opportunityId);
    if (existing != null) return right(existing);

    if (hasClosed(request.opportunityClosingDate, now: DemoClock.today)) {
      return left(
        FailureError(
          'This opportunity is closed and can no longer receive a quote.',
        ),
      );
    }

    final profile = _profileRepository.currentProfile;
    final draft = Quote(
      id: _idGenerator.next('quote'),
      opportunityId: request.opportunityId,
      opportunityTitle: request.opportunityTitle,
      opportunityClosingDate: request.opportunityClosingDate,
      businessId: profile.businessId,
      businessName: profile.businessName,
      requirements: request.requirements,
      preparedAt: DemoClock.now(),
    );
    _upsert(draft);
    return right(draft);
  }

  @override
  Future<Either<FailureError, Quote>> saveDraft(Quote draft) async {
    final existing = _quoteOrNull(draft.id);
    if (existing != null && !existing.canBeEdited) {
      return left(
        FailureError(
          'Only draft quotes can be edited. This quote is ${existing.status.label.toLowerCase()}.',
        ),
      );
    }

    final saved = draft.copyWith(status: QuoteStatus.draft);
    _upsert(saved);
    return right(saved);
  }

  @override
  Future<Either<FailureError, Quote>> submitQuote(String quoteId) async {
    final quote = _quoteOrNull(quoteId);
    if (quote == null) return left(FailureError('Quote not found.'));
    if (!quote.canBeEdited) {
      return left(
        FailureError(
          'This quote is already ${quote.status.label.toLowerCase()} and cannot be submitted again.',
        ),
      );
    }

    final issues = QuoteSubmissionValidator.validate(
      quote,
      now: DemoClock.now(),
    );
    if (issues.isNotEmpty) return left(FailureError(issues.join('\n')));

    final submitted = quote.copyWith(
      status: QuoteStatus.submitted,
      submittedAt: DemoClock.now(),
    );
    _upsert(submitted);
    return right(submitted);
  }

  @override
  Future<Either<FailureError, Quote>> decideQuote({
    required String quoteId,
    required QuoteDecision decision,
    String? buyerNote,
  }) async {
    final quote = _quoteOrNull(quoteId);
    if (quote == null) return left(FailureError('Quote not found.'));
    if (!quote.canBeDecided) {
      return left(
        FailureError(
          'Only submitted quotes can be accepted or declined. This quote is ${quote.status.label.toLowerCase()}.',
        ),
      );
    }

    final note = buyerNote?.trim();
    final decided = quote.copyWith(
      status: decision.resultingStatus,
      decidedAt: DemoClock.now(),
      buyerNote: (note == null || note.isEmpty) ? null : note,
    );
    _upsert(decided);
    return right(decided);
  }

  Quote? _quoteOrNull(String quoteId) {
    for (final quote in _quotes) {
      if (quote.id == quoteId) return quote;
    }
    return null;
  }

  Quote? _quoteForOpportunity(String opportunityId) {
    for (final quote in _quotes) {
      if (quote.opportunityId == opportunityId) return quote;
    }
    return null;
  }

  void _upsert(Quote quote) {
    final index = _quotes.indexWhere((item) => item.id == quote.id);
    if (index == -1) {
      _quotes.add(quote);
    } else {
      _quotes[index] = quote;
    }
    _changes.add(null);
  }

  List<Quote> _sorted(List<Quote> quotes) {
    final sorted = [...quotes];
    sorted.sort((a, b) => _activityAt(b).compareTo(_activityAt(a)));
    return List.unmodifiable(sorted);
  }

  static DateTime _activityAt(Quote quote) =>
      quote.decidedAt ?? quote.submittedAt ?? quote.preparedAt;
}

Opportunity? _opportunityById(String id) {
  for (final opportunity in demoOpportunities) {
    if (opportunity.id == id) return opportunity;
  }
  return null;
}

List<RequirementResponse> _answers(
  Opportunity opportunity,
  int count, {
  int? cannotMeetIndex,
}) => [
  for (var index = 0; index < opportunity.requirements.length; index++)
    if (index < count)
      RequirementResponse(
        requirementId: opportunity.requirements[index].id,
        canMeet: index != cannotMeetIndex,
        note: index == cannotMeetIndex
            ? 'Not included in this quotation.'
            : 'Yes, we can meet this.',
      ),
];

List<QuoteRequirement> _requirementsOf(Opportunity opportunity) => [
  for (final requirement in opportunity.requirements)
    QuoteRequirement(
      id: requirement.id,
      text: requirement.text,
      isMandatory: requirement.isMandatory,
    ),
];

/// Fictional seed quotations so both demo roles have data on first launch.
List<Quote> _demoQuotes(BusinessProfile profile) {
  final quotes = <Quote>[];
  final businessId = profile.businessId;
  final businessName = profile.businessName;
  final cleaning = _opportunityById('opp-cleaning-venue');
  final catering = _opportunityById('opp-catering-100');
  final gardening = _opportunityById('opp-gardening-school');
  final laundry = _opportunityById('opp-laundry-uniforms');

  if (cleaning != null) {
    quotes.add(
      Quote(
        id: 'quote-seed-cleaning',
        opportunityId: cleaning.id,
        opportunityTitle: cleaning.title,
        opportunityClosingDate: cleaning.closingDate,
        businessId: businessId,
        businessName: businessName,
        status: QuoteStatus.submitted,
        lines: const [
          QuoteLine(
            id: 'line-seed-1',
            description: 'Deep clean of main hall, change rooms and ablutions',
            quantity: 1,
            unitPriceCents: 260000,
          ),
          QuoteLine(
            id: 'line-seed-2',
            description: 'Cleaning chemicals and consumables',
            quantity: 1,
            unitPriceCents: 90000,
          ),
        ],
        upfrontCents: 240000,
        buyerMessage:
            'We can be on site on Friday afternoon and finish before the '
            'tournament. All chemicals and equipment are included.',
        requirements: _requirementsOf(cleaning),
        responses: _answers(cleaning, 5, cannotMeetIndex: 2),
        preparedAt: DateTime(2026, 3, 12),
        submittedAt: DateTime(2026, 3, 14),
      ),
    );
  }

  if (catering != null) {
    quotes.add(
      Quote(
        id: 'quote-seed-catering',
        opportunityId: catering.id,
        opportunityTitle: catering.title,
        opportunityClosingDate: catering.closingDate,
        businessId: businessId,
        businessName: businessName,
        lines: const [
          QuoteLine(
            id: 'line-seed-3',
            description: 'Boxed hot meals (chicken and beef options)',
            quantity: 100,
            unitPriceCents: 6200,
          ),
          QuoteLine(
            id: 'line-seed-4',
            description: 'Delivery and serving staff',
            quantity: 1,
            unitPriceCents: 70000,
          ),
        ],
        upfrontCents: 414000,
        buyerMessage:
            'The menu still needs to be approved five days before the event.',
        requirements: _requirementsOf(catering),
        responses: _answers(catering, 3),
        preparedAt: DateTime(2026, 3, 16),
      ),
    );
  }

  if (gardening != null) {
    quotes.add(
      Quote(
        id: 'quote-seed-gardening',
        opportunityId: gardening.id,
        opportunityTitle: gardening.title,
        opportunityClosingDate: gardening.closingDate,
        businessId: businessId,
        businessName: businessName,
        status: QuoteStatus.accepted,
        lines: const [
          QuoteLine(
            id: 'line-seed-5',
            description: 'Site clearing and legal rubble disposal',
            quantity: 1,
            unitPriceCents: 480000,
          ),
          QuoteLine(
            id: 'line-seed-6',
            description: 'Ten indigenous shade trees planted',
            quantity: 1,
            unitPriceCents: 35000,
          ),
        ],
        upfrontCents: 300000,
        buyerMessage: 'The team can work on Saturdays only.',
        requirements: _requirementsOf(gardening),
        responses: _answers(gardening, 4),
        preparedAt: DateTime(2026, 3, 10),
        submittedAt: DateTime(2026, 3, 11),
        decidedAt: DateTime(2026, 3, 13),
        buyerNote:
            'Approved. Please start on Saturday and report to the caretaker.',
      ),
    );
  }

  if (laundry != null) {
    quotes.add(
      Quote(
        id: 'quote-seed-laundry',
        opportunityId: laundry.id,
        opportunityTitle: laundry.title,
        opportunityClosingDate: laundry.closingDate,
        businessId: businessId,
        businessName: businessName,
        status: QuoteStatus.declined,
        lines: const [
          QuoteLine(
            id: 'line-seed-7',
            description: 'Weekly kit laundry for four teams',
            quantity: 1,
            unitPriceCents: 165000,
          ),
        ],
        upfrontCents: 165000,
        buyerMessage: 'Kits are collected on Monday and Thursday mornings.',
        requirements: _requirementsOf(laundry),
        responses: _answers(laundry, 1),
        preparedAt: DateTime(2026, 3, 5),
        submittedAt: DateTime(2026, 3, 5),
        decidedAt: DateTime(2026, 3, 8),
        buyerNote:
            'Thank you. The club has sourced an in-house volunteer team this season.',
      ),
    );
  }

  return quotes;
}
