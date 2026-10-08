import 'package:bot_toast/bot_toast.dart';
import 'package:get/get.dart';
import 'app_menu_item.dart';

import '../../../component/networks/api.dart';
import '../../administration/User/create_subsiDiary.dart';
import '../../administration/User/create_userScreen.dart';
import '../../administration/User/subsi_diaries_screen.dart';
import '../../administration/User/user_listScreen.dart';
import '../../administration/controller/administration_controller.dart';
import '../../authorization/authorization_Screen.dart';
import 'menu_actions.dart';

/// The ADMINISTRATIONS menu.
AppMenuItem buildAdministrationMenu(MenuActions actions) {
  /// Wipes whatever the administration forms were left holding, so a fresh
  /// entry opens on an empty form.
  void resetAdministrationForm(void Function(AdministrationController) reset) {
    if (Get.isRegistered<AdministrationController>()) {
      reset(Get.find<AdministrationController>());
    }
  }

  return AppMenuItem(title: "ADMINISTRATIONS", children: [
    AppMenuItem(title: "USERS LIST", children: [
      AppMenuItem(
        title: "CREATE USER",
        onTap: () => actions.openPage(
          title: "CREATE USER",
          page: () => CreateUserScreen(),
          permission: 'create_user',
          beforeOpen: () => resetAdministrationForm((c) => c.clearUserForm()),
        ),
      ),
      AppMenuItem(
        title: "USERS",
        onTap: () => actions.openPage(
          title: "USERS",
          page: () => UserListscreen(),
          // Carried over as-is from the hand-written menu: this entry has always
          // been gated on the company-information permission, not on 'read_user'.
          permission: 'read_company_information',
        ),
      ),
      AppMenuItem(
        title: "CREATE SUBSIDIARY",
        onTap: () => actions.openPage(
          title: "CREATE SUBSIDIARY",
          page: () => CreateSubsiDiary(),
          permission: 'create_subsidiary',
          beforeOpen: () =>
              resetAdministrationForm((c) => c.clearSubsidiaryForm()),
        ),
      ),
      AppMenuItem(
        title: "SUBSIDIARIES",
        onTap: () => actions.openPage(
          title: "SUBSIDIARIES",
          page: () => SubsiDiariesScreen(),
          permission: 'read_subsidiary',
        ),
      ),
      AppMenuItem(
        title: "AUTHORIZATION",
        // Role-gated rather than permission-gated, and it stays quiet when the
        // open-page limit is reached — both as the hand-written entry was.
        onTap: () => actions.guard(
          () {
            if (Api().sp.read('userRole') == "super admin") {
              actions.showPage("AUTHORIZATION", () => AuthorizationScreen());
            } else {
              BotToast.showText(text: "Permission Denied");
            }
          },
          warnWhenFull: false,
        ),
      ),
    ]),
  ]);
}
