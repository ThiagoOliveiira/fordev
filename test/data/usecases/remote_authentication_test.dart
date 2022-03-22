import 'package:faker/faker.dart';
import 'package:fordev/data/usecases/http/http.dart';
import 'package:fordev/data/usecases/remote_authentication.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/authentication.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  final httpClient = HttpClientSpy();
  final url = faker.internet.httpUrl();
  final sut = RemoteAuthentication(httpClient: httpClient, url: url);
  AuthenticationParams params;
  test('Should call HttpClient with correct URL', () async {
    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    final accessToken = faker.guid.guid();
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async =>
            {'accessToken': accessToken, 'name': faker.person.name()});

    await sut.auth(params);

    verify(httpClient.request(
      url: url,
      method: 'post',
      body: {"email": params.email, "password": params.password},
    ));
  });

  test('Should throw UnexpectError if HttpClient returns 400', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.badRequest);

    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectError if HttpClient returns 404', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.notFound);

    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectError if HttpClient returns 500', () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.serverError);

    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw InvalidCredentialsError if HttpClient returns 401',
      () async {
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenThrow(HttpError.unauthorized);

    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());
    final future = sut.auth(params);

    expect(future, throwsA(DomainError.invalidCredenctials));
  });

  test('Should return an Account if HttpClient returns 200', () async {
    final accessToken = faker.guid.guid();
    when(httpClient.request(
            url: anyNamed('url'),
            method: anyNamed('method'),
            body: anyNamed('body')))
        .thenAnswer((_) async =>
            {'accessToken': accessToken, 'name': faker.person.name()});

    params = AuthenticationParams(
        email: faker.internet.email(), password: faker.internet.password());

    final account = await sut.auth(params);

    expect(account?.token, accessToken);
  });
}
