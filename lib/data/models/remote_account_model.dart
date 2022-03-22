import 'package:fordev/domain/entities/account_entity.dart';

class RemoteAccountModel {
  final String accesToken;

  RemoteAccountModel(this.accesToken);

  factory RemoteAccountModel.fromJson(Map json) =>
      RemoteAccountModel(json['accessToken']);

  AccountEntity toEntity() => AccountEntity(accesToken);
}
