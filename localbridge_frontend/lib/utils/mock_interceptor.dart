// import 'package:dio/dio.dart';
//
// class MockInterceptor extends Interceptor {
//
//   @override
//   void onRequest(
//       RequestOptions options,
//       RequestInterceptorHandler handler,
//       ) async {
//
//     if (options.path.contains('/v1/get/opportunities')) {
//       return handler.resolve(
//         Response(
//           requestOptions: options,
//           statusCode: 200,
//           data: [
//             {
//               'title': 'Cleaning a community venue',
//               'description':
//               'A full deep clean of the community sports centre before an upcoming tournament weekend.',
//               'location': 'Khutsong Sports Centre',
//               'category': 'Cleaning',
//               'deadline': 'Closes in 3 days',
//               'budget': 'R 4 500,00',
//               'requirements': 5,
//               'status': 'Submitted',
//             },
//             {
//               'title': 'Catering for 100 meals',
//               'description':
//               'A one-day community event needs 100 individually boxed hot meals delivered and served.',
//               'location': 'Khutsong Community Hall',
//               'category': 'Catering',
//               'deadline': 'Closes in 5 days',
//               'budget': 'R 7 000,00',
//               'requirements': 7,
//               'status': 'Draft',
//             },
//             {
//               'title': 'Printing workshop materials',
//               'description':
//               'Printed workshop manuals and posters for a three-day business skills workshop at the Khutsong Skills Centre.',
//               'location': 'Khutsong Skills Centre',
//               'category': 'Printing',
//               'deadline': 'Closes in 7 days',
//               'budget': 'R 3 200,00',
//               'requirements': 4,
//               'status': 'Open',
//             },
//           ],
//         ),
//       );
//     }
//   }
// }

import 'package:dio/dio.dart';

import '../features/opportunities/data/dto/opportunities_dto.dart';
import '../features/opportunities/domain/entities/opportunity.dart';
import '../features/opportunities/domain/entities/opportunity_requirements.dart';
import '../features/opportunities/domain/entities/opportunity_status.dart';

/// Serves the demo opportunity catalogue instead of calling a real backend.
///
/// The rows below are fictional demo records and are the single source of truth
/// for opportunities: the same seed feeds the API mock and, through the
/// opportunity ids, the quotations created in the quotes feature.
class MockInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    if (options.path.contains('/v1/get/opportunities')) {
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: demoOpportunities
              .map(
                (opportunity) =>
                OpportunitiesDto.fromDomain(opportunity).toJson(),
          )
              .toList(),
        ),
      );
    }
  }
}

List<OpportunityRequirements> _requirements(
    String opportunityId,
    List<(String, bool)> items,
    ) => [
  for (var index = 0; index < items.length; index++)
    OpportunityRequirements(
      id: '$opportunityId-r${index + 1}',
      text: items[index].$1,
      isMandatory: items[index].$2,
    ),
];

