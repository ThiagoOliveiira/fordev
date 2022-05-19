import '../protocols/procotols.dart';

class RequiredFieldValidation implements FieldValidation {
  final String field;

  RequiredFieldValidation(this.field);

  String validate(String value) => value?.isNotEmpty == true ? null : "Campo obrigatório";
}
