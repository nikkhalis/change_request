import 'package:admin/constants.dart';

String sspMemoTitleGen(String pbt, String parkingType) {
  if (pbt == 'SEMSB'){
    return 'PAYMENT APPROVAL TO SUASA EFEKTIF (M) SDN BHD (SEMSB) FOR THE PURCHASE OF PARKING CREDIT (MINUTES) FOR SMART SELANGOR PARKING (SSP) IN ALL STREET PARKING AREA UNDER SEMSB CONCESSIONAIRE';
  } else
    if (parkingType == 'On Street Parking'){
      return 'PAYMENT APPROVAL TO ${getPbtFullName(pbt).toUpperCase()} ($pbt) FOR THE PURCHASE OF PARKING CREDIT (MINUTES) FOR SMART SELANGOR PARKING ("SSP") IMPLEMENTATION IN ON STREET PARKING AREA UNDER $pbt';
    } else if (parkingType == 'Off Street Parking'){
      return 'PAYMENT APPROVAL TO ${getPbtFullName(pbt).toUpperCase()} ($pbt) FOR THE PURCHASE OF PARKING CREDIT (MINUTES) FOR SMART SELANGOR PARKING ("SSP") IMPLEMENTATION IN OFF STREET PARKING AREA UNDER $pbt';
    } else if (parkingType == 'Parking Compound') {
      return 'PAYMENT APPROVAL TO ${getPbtFullName(pbt).toUpperCase()} ($pbt) FOR THE PURCHASE OF ${parkingType.toUpperCase()} CREDIT (MINUTES) FOR SMART SELANGOR PARKING ("SSP") IMPLEMENTATION IN ON STREET PARKING AREA UNDER $pbt';
    } else {
      return '';
    }
}

getPbtFullName(String pbt) {
}