/// Fictional demo opportunities shown in the Entrepreneur destination.
final List<Opportunity> demoOpportunities = <Opportunity>[
  Opportunity(
    id: 'opp-cleaning-venue',
    title: 'Deep clean of the community sports centre',
    description:
    'A full deep clean of the community sports centre before the annual '
        'youth games weekend, including the hall, change rooms and ablutions.',
    location: 'Khutsong Sports Centre, Carletonville',
    category: 'Cleaning',
    closingDate: DateTime(2026, 3, 19),
    deliveryDate: DateTime(2026, 3, 26),
    budgetCents: 450000,
    status: OpportunityStatus.open,
    buyerName: 'Thabo Mokoena',
    buyerOrganisation: 'Khutsong Sports Council',
    requirements: _requirements('opp-cleaning-venue', const [
      ('Team of at least six cleaners on site', true),
      ('All cleaning chemicals and equipment supplied', true),
      ('Public liability cover for the work', false),
      ('Work completed outside school and match hours', false),
      ('Before and after photographs provided', false),
    ]),
  ),
  Opportunity(
    id: 'opp-catering-100',
    title: 'Catering for 100 boxed meals',
    description:
    'A one-day community event needs 100 individually boxed hot meals '
        'prepared, delivered and served on site.',
    location: 'Khutsong Community Hall',
    category: 'Catering',
    closingDate: DateTime(2026, 3, 21),
    deliveryDate: DateTime(2026, 3, 28),
    budgetCents: 700000,
    status: OpportunityStatus.open,
    buyerName: 'Lerato Sithole',
    buyerOrganisation: 'Khutsong Community Trust',
    requirements: _requirements('opp-catering-100', const [
      ('Meals delivered hot by 11:00 on the day', true),
      ('Food handling certificates for the kitchen team', true),
      ('Vegetarian option for at least 20 meals', true),
      ('Recyclable packaging used', false),
      ('Two serving staff for the duration of the event', false),
      ('Menu approved five days before the event', true),
      ('Leftover food donated to the local shelter', false),
    ]),
  ),
  Opportunity(
    id: 'opp-printing-workshop',
    title: 'Printing of workshop manuals and posters',
    description:
    'Printed workshop manuals and posters for a three-day business skills '
        'workshop at the Skills Centre.',
    location: 'Khutsong Skills Centre',
    category: 'Printing',
    closingDate: DateTime(2026, 3, 23),
    deliveryDate: DateTime(2026, 4, 2),
    budgetCents: 320000,
    status: OpportunityStatus.open,
    buyerName: 'Sipho Ndlovu',
    buyerOrganisation: 'Khutsong Skills Centre',
    requirements: _requirements('opp-printing-workshop', const [
      ('120 full-colour manuals, bound', true),
      ('40 A2 posters on weather-resistant paper', true),
      ('Delivery to the skills centre included', false),
      ('Digital proof approved before printing', true),
    ]),
  ),
  Opportunity(
    id: 'opp-security-event',
    title: 'Event security for the annual youth games',
    description:
    'Access control and visible security presence for a two-day youth '
        'sports tournament at the stadium.',
    location: 'Khutsong Stadium',
    category: 'Security',
    closingDate: DateTime(2026, 3, 18),
    deliveryDate: DateTime(2026, 3, 29),
    budgetCents: 980000,
    status: OpportunityStatus.open,
    buyerName: 'Zanele Khumalo',
    buyerOrganisation: 'Khutsong Youth Forum',
    requirements: _requirements('opp-security-event', const [
      ('Minimum of ten registered security officers', true),
      ('Handheld scanners at all three gates', true),
      ('Two officers on the field perimeter at all times', true),
      ('Incident report submitted within 24 hours', false),
      ('Officers in identifiable uniforms', false),
      ('Radio communication between all gates', false),
    ]),
  ),
  Opportunity(
    id: 'opp-gardening-school',
    title: 'Clearing and gardening at the primary school',
    description:
    'Clearing overgrown grass, removing rubble and planting shade trees '
        'around the school grounds before the new term.',
    location: 'Khutsong Primary School',
    category: 'Landscaping',
    closingDate: DateTime(2026, 3, 12),
    deliveryDate: DateTime(2026, 3, 22),
    budgetCents: 520000,
    status: OpportunityStatus.closed,
    buyerName: 'Mandla Radebe',
    buyerOrganisation: 'Khutsong Primary School Governing Body',
    requirements: _requirements('opp-gardening-school', const [
      ('Rubble removed and disposed of legally', true),
      ('Ten indigenous shade trees planted', true),
      ('Work done on a Saturday to avoid lessons', false),
      ('Grounds left level and safe for learners', false),
    ]),
  ),
  Opportunity(
    id: 'opp-laundry-uniforms',
    title: 'Laundry service for netball team kits',
    description:
    'Weekly collection, washing and return of netball kit for four teams '
        'for the remainder of the season.',
    location: 'Khutsong Netball Club',
    category: 'Laundry',
    closingDate: DateTime(2026, 3, 6),
    deliveryDate: DateTime(2026, 3, 15),
    budgetCents: 180000,
    status: OpportunityStatus.closed,
    buyerName: 'Precious Mahlangu',
    buyerOrganisation: 'Khutsong Netball Club',
    requirements: _requirements('opp-laundry-uniforms', const [
      ('Kits collected and returned twice a week', true),
      ('Stain treatment included at no extra cost', false),
      ('Damaged kit reported immediately', false),
    ]),
  ),
];