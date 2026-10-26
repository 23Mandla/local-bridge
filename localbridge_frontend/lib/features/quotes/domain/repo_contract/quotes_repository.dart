import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failure_error.dart';
import '../entities/quote.dart';
import '../entities/quote_draft_request.dart';
import '../entities/quote_status.dart';

/// Quotes owned by the quotes feature.
///
/// The demo implementation keeps state in memory, so the same repository
/// instance is shared by the entrepreneur and buyer screens and every screen
/// watching a stream sees buyer decisions immediately.
abstract interface class QuotesRepository {
  /// Every quote of the signed-in business, drafts included.
  Stream<List<Quote>> watchMyQuotes();

  /// Quotes that have reached the buyer, newest submission first.
  Stream<List<Quote>> watchBuyerQuotes();

  /// A single quote, emitting `null` when it does not exist.
  Stream<Quote?> watchQuote(String quoteId);

  /// The quote (if any) prepared for an opportunity.
  Stream<Quote?> watchQuoteForOpportunity(String opportunityId);

  /// Returns the existing draft for the opportunity, or creates one.
  Future<Either<FailureError, Quote>> getOrCreateDraft(
      QuoteDraftRequest request,
      );

  Future<Either<FailureError, Quote>> saveDraft(Quote draft);

  Future<Either<FailureError, Quote>> submitQuote(String quoteId);

  Future<Either<FailureError, Quote>> decideQuote({
    required String quoteId,
    required QuoteDecision decision,
    String? buyerNote,
  });
}