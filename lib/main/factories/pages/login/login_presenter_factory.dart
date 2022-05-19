import '../../../../ui/pages/pages.dart';
import '../../factories.dart';
import '../../../../presentation/presenters/presenters.dart';

LoginPresenter makeLoginPresenter() {
  return StreamLoginPresenter(
    authentication: makeRemoteAuthentication(),
    validation: makeLoginValidation(),
  );
}
