import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../general/config/colors.dart';
import '../../../../general/utils/blank_space.dart';
import '../../../../general/utils/responsive.dart';
import '../../../../providers/blood_request_provider.dart';
import '../../home/widgets/request_feed_item.dart';
import '../../components/widgets/custom_appbar.dart';
import '../widgets/custom_call_btn.dart';
import '../widgets/request_details_item.dart';

class RequestDetailsScreen extends StatelessWidget {
  static const pageRoute = "/request-details-screen";
  const RequestDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(titlee: "Details", actionTrue: true),
      body: Consumer<BloodRequestProvider>(
        // Los botones no dependen de la solicitud: se crean una vez y se reusan.
        child: Column(
          children: [
            verticalSpace(twentyPixelHeight(context)),
            const CustomCallButton(
              textt: "Call",
              textColor: AppColor.whiteColor,
              fillColor: AppColor.redColor,
              borderClr: Colors.transparent,
            ),
            verticalSpace(twentyPixelHeight(context) * .5),
            const CustomCallButton(
              textt: "Message",
              textColor: AppColor.redColor,
              fillColor: AppColor.whiteColor,
            ),
          ],
        ),
        builder: (context, provider, buttons) {
          final request = provider.selectedRequest;
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: twentyPixelWidth(context),
                right: twentyPixelWidth(context),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  verticalSpace(twentyPixelHeight(context) * 1.5),
                  RequestDetailsItem(
                    titlee: "Blood want before",
                    textt: request == null
                        ? "-"
                        : formatDate(request.neededBefore),
                  ),
                  RequestDetailsItem(
                    titlee: "Patient Name",
                    textt: request?.patientName ?? "-",
                  ),

                  RequestDetailsItem(
                    titlee: "Location ",
                    textt: request?.location ?? "-",
                  ),

                  RequestDetailsItem(
                    titlee: "Blood Group",
                    textt: request?.bloodGroup ?? "-",
                  ),

                  RequestDetailsItem(
                    titlee: "Contact Number",
                    textt: request?.contactNumber ?? "-",
                  ),

                  RequestDetailsItem(
                    titlee: "Cause",
                    textt: request?.cause ?? "-",
                  ),

                  RequestDetailsItem(
                    titlee: "Number of Bags",
                    textt: request == null ? "-" : "${request.bags} Bags",
                  ),

                  RequestDetailsItem(
                    titlee: "Others",
                    textt: request?.notes ?? "-",
                  ),

                  buttons!,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
