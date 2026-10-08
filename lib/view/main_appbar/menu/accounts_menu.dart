import 'package:get/get.dart';
import 'app_menu_item.dart';

import '../../accounts/Invoice/create_account_invoice_screen.dart';
import '../../accounts/Invoice/create_customer_invoice.dart';
import '../../accounts/Invoice/list_customer_invoices.dart';
import '../../accounts/Invoice/list_of_account_invoice_screen.dart';
import '../../accounts/account/account_view.dart';
import '../../accounts/controller/account_controller.dart';
import '../../accounts/create_escort_screen.dart';
import '../../accounts/list_escorte_screen.dart';
import '../../accounts/list_of_accountScreen.dart';
import 'menu_actions.dart';

/// The ACCOUNTS menu.
AppMenuItem buildAccountsMenu(MenuActions actions) {
  /// Wipes whatever the account forms were left holding, so a fresh entry opens
  /// on an empty form.
  void resetAccountForm(void Function(AccountController) reset) {
    if (Get.isRegistered<AccountController>()) {
      reset(Get.find<AccountController>());
    }
  }

  return AppMenuItem(title: "ACCOUNTS", children: [
    AppMenuItem(
      title: "CREATE ACCOUNT",
      onTap: () => actions.openPage(
        title: "CREATE ACCOUNT",
        page: () => AccountView(),
        permission: 'create_account',
        beforeOpen: () => resetAccountForm((c) => c.clearAccountForm()),
      ),
    ),
    AppMenuItem(
      title: "LIST OF ACCOUNTS",
      onTap: () => actions.openPage(
        title: "LIST OF ACCOUNTS",
        page: () => ListOfAccountScreen(),
        permission: 'read_account',
      ),
    ),
    AppMenuItem(
      title: "CREATE ESCORT",
      onTap: () => actions.openPage(
        title: "CREATE ESCORT",
        page: () => CreateEscortScreen(),
        permission: 'create_escort',
        beforeOpen: () => resetAccountForm((c) => c.clearEscortFields()),
      ),
    ),
    AppMenuItem(
      // The trailing space is the menu label only — the chip is titled
      // "ESCORT LIST".
      title: "ESCORT LIST ",
      onTap: () => actions.openPage(
        title: "ESCORT LIST",
        page: () => ESCORTScreen(),
        permission: 'read_escort',
      ),
    ),
    AppMenuItem(
      title: "CREATE CUSTOMER INVOICE",
      onTap: () => actions.openPage(
        title: "CREATE CUSTOMER INVOICE",
        page: () => CreateCustomerInvoice(),
        permission: 'read_customer_invoice',
      ),
    ),
    AppMenuItem(
      title: "LIST OF CUSTOMER INVOICES",
      onTap: () => actions.openPage(
        title: "LIST OF CUSTOMER INVOICES",
        page: () => InvoiceList(),
      ),
    ),
    AppMenuItem(
      title: "CREATE ACCOUNT INVOICE",
      onTap: () => actions.openPage(
        title: "CREATE ACCOUNT INVOICE",
        page: () => CreateAccountInvoiceScreen(),
        permission: 'create_account_invoice',
      ),
    ),
    AppMenuItem(
      title: "LIST OF ACCOUNT INVOICES",
      onTap: () => actions.openPage(
        title: "LIST OF ACCOUNT INVOICES",
        page: () => ListOfAccountInvoiceScreen(),
        permission: 'read_account_invoice',
      ),
    ),
  ]);
}
