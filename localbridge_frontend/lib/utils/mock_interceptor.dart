import 'package:dio/dio.dart';

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
          data: [
            {
              'title': 'Cleaning a community venue',
              'description':
              'A full deep clean of the community sports centre before an upcoming tournament weekend.',
              'location': 'Khutsong Sports Centre',
              'category': 'Cleaning',
              'deadline': 'Closes in 3 days',
              'budget': 'R 4 500,00',
              'requirements': 5,
              'status': 'Submitted',
            },
            {
              'title': 'Catering for 100 meals',
              'description':
              'A one-day community event needs 100 individually boxed hot meals delivered and served.',
              'location': 'Khutsong Community Hall',
              'category': 'Catering',
              'deadline': 'Closes in 5 days',
              'budget': 'R 7 000,00',
              'requirements': 7,
              'status': 'Draft',
            },
            {
              'title': 'Printing workshop materials',
              'description':
              'Printed workshop manuals and posters for a three-day business skills workshop at the Khutsong Skills Centre.',
              'location': 'Khutsong Skills Centre',
              'category': 'Printing',
              'deadline': 'Closes in 7 days',
              'budget': 'R 3 200,00',
              'requirements': 4,
              'status': 'Open',
            },
          ],
        ),
      );
    }
  }
}
