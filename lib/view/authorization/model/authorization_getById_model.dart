// To parse this JSON data, do
//
//     final getAuthorizationByRoleIdModel = getAuthorizationByRoleIdModelFromJson(jsonString);

import 'dart:convert';

GetAuthorizationByRoleIdModel getAuthorizationByRoleIdModelFromJson(String str) => GetAuthorizationByRoleIdModel.fromJson(json.decode(str));

String getAuthorizationByRoleIdModelToJson(GetAuthorizationByRoleIdModel data) => json.encode(data.toJson());

class GetAuthorizationByRoleIdModel {
  bool? status;
  Permissions? permissions;

  GetAuthorizationByRoleIdModel({
    this.status,
    this.permissions,
  });

  factory GetAuthorizationByRoleIdModel.fromJson(Map<String, dynamic> json) => GetAuthorizationByRoleIdModel(
    status: json["status"],
    permissions: json["permissions"] == null ? null : Permissions.fromJson(json["permissions"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "permissions": permissions?.toJson(),
  };
}

class Permissions {
  int? id;
  int? roleId;
  bool? createUser;
  bool? readCompanyInformation;
  bool? updateCompanyInformation;
  bool? readCompanyConfiguration;
  bool? updateCompanyConfiguration;
  bool? readVoipSettings;
  bool? createTemplateType;
  bool? readTemplateTypes;
  bool? readTemplateType;
  bool? updateTemplateType;
  bool? deleteTemplateType;
  bool? createTemplate;
  bool? readTemplates;
  bool? readTemplate;
  bool? updateTemplate;
  bool? deleteTemplate;
  bool? createSmsTemplate;
  bool? createDocumentNumber;
  bool? readDocumentNumber;
  bool? readDocumentNumbers;
  bool? updateDocumentNumber;
  bool? deleteDocumentNumber;
  bool? createFeedback;
  bool? readFeedback;
  bool? readFeedbacks;
  bool? updateFeedback;
  bool? deleteFeedback;
  bool? createLostProperty;
  bool? readLostProperty;
  bool? readLostProperties;
  bool? updateLostProperty;
  bool? deleteLostProperty;
  bool? createSubsidiary;
  bool? readSubsidiaries;
  bool? readSubsidiary;
  bool? updateSubsidiary;
  bool? deleteSubsidiary;
  bool? readRole;
  bool? readRoles;
  bool? updateRole;
  bool? createEmployee;
  bool? readEmployee;
  bool? readEmployees;
  bool? updateEmployee;
  bool? deleteEmployee;
  bool? createVehicleType;
  bool? readVehicleTypes;
  bool? readVehicleType;
  bool? updateVehicleType;
  bool? deleteVehicleType;
  bool? createCompanyVehicle;
  bool? readCompanyVehicles;
  bool? readCompanyVehicle;
  bool? updateCompanyVehicle;
  bool? deleteCompanyVehicle;
  bool? createVehicle;
  bool? readVehicles;
  bool? readVehicle;
  bool? updateVehicle;
  bool? deleteVehicle;
  bool? createEndVehicle;
  bool? createCustomer;
  bool? readCustomers;
  bool? readCustomer;
  bool? updateCustomer;
  bool? deleteCustomer;
  bool? createComplaint;
  bool? readComplaint;
  bool? readComplaints;
  bool? updateComplaint;
  bool? deleteComplaint;
  bool? createDriver;
  bool? readDrivers;
  bool? readDriver;
  bool? updateDriver;
  bool? updateDriverZone;
  bool? deleteDriver;
  bool? createEndDriver;
  bool? createDriverShift;
  bool? readDriverShift;
  bool? readDriverShifts;
  bool? updateDriverShift;
  bool? deleteDriverShift;
  bool? createDriverAvailability;
  bool? readDriverAvailability;
  bool? readDriverAvailabilities;
  bool? updateDriverAvailability;
  bool? deleteDriverAvailability;
  bool? createDriverBooking;
  bool? readDriverBooking;
  bool? readDriverBookings;
  bool? updateDriverBooking;
  bool? deleteDriverBooking;
  bool? createDriverCommission;
  bool? readDriverCommission;
  bool? readDriverCommissions;
  bool? updateDriverCommission;
  bool? deleteDriverCommission;
  bool? createDriverCommissionAccount;
  bool? readDriverCommissionAccount;
  bool? readDriverCommissionAccounts;
  bool? updateDriverCommissionAccount;
  bool? deleteDriverCommissionAccount;
  bool? createDriverCommissionLineitem;
  bool? readDriverCommissionLineitem;
  bool? readDriverCommissionLineitems;
  bool? updateDriverCommissionLineitem;
  bool? deleteDriverCommissionLineitem;
  bool? createDriverShiftHistory;
  bool? readDriverShiftHistory;
  bool? readDriverShiftHistories;
  bool? updateDriverShiftHistory;
  bool? deleteDriverShiftHistory;
  bool? createAccount;
  bool? readAccounts;
  bool? readAccount;
  bool? updateAccount;
  bool? deleteAccount;
  bool? createMessage;
  bool? readMessage;
  bool? readMessages;
  bool? updateMessage;
  bool? deleteMessage;
  bool? createNotification;
  bool? readNotification;
  bool? readNotifications;
  bool? updateNotification;
  bool? deleteNotification;
  bool? createAudit;
  bool? readAudit;
  bool? readAudits;
  bool? updateAudit;
  bool? deleteAudit;
  bool? readAppFeature;
  bool? readAppFeatures;
  bool? updateAppFeature;
  bool? createEscort;
  bool? updateEscort;
  bool? deleteEscort;
  bool? readEscort;
  bool? readEscorts;
  bool? updateAppVersion;
  bool? createEmployeeShiftHistory;
  bool? readEmployeeShiftHistory;
  bool? updateEmployeeShiftHistory;
  bool? createAccountWebLogin;
  bool? readAccountWebLogin;
  bool? updateAccountWebLogin;
  bool? deleteAccountWebLogin;
  bool? createAccountOrderNumber;
  bool? readAccountOrderNumber;
  bool? updateAccountOrderNumber;
  bool? deleteAccountOrderNumber;
  bool? createAccountDepartment;
  bool? readAccountDepartment;
  bool? updateAccountDepartment;
  bool? deleteAccountDepartment;
  bool? createAccountContact;
  bool? readAccountContact;
  bool? updateAccountContact;
  bool? deleteAccountContact;
  bool? createAccountCompanyAddress;
  bool? readAccountCompanyAddress;
  bool? updateAccountCompanyAddress;
  bool? deleteAccountCompanyAddress;
  bool? createFareConfiguration;
  bool? readFareConfiguration;
  bool? updateFareConfiguration;
  bool? deleteFareConfiguration;
  bool? createFixedFare;
  bool? readFixedFare;
  bool? updateFixedFare;
  bool? deleteFixedFare;
  bool? createFareByVehicle;
  bool? readFareByVehicle;
  bool? updateFareByVehicle;
  bool? deleteFareByVehicle;
  bool? createFareConfigurationMileage;
  bool? readFareConfigurationMileage;
  bool? updateFareConfigurationMileage;
  bool? deleteFareConfigurationMileage;
  bool? createLocationType;
  bool? readLocationType;
  bool? updateLocationType;
  bool? deleteLocationType;
  bool? createLocation;
  bool? readLocation;
  bool? updateLocation;
  bool? deleteLocation;
  bool? createLocalizationDetail;
  bool? readLocalizationDetail;
  bool? updateLocalizationDetail;
  bool? deleteLocalizationDetail;
  bool? createMainData;
  bool? readMainData;
  bool? updateMainData;
  bool? deleteMainData;
  bool? createDetailData;
  bool? readDetailData;
  bool? updateDetailData;
  bool? deleteDetailData;
  bool? createZone;
  bool? readZone;
  bool? updateZone;
  bool? deleteZone;
  bool? createJourneyType;
  bool? readJourneyType;
  bool? updateJourneyType;
  bool? deleteJourneyType;
  bool? createPaymentType;
  bool? readPaymentType;
  bool? updatePaymentType;
  bool? deletePaymentType;
  bool? createBooking;
  bool? readBooking;
  bool? updateBooking;
  bool? deleteBooking;
  bool? createBookingRoute;
  bool? readBookingRoute;
  bool? updateBookingRoute;
  bool? deleteBookingRoute;
  bool? createTrashBooking;
  bool? readTrashBooking;
  bool? updateTrashBooking;
  bool? deleteTrashBooking;
  bool? createBookingAudit;
  bool? readBookingAudit;
  bool? updateBookingAudit;
  bool? deleteBookingAudit;
  bool? createCustomerInvoice;
  bool? readCustomerInvoice;
  bool? updateCustomerInvoice;
  bool? deleteCustomerInvoice;
  bool? createCustomerInvoiceLineitem;
  bool? readCustomerInvoiceLineitem;
  bool? updateCustomerInvoiceLineitem;
  bool? deleteCustomerInvoiceLineitem;
  bool? createAccountInvoice;
  bool? readAccountInvoice;
  bool? updateAccountInvoice;
  bool? deleteAccountInvoice;
  bool? createAccountInvoiceLineitem;
  bool? readAccountInvoiceLineitem;
  bool? updateAccountInvoiceLineitem;
  bool? deleteAccountInvoiceLineitem;
  Role? role;

  Permissions({
    this.id,
    this.roleId,
    this.createUser,
    this.readCompanyInformation,
    this.updateCompanyInformation,
    this.readCompanyConfiguration,
    this.updateCompanyConfiguration,
    this.readVoipSettings,
    this.createTemplateType,
    this.readTemplateTypes,
    this.readTemplateType,
    this.updateTemplateType,
    this.deleteTemplateType,
    this.createTemplate,
    this.readTemplates,
    this.readTemplate,
    this.updateTemplate,
    this.deleteTemplate,
    this.createSmsTemplate,
    this.createDocumentNumber,
    this.readDocumentNumber,
    this.readDocumentNumbers,
    this.updateDocumentNumber,
    this.deleteDocumentNumber,
    this.createFeedback,
    this.readFeedback,
    this.readFeedbacks,
    this.updateFeedback,
    this.deleteFeedback,
    this.createLostProperty,
    this.readLostProperty,
    this.readLostProperties,
    this.updateLostProperty,
    this.deleteLostProperty,
    this.createSubsidiary,
    this.readSubsidiaries,
    this.readSubsidiary,
    this.updateSubsidiary,
    this.deleteSubsidiary,
    this.readRole,
    this.readRoles,
    this.updateRole,
    this.createEmployee,
    this.readEmployee,
    this.readEmployees,
    this.updateEmployee,
    this.deleteEmployee,
    this.createVehicleType,
    this.readVehicleTypes,
    this.readVehicleType,
    this.updateVehicleType,
    this.deleteVehicleType,
    this.createCompanyVehicle,
    this.readCompanyVehicles,
    this.readCompanyVehicle,
    this.updateCompanyVehicle,
    this.deleteCompanyVehicle,
    this.createVehicle,
    this.readVehicles,
    this.readVehicle,
    this.updateVehicle,
    this.deleteVehicle,
    this.createEndVehicle,
    this.createCustomer,
    this.readCustomers,
    this.readCustomer,
    this.updateCustomer,
    this.deleteCustomer,
    this.createComplaint,
    this.readComplaint,
    this.readComplaints,
    this.updateComplaint,
    this.deleteComplaint,
    this.createDriver,
    this.readDrivers,
    this.readDriver,
    this.updateDriver,
    this.updateDriverZone,
    this.deleteDriver,
    this.createEndDriver,
    this.createDriverShift,
    this.readDriverShift,
    this.readDriverShifts,
    this.updateDriverShift,
    this.deleteDriverShift,
    this.createDriverAvailability,
    this.readDriverAvailability,
    this.readDriverAvailabilities,
    this.updateDriverAvailability,
    this.deleteDriverAvailability,
    this.createDriverBooking,
    this.readDriverBooking,
    this.readDriverBookings,
    this.updateDriverBooking,
    this.deleteDriverBooking,
    this.createDriverCommission,
    this.readDriverCommission,
    this.readDriverCommissions,
    this.updateDriverCommission,
    this.deleteDriverCommission,
    this.createDriverCommissionAccount,
    this.readDriverCommissionAccount,
    this.readDriverCommissionAccounts,
    this.updateDriverCommissionAccount,
    this.deleteDriverCommissionAccount,
    this.createDriverCommissionLineitem,
    this.readDriverCommissionLineitem,
    this.readDriverCommissionLineitems,
    this.updateDriverCommissionLineitem,
    this.deleteDriverCommissionLineitem,
    this.createDriverShiftHistory,
    this.readDriverShiftHistory,
    this.readDriverShiftHistories,
    this.updateDriverShiftHistory,
    this.deleteDriverShiftHistory,
    this.createAccount,
    this.readAccounts,
    this.readAccount,
    this.updateAccount,
    this.deleteAccount,
    this.createMessage,
    this.readMessage,
    this.readMessages,
    this.updateMessage,
    this.deleteMessage,
    this.createNotification,
    this.readNotification,
    this.readNotifications,
    this.updateNotification,
    this.deleteNotification,
    this.createAudit,
    this.readAudit,
    this.readAudits,
    this.updateAudit,
    this.deleteAudit,
    this.readAppFeature,
    this.readAppFeatures,
    this.updateAppFeature,
    this.createEscort,
    this.updateEscort,
    this.deleteEscort,
    this.readEscort,
    this.readEscorts,
    this.updateAppVersion,
    this.createEmployeeShiftHistory,
    this.readEmployeeShiftHistory,
    this.updateEmployeeShiftHistory,
    this.createAccountWebLogin,
    this.readAccountWebLogin,
    this.updateAccountWebLogin,
    this.deleteAccountWebLogin,
    this.createAccountOrderNumber,
    this.readAccountOrderNumber,
    this.updateAccountOrderNumber,
    this.deleteAccountOrderNumber,
    this.createAccountDepartment,
    this.readAccountDepartment,
    this.updateAccountDepartment,
    this.deleteAccountDepartment,
    this.createAccountContact,
    this.readAccountContact,
    this.updateAccountContact,
    this.deleteAccountContact,
    this.createAccountCompanyAddress,
    this.readAccountCompanyAddress,
    this.updateAccountCompanyAddress,
    this.deleteAccountCompanyAddress,
    this.createFareConfiguration,
    this.readFareConfiguration,
    this.updateFareConfiguration,
    this.deleteFareConfiguration,
    this.createFixedFare,
    this.readFixedFare,
    this.updateFixedFare,
    this.deleteFixedFare,
    this.createFareByVehicle,
    this.readFareByVehicle,
    this.updateFareByVehicle,
    this.deleteFareByVehicle,
    this.createFareConfigurationMileage,
    this.readFareConfigurationMileage,
    this.updateFareConfigurationMileage,
    this.deleteFareConfigurationMileage,
    this.createLocationType,
    this.readLocationType,
    this.updateLocationType,
    this.deleteLocationType,
    this.createLocation,
    this.readLocation,
    this.updateLocation,
    this.deleteLocation,
    this.createLocalizationDetail,
    this.readLocalizationDetail,
    this.updateLocalizationDetail,
    this.deleteLocalizationDetail,
    this.createMainData,
    this.readMainData,
    this.updateMainData,
    this.deleteMainData,
    this.createDetailData,
    this.readDetailData,
    this.updateDetailData,
    this.deleteDetailData,
    this.createZone,
    this.readZone,
    this.updateZone,
    this.deleteZone,
    this.createJourneyType,
    this.readJourneyType,
    this.updateJourneyType,
    this.deleteJourneyType,
    this.createPaymentType,
    this.readPaymentType,
    this.updatePaymentType,
    this.deletePaymentType,
    this.createBooking,
    this.readBooking,
    this.updateBooking,
    this.deleteBooking,
    this.createBookingRoute,
    this.readBookingRoute,
    this.updateBookingRoute,
    this.deleteBookingRoute,
    this.createTrashBooking,
    this.readTrashBooking,
    this.updateTrashBooking,
    this.deleteTrashBooking,
    this.createBookingAudit,
    this.readBookingAudit,
    this.updateBookingAudit,
    this.deleteBookingAudit,
    this.createCustomerInvoice,
    this.readCustomerInvoice,
    this.updateCustomerInvoice,
    this.deleteCustomerInvoice,
    this.createCustomerInvoiceLineitem,
    this.readCustomerInvoiceLineitem,
    this.updateCustomerInvoiceLineitem,
    this.deleteCustomerInvoiceLineitem,
    this.createAccountInvoice,
    this.readAccountInvoice,
    this.updateAccountInvoice,
    this.deleteAccountInvoice,
    this.createAccountInvoiceLineitem,
    this.readAccountInvoiceLineitem,
    this.updateAccountInvoiceLineitem,
    this.deleteAccountInvoiceLineitem,
    this.role,
  });

  factory Permissions.fromJson(Map<String, dynamic> json) => Permissions(
    id: json["id"],
    roleId: json["role_id"],
    createUser: json["create_user"],
    readCompanyInformation: json["read_company_information"],
    updateCompanyInformation: json["update_company_information"],
    readCompanyConfiguration: json["read_company_configuration"],
    updateCompanyConfiguration: json["update_company_configuration"],
    readVoipSettings: json["read_voip_settings"],
    createTemplateType: json["create_template_type"],
    readTemplateTypes: json["read_template_types"],
    readTemplateType: json["read_template_type"],
    updateTemplateType: json["update_template_type"],
    deleteTemplateType: json["delete_template_type"],
    createTemplate: json["create_template"],
    readTemplates: json["read_templates"],
    readTemplate: json["read_template"],
    updateTemplate: json["update_template"],
    deleteTemplate: json["delete_template"],
    createSmsTemplate: json["create_sms_template"],
    createDocumentNumber: json["create_document_number"],
    readDocumentNumber: json["read_document_number"],
    readDocumentNumbers: json["read_document_numbers"],
    updateDocumentNumber: json["update_document_number"],
    deleteDocumentNumber: json["delete_document_number"],
    createFeedback: json["create_feedback"],
    readFeedback: json["read_feedback"],
    readFeedbacks: json["read_feedbacks"],
    updateFeedback: json["update_feedback"],
    deleteFeedback: json["delete_feedback"],
    createLostProperty: json["create_lost_property"],
    readLostProperty: json["read_lost_property"],
    readLostProperties: json["read_lost_properties"],
    updateLostProperty: json["update_lost_property"],
    deleteLostProperty: json["delete_lost_property"],
    createSubsidiary: json["create_subsidiary"],
    readSubsidiaries: json["read_subsidiaries"],
    readSubsidiary: json["read_subsidiary"],
    updateSubsidiary: json["update_subsidiary"],
    deleteSubsidiary: json["delete_subsidiary"],
    readRole: json["read_role"],
    readRoles: json["read_roles"],
    updateRole: json["update_role"],
    createEmployee: json["create_employee"],
    readEmployee: json["read_employee"],
    readEmployees: json["read_employees"],
    updateEmployee: json["update_employee"],
    deleteEmployee: json["delete_employee"],
    createVehicleType: json["create_vehicle_type"],
    readVehicleTypes: json["read_vehicle_types"],
    readVehicleType: json["read_vehicle_type"],
    updateVehicleType: json["update_vehicle_type"],
    deleteVehicleType: json["delete_vehicle_type"],
    createCompanyVehicle: json["create_company_vehicle"],
    readCompanyVehicles: json["read_company_vehicles"],
    readCompanyVehicle: json["read_company_vehicle"],
    updateCompanyVehicle: json["update_company_vehicle"],
    deleteCompanyVehicle: json["delete_company_vehicle"],
    createVehicle: json["create_vehicle"],
    readVehicles: json["read_vehicles"],
    readVehicle: json["read_vehicle"],
    updateVehicle: json["update_vehicle"],
    deleteVehicle: json["delete_vehicle"],
    createEndVehicle: json["create_end_vehicle"],
    createCustomer: json["create_customer"],
    readCustomers: json["read_customers"],
    readCustomer: json["read_customer"],
    updateCustomer: json["update_customer"],
    deleteCustomer: json["delete_customer"],
    createComplaint: json["create_complaint"],
    readComplaint: json["read_complaint"],
    readComplaints: json["read_complaints"],
    updateComplaint: json["update_complaint"],
    deleteComplaint: json["delete_complaint"],
    createDriver: json["create_driver"],
    readDrivers: json["read_drivers"],
    readDriver: json["read_driver"],
    updateDriver: json["update_driver"],
    updateDriverZone: json["update_driver_zone"],
    deleteDriver: json["delete_driver"],
    createEndDriver: json["create_end_driver"],
    createDriverShift: json["create_driver_shift"],
    readDriverShift: json["read_driver_shift"],
    readDriverShifts: json["read_driver_shifts"],
    updateDriverShift: json["update_driver_shift"],
    deleteDriverShift: json["delete_driver_shift"],
    createDriverAvailability: json["create_driver_availability"],
    readDriverAvailability: json["read_driver_availability"],
    readDriverAvailabilities: json["read_driver_availabilities"],
    updateDriverAvailability: json["update_driver_availability"],
    deleteDriverAvailability: json["delete_driver_availability"],
    createDriverBooking: json["create_driver_booking"],
    readDriverBooking: json["read_driver_booking"],
    readDriverBookings: json["read_driver_bookings"],
    updateDriverBooking: json["update_driver_booking"],
    deleteDriverBooking: json["delete_driver_booking"],
    createDriverCommission: json["create_driver_commission"],
    readDriverCommission: json["read_driver_commission"],
    readDriverCommissions: json["read_driver_commissions"],
    updateDriverCommission: json["update_driver_commission"],
    deleteDriverCommission: json["delete_driver_commission"],
    createDriverCommissionAccount: json["create_driver_commission_account"],
    readDriverCommissionAccount: json["read_driver_commission_account"],
    readDriverCommissionAccounts: json["read_driver_commission_accounts"],
    updateDriverCommissionAccount: json["update_driver_commission_account"],
    deleteDriverCommissionAccount: json["delete_driver_commission_account"],
    createDriverCommissionLineitem: json["create_driver_commission_lineitem"],
    readDriverCommissionLineitem: json["read_driver_commission_lineitem"],
    readDriverCommissionLineitems: json["read_driver_commission_lineitems"],
    updateDriverCommissionLineitem: json["update_driver_commission_lineitem"],
    deleteDriverCommissionLineitem: json["delete_driver_commission_lineitem"],
    createDriverShiftHistory: json["create_driver_shift_history"],
    readDriverShiftHistory: json["read_driver_shift_history"],
    readDriverShiftHistories: json["read_driver_shift_histories"],
    updateDriverShiftHistory: json["update_driver_shift_history"],
    deleteDriverShiftHistory: json["delete_driver_shift_history"],
    createAccount: json["create_account"],
    readAccounts: json["read_accounts"],
    readAccount: json["read_account"],
    updateAccount: json["update_account"],
    deleteAccount: json["delete_account"],
    createMessage: json["create_message"],
    readMessage: json["read_message"],
    readMessages: json["read_messages"],
    updateMessage: json["update_message"],
    deleteMessage: json["delete_message"],
    createNotification: json["create_notification"],
    readNotification: json["read_notification"],
    readNotifications: json["read_notifications"],
    updateNotification: json["update_notification"],
    deleteNotification: json["delete_notification"],
    createAudit: json["create_audit"],
    readAudit: json["read_audit"],
    readAudits: json["read_audits"],
    updateAudit: json["update_audit"],
    deleteAudit: json["delete_audit"],
    readAppFeature: json["read_app_feature"],
    readAppFeatures: json["read_app_features"],
    updateAppFeature: json["update_app_feature"],
    createEscort: json["create_escort"],
    updateEscort: json["update_escort"],
    deleteEscort: json["delete_escort"],
    readEscort: json["read_escort"],
    readEscorts: json["read_escorts"],
    updateAppVersion: json["update_app_version"],
    createEmployeeShiftHistory: json["create_employee_shift_history"],
    readEmployeeShiftHistory: json["read_employee_shift_history"],
    updateEmployeeShiftHistory: json["update_employee_shift_history"],
    createAccountWebLogin: json["create_account_web_login"],
    readAccountWebLogin: json["read_account_web_login"],
    updateAccountWebLogin: json["update_account_web_login"],
    deleteAccountWebLogin: json["delete_account_web_login"],
    createAccountOrderNumber: json["create_account_order_number"],
    readAccountOrderNumber: json["read_account_order_number"],
    updateAccountOrderNumber: json["update_account_order_number"],
    deleteAccountOrderNumber: json["delete_account_order_number"],
    createAccountDepartment: json["create_account_department"],
    readAccountDepartment: json["read_account_department"],
    updateAccountDepartment: json["update_account_department"],
    deleteAccountDepartment: json["delete_account_department"],
    createAccountContact: json["create_account_contact"],
    readAccountContact: json["read_account_contact"],
    updateAccountContact: json["update_account_contact"],
    deleteAccountContact: json["delete_account_contact"],
    createAccountCompanyAddress: json["create_account_company_address"],
    readAccountCompanyAddress: json["read_account_company_address"],
    updateAccountCompanyAddress: json["update_account_company_address"],
    deleteAccountCompanyAddress: json["delete_account_company_address"],
    createFareConfiguration: json["create_fare_configuration"],
    readFareConfiguration: json["read_fare_configuration"],
    updateFareConfiguration: json["update_fare_configuration"],
    deleteFareConfiguration: json["delete_fare_configuration"],
    createFixedFare: json["create_fixed_fare"],
    readFixedFare: json["read_fixed_fare"],
    updateFixedFare: json["update_fixed_fare"],
    deleteFixedFare: json["delete_fixed_fare"],
    createFareByVehicle: json["create_fare_by_vehicle"],
    readFareByVehicle: json["read_fare_by_vehicle"],
    updateFareByVehicle: json["update_fare_by_vehicle"],
    deleteFareByVehicle: json["delete_fare_by_vehicle"],
    createFareConfigurationMileage: json["create_fare_configuration_mileage"],
    readFareConfigurationMileage: json["read_fare_configuration_mileage"],
    updateFareConfigurationMileage: json["update_fare_configuration_mileage"],
    deleteFareConfigurationMileage: json["delete_fare_configuration_mileage"],
    createLocationType: json["create_location_type"],
    readLocationType: json["read_location_type"],
    updateLocationType: json["update_location_type"],
    deleteLocationType: json["delete_location_type"],
    createLocation: json["create_location"],
    readLocation: json["read_location"],
    updateLocation: json["update_location"],
    deleteLocation: json["delete_location"],
    createLocalizationDetail: json["create_localization_detail"],
    readLocalizationDetail: json["read_localization_detail"],
    updateLocalizationDetail: json["update_localization_detail"],
    deleteLocalizationDetail: json["delete_localization_detail"],
    createMainData: json["create_main_data"],
    readMainData: json["read_main_data"],
    updateMainData: json["update_main_data"],
    deleteMainData: json["delete_main_data"],
    createDetailData: json["create_detail_data"],
    readDetailData: json["read_detail_data"],
    updateDetailData: json["update_detail_data"],
    deleteDetailData: json["delete_detail_data"],
    createZone: json["create_zone"],
    readZone: json["read_zone"],
    updateZone: json["update_zone"],
    deleteZone: json["delete_zone"],
    createJourneyType: json["create_journey_type"],
    readJourneyType: json["read_journey_type"],
    updateJourneyType: json["update_journey_type"],
    deleteJourneyType: json["delete_journey_type"],
    createPaymentType: json["create_payment_type"],
    readPaymentType: json["read_payment_type"],
    updatePaymentType: json["update_payment_type"],
    deletePaymentType: json["delete_payment_type"],
    createBooking: json["create_booking"],
    readBooking: json["read_booking"],
    updateBooking: json["update_booking"],
    deleteBooking: json["delete_booking"],
    createBookingRoute: json["create_booking_route"],
    readBookingRoute: json["read_booking_route"],
    updateBookingRoute: json["update_booking_route"],
    deleteBookingRoute: json["delete_booking_route"],
    createTrashBooking: json["create_trash_booking"],
    readTrashBooking: json["read_trash_booking"],
    updateTrashBooking: json["update_trash_booking"],
    deleteTrashBooking: json["delete_trash_booking"],
    createBookingAudit: json["create_booking_audit"],
    readBookingAudit: json["read_booking_audit"],
    updateBookingAudit: json["update_booking_audit"],
    deleteBookingAudit: json["delete_booking_audit"],
    createCustomerInvoice: json["create_customer_invoice"],
    readCustomerInvoice: json["read_customer_invoice"],
    updateCustomerInvoice: json["update_customer_invoice"],
    deleteCustomerInvoice: json["delete_customer_invoice"],
    createCustomerInvoiceLineitem: json["create_customer_invoice_lineitem"],
    readCustomerInvoiceLineitem: json["read_customer_invoice_lineitem"],
    updateCustomerInvoiceLineitem: json["update_customer_invoice_lineitem"],
    deleteCustomerInvoiceLineitem: json["delete_customer_invoice_lineitem"],
    createAccountInvoice: json["create_account_invoice"],
    readAccountInvoice: json["read_account_invoice"],
    updateAccountInvoice: json["update_account_invoice"],
    deleteAccountInvoice: json["delete_account_invoice"],
    createAccountInvoiceLineitem: json["create_account_invoice_lineitem"],
    readAccountInvoiceLineitem: json["read_account_invoice_lineitem"],
    updateAccountInvoiceLineitem: json["update_account_invoice_lineitem"],
    deleteAccountInvoiceLineitem: json["delete_account_invoice_lineitem"],
    role: json["role"] == null ? null : Role.fromJson(json["role"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "role_id": roleId,
    "create_user": createUser,
    "read_company_information": readCompanyInformation,
    "update_company_information": updateCompanyInformation,
    "read_company_configuration": readCompanyConfiguration,
    "update_company_configuration": updateCompanyConfiguration,
    "read_voip_settings": readVoipSettings,
    "create_template_type": createTemplateType,
    "read_template_types": readTemplateTypes,
    "read_template_type": readTemplateType,
    "update_template_type": updateTemplateType,
    "delete_template_type": deleteTemplateType,
    "create_template": createTemplate,
    "read_templates": readTemplates,
    "read_template": readTemplate,
    "update_template": updateTemplate,
    "delete_template": deleteTemplate,
    "create_sms_template": createSmsTemplate,
    "create_document_number": createDocumentNumber,
    "read_document_number": readDocumentNumber,
    "read_document_numbers": readDocumentNumbers,
    "update_document_number": updateDocumentNumber,
    "delete_document_number": deleteDocumentNumber,
    "create_feedback": createFeedback,
    "read_feedback": readFeedback,
    "read_feedbacks": readFeedbacks,
    "update_feedback": updateFeedback,
    "delete_feedback": deleteFeedback,
    "create_lost_property": createLostProperty,
    "read_lost_property": readLostProperty,
    "read_lost_properties": readLostProperties,
    "update_lost_property": updateLostProperty,
    "delete_lost_property": deleteLostProperty,
    "create_subsidiary": createSubsidiary,
    "read_subsidiaries": readSubsidiaries,
    "read_subsidiary": readSubsidiary,
    "update_subsidiary": updateSubsidiary,
    "delete_subsidiary": deleteSubsidiary,
    "read_role": readRole,
    "read_roles": readRoles,
    "update_role": updateRole,
    "create_employee": createEmployee,
    "read_employee": readEmployee,
    "read_employees": readEmployees,
    "update_employee": updateEmployee,
    "delete_employee": deleteEmployee,
    "create_vehicle_type": createVehicleType,
    "read_vehicle_types": readVehicleTypes,
    "read_vehicle_type": readVehicleType,
    "update_vehicle_type": updateVehicleType,
    "delete_vehicle_type": deleteVehicleType,
    "create_company_vehicle": createCompanyVehicle,
    "read_company_vehicles": readCompanyVehicles,
    "read_company_vehicle": readCompanyVehicle,
    "update_company_vehicle": updateCompanyVehicle,
    "delete_company_vehicle": deleteCompanyVehicle,
    "create_vehicle": createVehicle,
    "read_vehicles": readVehicles,
    "read_vehicle": readVehicle,
    "update_vehicle": updateVehicle,
    "delete_vehicle": deleteVehicle,
    "create_end_vehicle": createEndVehicle,
    "create_customer": createCustomer,
    "read_customers": readCustomers,
    "read_customer": readCustomer,
    "update_customer": updateCustomer,
    "delete_customer": deleteCustomer,
    "create_complaint": createComplaint,
    "read_complaint": readComplaint,
    "read_complaints": readComplaints,
    "update_complaint": updateComplaint,
    "delete_complaint": deleteComplaint,
    "create_driver": createDriver,
    "read_drivers": readDrivers,
    "read_driver": readDriver,
    "update_driver": updateDriver,
    "update_driver_zone": updateDriverZone,
    "delete_driver": deleteDriver,
    "create_end_driver": createEndDriver,
    "create_driver_shift": createDriverShift,
    "read_driver_shift": readDriverShift,
    "read_driver_shifts": readDriverShifts,
    "update_driver_shift": updateDriverShift,
    "delete_driver_shift": deleteDriverShift,
    "create_driver_availability": createDriverAvailability,
    "read_driver_availability": readDriverAvailability,
    "read_driver_availabilities": readDriverAvailabilities,
    "update_driver_availability": updateDriverAvailability,
    "delete_driver_availability": deleteDriverAvailability,
    "create_driver_booking": createDriverBooking,
    "read_driver_booking": readDriverBooking,
    "read_driver_bookings": readDriverBookings,
    "update_driver_booking": updateDriverBooking,
    "delete_driver_booking": deleteDriverBooking,
    "create_driver_commission": createDriverCommission,
    "read_driver_commission": readDriverCommission,
    "read_driver_commissions": readDriverCommissions,
    "update_driver_commission": updateDriverCommission,
    "delete_driver_commission": deleteDriverCommission,
    "create_driver_commission_account": createDriverCommissionAccount,
    "read_driver_commission_account": readDriverCommissionAccount,
    "read_driver_commission_accounts": readDriverCommissionAccounts,
    "update_driver_commission_account": updateDriverCommissionAccount,
    "delete_driver_commission_account": deleteDriverCommissionAccount,
    "create_driver_commission_lineitem": createDriverCommissionLineitem,
    "read_driver_commission_lineitem": readDriverCommissionLineitem,
    "read_driver_commission_lineitems": readDriverCommissionLineitems,
    "update_driver_commission_lineitem": updateDriverCommissionLineitem,
    "delete_driver_commission_lineitem": deleteDriverCommissionLineitem,
    "create_driver_shift_history": createDriverShiftHistory,
    "read_driver_shift_history": readDriverShiftHistory,
    "read_driver_shift_histories": readDriverShiftHistories,
    "update_driver_shift_history": updateDriverShiftHistory,
    "delete_driver_shift_history": deleteDriverShiftHistory,
    "create_account": createAccount,
    "read_accounts": readAccounts,
    "read_account": readAccount,
    "update_account": updateAccount,
    "delete_account": deleteAccount,
    "create_message": createMessage,
    "read_message": readMessage,
    "read_messages": readMessages,
    "update_message": updateMessage,
    "delete_message": deleteMessage,
    "create_notification": createNotification,
    "read_notification": readNotification,
    "read_notifications": readNotifications,
    "update_notification": updateNotification,
    "delete_notification": deleteNotification,
    "create_audit": createAudit,
    "read_audit": readAudit,
    "read_audits": readAudits,
    "update_audit": updateAudit,
    "delete_audit": deleteAudit,
    "read_app_feature": readAppFeature,
    "read_app_features": readAppFeatures,
    "update_app_feature": updateAppFeature,
    "create_escort": createEscort,
    "update_escort": updateEscort,
    "delete_escort": deleteEscort,
    "read_escort": readEscort,
    "read_escorts": readEscorts,
    "update_app_version": updateAppVersion,
    "create_employee_shift_history": createEmployeeShiftHistory,
    "read_employee_shift_history": readEmployeeShiftHistory,
    "update_employee_shift_history": updateEmployeeShiftHistory,
    "create_account_web_login": createAccountWebLogin,
    "read_account_web_login": readAccountWebLogin,
    "update_account_web_login": updateAccountWebLogin,
    "delete_account_web_login": deleteAccountWebLogin,
    "create_account_order_number": createAccountOrderNumber,
    "read_account_order_number": readAccountOrderNumber,
    "update_account_order_number": updateAccountOrderNumber,
    "delete_account_order_number": deleteAccountOrderNumber,
    "create_account_department": createAccountDepartment,
    "read_account_department": readAccountDepartment,
    "update_account_department": updateAccountDepartment,
    "delete_account_department": deleteAccountDepartment,
    "create_account_contact": createAccountContact,
    "read_account_contact": readAccountContact,
    "update_account_contact": updateAccountContact,
    "delete_account_contact": deleteAccountContact,
    "create_account_company_address": createAccountCompanyAddress,
    "read_account_company_address": readAccountCompanyAddress,
    "update_account_company_address": updateAccountCompanyAddress,
    "delete_account_company_address": deleteAccountCompanyAddress,
    "create_fare_configuration": createFareConfiguration,
    "read_fare_configuration": readFareConfiguration,
    "update_fare_configuration": updateFareConfiguration,
    "delete_fare_configuration": deleteFareConfiguration,
    "create_fixed_fare": createFixedFare,
    "read_fixed_fare": readFixedFare,
    "update_fixed_fare": updateFixedFare,
    "delete_fixed_fare": deleteFixedFare,
    "create_fare_by_vehicle": createFareByVehicle,
    "read_fare_by_vehicle": readFareByVehicle,
    "update_fare_by_vehicle": updateFareByVehicle,
    "delete_fare_by_vehicle": deleteFareByVehicle,
    "create_fare_configuration_mileage": createFareConfigurationMileage,
    "read_fare_configuration_mileage": readFareConfigurationMileage,
    "update_fare_configuration_mileage": updateFareConfigurationMileage,
    "delete_fare_configuration_mileage": deleteFareConfigurationMileage,
    "create_location_type": createLocationType,
    "read_location_type": readLocationType,
    "update_location_type": updateLocationType,
    "delete_location_type": deleteLocationType,
    "create_location": createLocation,
    "read_location": readLocation,
    "update_location": updateLocation,
    "delete_location": deleteLocation,
    "create_localization_detail": createLocalizationDetail,
    "read_localization_detail": readLocalizationDetail,
    "update_localization_detail": updateLocalizationDetail,
    "delete_localization_detail": deleteLocalizationDetail,
    "create_main_data": createMainData,
    "read_main_data": readMainData,
    "update_main_data": updateMainData,
    "delete_main_data": deleteMainData,
    "create_detail_data": createDetailData,
    "read_detail_data": readDetailData,
    "update_detail_data": updateDetailData,
    "delete_detail_data": deleteDetailData,
    "create_zone": createZone,
    "read_zone": readZone,
    "update_zone": updateZone,
    "delete_zone": deleteZone,
    "create_journey_type": createJourneyType,
    "read_journey_type": readJourneyType,
    "update_journey_type": updateJourneyType,
    "delete_journey_type": deleteJourneyType,
    "create_payment_type": createPaymentType,
    "read_payment_type": readPaymentType,
    "update_payment_type": updatePaymentType,
    "delete_payment_type": deletePaymentType,
    "create_booking": createBooking,
    "read_booking": readBooking,
    "update_booking": updateBooking,
    "delete_booking": deleteBooking,
    "create_booking_route": createBookingRoute,
    "read_booking_route": readBookingRoute,
    "update_booking_route": updateBookingRoute,
    "delete_booking_route": deleteBookingRoute,
    "create_trash_booking": createTrashBooking,
    "read_trash_booking": readTrashBooking,
    "update_trash_booking": updateTrashBooking,
    "delete_trash_booking": deleteTrashBooking,
    "create_booking_audit": createBookingAudit,
    "read_booking_audit": readBookingAudit,
    "update_booking_audit": updateBookingAudit,
    "delete_booking_audit": deleteBookingAudit,
    "create_customer_invoice": createCustomerInvoice,
    "read_customer_invoice": readCustomerInvoice,
    "update_customer_invoice": updateCustomerInvoice,
    "delete_customer_invoice": deleteCustomerInvoice,
    "create_customer_invoice_lineitem": createCustomerInvoiceLineitem,
    "read_customer_invoice_lineitem": readCustomerInvoiceLineitem,
    "update_customer_invoice_lineitem": updateCustomerInvoiceLineitem,
    "delete_customer_invoice_lineitem": deleteCustomerInvoiceLineitem,
    "create_account_invoice": createAccountInvoice,
    "read_account_invoice": readAccountInvoice,
    "update_account_invoice": updateAccountInvoice,
    "delete_account_invoice": deleteAccountInvoice,
    "create_account_invoice_lineitem": createAccountInvoiceLineitem,
    "read_account_invoice_lineitem": readAccountInvoiceLineitem,
    "update_account_invoice_lineitem": updateAccountInvoiceLineitem,
    "delete_account_invoice_lineitem": deleteAccountInvoiceLineitem,
    "role": role?.toJson(),
  };
}

class Role {
  int? id;
  String? name;

  Role({
    this.id,
    this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
