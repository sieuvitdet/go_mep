import 'package:go_mep_application/common/theme/globals/globals.dart';
import 'package:go_mep_application/data/model/req/geocoding_req_model.dart';

class API {
  static String? get server => Globals.config.server;
  static String get successCode => "success";
  static String get fail => "fail";
  static bool get success => true;
  static String get gateway => "/api";
  static String get apiVersion => "api-version=1.0";

  static login() => "$gateway/auth/login?$apiVersion";
  static refreshToken() => "$gateway/auth/refresh-token?$apiVersion";
  static changePassword() => "$gateway/auth/change-password?$apiVersion";
  static requestResetPassword() =>
      "$gateway/auth/request-reset-password?$apiVersion";
  static logout() => "$gateway/auth/logout?$apiVersion";
  static accountCheck() => "$gateway/auth/account-check?$apiVersion";
  static resetPassword() => "$gateway/auth/reset-password?$apiVersion";
  static resetTokenInfo() => "$gateway/auth/reset-token-info?$apiVersion";
  static userMe() => "$gateway/users/me?$apiVersion";
  static notifications({required int pageNumber, required int pageSize}) =>
      "$gateway/notifications?pageNumber=$pageNumber&pageSize=$pageSize&$apiVersion";
  static vehicleIncidentReports() =>
      "$gateway/vehicle-incident-reports?$apiVersion";
  static vehicleIncidentReportsGroups() =>
      "$gateway/vehicle-incident-reports/groups?$apiVersion";
  static vehicleIncidentReportDetail(String id) =>
      "$gateway/vehicle-incident-reports/$id?$apiVersion";
  static deleteVehicleIncidentReport(String id) =>
      "$gateway/vehicle-incident-reports/$id?$apiVersion";
  static purchaseOrders() => "$gateway/purchase-orders?$apiVersion";
  static purchaseOrderDetail(String id) =>
      "$gateway/purchase-orders/$id?$apiVersion";
  static purchaseOrderListItemWithID(String orderId) =>
      "$gateway/purchase-orders/$orderId/items?$apiVersion";
  static purchaseOrderItemDetail(String orderId, String itemId) =>
      "$gateway/purchase-orders/$orderId/items/$itemId?$apiVersion";
  static repairCarRequests() => "$gateway/repair-requests?$apiVersion";
  static repairCarRequestDetail(String id) =>
      "$gateway/repair-requests/$id?$apiVersion";
  static getRepairRequestItems(
          {String? repairRequestId,
          String? mountAction,
          bool? isTechnicalService,
          required int pageNumber,
          required int pageSize}) =>
      "$gateway/repair-requests/$repairRequestId/items?${mountAction != null ? "mountAction=$mountAction" : ""}${isTechnicalService != null ? "&isTechnicalService=$isTechnicalService" : ""}&pageNumber=$pageNumber&pageSize=$pageSize&$apiVersion";
  static repairRequestItemSerialNumber(
          String repairRequestId, String aggregateItemId,
          {required int pageNumber, required int pageSize}) =>
      "$gateway/repair-requests/$repairRequestId/items/$aggregateItemId/serial-numbers?pageNumber=$pageNumber&pageSize=$pageSize&$apiVersion";
  static getAssignedEmployee() => "$gateway/employees?$apiVersion";
  static getManufacturers() => "$gateway/manufacturers/lookup?$apiVersion";
  static geocodingReverse(GeocodingReqModel model) =>
      "$gateway/geocodes/reverse?lat=${model.lat}&lng=${model.lng}&$apiVersion";
  static createVehicleIncidentReport() =>
      "$gateway/vehicle-incident-reports/create?$apiVersion";
  static bulkUploadAttachments({int expiryInSeconds = 3600}) =>
      "$gateway/document-attachments/bulk?expiryInSeconds=$expiryInSeconds&$apiVersion";
  static vehicleAssemblySystems() =>
      "$gateway/vehicle-assembly-systems?$apiVersion";
  static changeVehicleIncidentReportStatus() =>
      "$gateway/vehicle-incident-reports/change-status?$apiVersion";
  static updateVehicleIncidentReport(String reportId) =>
      "$gateway/vehicle-incident-reports/request/$reportId/re-create?$apiVersion";
  static actionLogs(String referenceId,
          {required int pageNumber, required int pageSize}) =>
      "$gateway/action-logs/$referenceId?pageNumber=$pageNumber&pageSize=$pageSize&$apiVersion";
  static vehicleDetail(String vehicleId) =>
      "$gateway/vehicles/$vehicleId?$apiVersion";
  static requestApproval(String requestId) =>
      "$gateway/requests/$requestId/approval?$apiVersion";
  static purchaseOrderVerify(String orderId) =>
      "$gateway/purchase-orders/$orderId/verify?$apiVersion";
  static testEncrypt() => "$gateway/test/encrypt?$apiVersion";
}
