import 'package:flutter/cupertino.dart';

import '../constants.dart';
import 'constants.dart';
import 'models/memo_list_view.dart';
import 'package:admin/models/memo_list_approver_model.dart' as MemoListApprover;
import 'models/memo_type_model.dart';

class ApiCalls {

  Uri approveMemo(){
    return Uri.parse('$urlProd/approve_memo/');//?approver=$approver&ref_num=${Uri.encodeComponent(refNum)}&next_approver=$nextApprover&memo_id=${memoListItem.id}');
  }

  Uri approverList(String type) {
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/approver_list/?type=$type');
  }

  Uri checkRefNum(){
    return Uri.parse('$urlProd/check_memo_ref/');
  }

  Uri createNewMemo(){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/create_new_memo/');
  }

  Uri dashboard() {
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/dashboard');
  }

  Uri deleteFile(String filename){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/delete?file_name=$filename');
  }

  ///Token Authorization is not implemented
  Uri downloadFile(String filename) {
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/download?file_name=$filename');
  }

  Uri getUserData(){
    return Uri.parse(/*"http://10.200.120.59:5000*/'$urlProd/get_user_data');
  }

  Uri getUserList(){
    return Uri.parse('$urlProd/get_user_list');
  }

  Uri getUserTypeList(){
    return Uri.parse('$urlProd/get_user_type_list');
  }

  Uri insertFinImp(){
    return Uri.parse('$urlProd/insert_financial_imp');
  }

  Uri insertFinImpSSP(){
    return Uri.parse('$urlProd/insert_financial_imp_ssp');
  }

  Uri insertInvoiceReceivedSSP(){
    return Uri.parse('$urlProd/insert_invoice_received_ssp');
  }

  Uri memoType(){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/memo_type/');
  }

  ///Token Authorization is not implemented
  Uri openPdf(String id){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/get_pdf?memo_id=$id');
  }

  ///Token Authorization is not implemented
  Uri openPdfSSP(String memo_ref){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/get_pdf_ssp?memo_ref=$memo_ref');
  }

  Uri paymentType(){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/payment_type/');
  }

  Uri registerUser(){
    return Uri.parse('$urlProd/register_user');
  }

  Uri resetPassword(){
    return Uri.parse(/*"http://10.200.120.59:5000*/'$urlProd/reset_password');
  }

  Uri sendMail(String email){
    return Uri.parse('$urlProd/sendMail?email=$email');
  }

  Uri sendMailCompleteApproval(String memoRef){
    return Uri.parse('$urlProd/sendMail_completeApproval?memo_ref=$memoRef');
  }

  Uri saveDraftMemo(){
    return Uri.parse('$urlProd/save_memo_draft/');
  }

  Uri sendMailById(String userId){
    return Uri.parse('$urlProd/sendMail?userId=$userId');
  }

  Uri sendMailRegisteredUser(String email){
    return Uri.parse('$urlProd/sendMail_registerUser?email=$email');
  }

  Uri sendMailResetPass(String email){
    return Uri.parse('$urlProd/sendMail_resetPass?email=$email');
  }

  ///Token Authorization is not implemented
  Uri upload(){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/upload');
  }

  Uri updateMemoStatus(){
    return Uri.parse('$urlProd/update_memo_status');
  }

  Uri updateMemoDetails(){
    return Uri.parse('$urlProd/update_memo_details');
  }

  Uri updateFinImpSSP(){
    return Uri.parse('$urlProd/update_fin_imp_ssp_details');
  }

  Uri updateInvReceivedSSP(){
    return Uri.parse('$urlProd/update_inv_received_ssp_details');
  }

  Uri userDesignation(){
    return Uri.parse('$urlProd/get_designation_name_list');
  }

  Uri verifyUser(){
    return Uri.parse(/*"http://10.200.120.59:5000*/'$urlProd/verify_user');
  }

  Uri viewFinancialImplicationSSP(String memoRef){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_financial_imp_ssp?memo_ref=$memoRef');
  }

  Uri viewInvoiceReceivedSSP(String memoRef){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_invoice_received_ssp?memo_ref=$memoRef');
  }

  Uri viewMemoListApproved(int userId){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_memo_list_approved/?approver_id=$userId');
  }

  Uri viewMemoListApprover(int userId){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_memo_list_approver/?approver_id=$userId');
  }

  Uri viewFinanceReviewList(){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_finance_review_list/');
  }

  Uri viewMemoList(){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_memo_list/');
  }

  Uri viewUserMemoList(int userId){
    return Uri.parse(/*'http://10.200.120.59:5000*/'$urlProd/view_user_memo_list/?userId=$userId');
  }

}