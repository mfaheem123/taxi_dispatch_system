import 'package:flutter/material.dart';

import '../../invoices/account_invoices/create_account_invoice_screen.dart';
import '../../invoices/customer_invoices/create_customer_invoice.dart';
import '../../invoices/account_invoices/list_of_account_invoice_screen.dart';
import '../../invoices/customer_invoices/list_of_customer_invoice.dart';
import 'app_menu_item.dart';
import 'menu_actions.dart';

AppMenuItem buildInvoicesMenu(MenuActions actions) {
  return AppMenuItem(title: "INVOICES", icon: Icons.receipt_long, children: [
    AppMenuItem(
        title: "CREATE CUSTOMER INVOICE",
        onTap: () => actions.openPage(
          title:  "CREATE CUSTOMER INVOICE",
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
