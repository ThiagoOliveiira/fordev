import 'package:equatable/equatable.dart';

import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  @override
  List<Object> get props => [field];

  RequiredFieldValidation(this.field);

  String validate(String value) => value?.isNotEmpty == true ? null : "Campo obrigatório";
}
