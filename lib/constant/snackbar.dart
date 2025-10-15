import 'package:flutter/material.dart';

import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../core/utils/appColor.dart';

class SnackBarService {
  static void notifyAction(
    BuildContext context, {
    required String message,
    SnackbarStatus status = SnackbarStatus.success,
    int timeInSec = 1,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      Center(
        child: AnimatedContainer(
          // margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
          // width: 94,
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: status == SnackbarStatus.success
                ? AppColors.ksuccessColor300
                : status == SnackbarStatus.info
                ? AppColors.kprimaryColor500
                : AppColors.kErrorColor300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          duration: Durations.long3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                message,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      displayDuration: Duration(seconds: timeInSec),
      dismissType: DismissType.onTap,
    );
  }

  /// show a snackbar
  static void showSnackBar(
    BuildContext context, {
    required String title,
    required String body,
    SnackbarStatus status = SnackbarStatus.success,
    int timeInSec = 4,
  }) {
    showTopSnackBar(
      Overlay.of(context),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 4,
              color: AppColors.kBlack.withOpacity(0.2),
              spreadRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          border: Border.all(
            color: status == SnackbarStatus.success
                ? AppColors.ksuccessColor300
                : status == SnackbarStatus.info
                ? AppColors
                      .kprimaryColor500 //I think this should be a shade of blue but na designer job
                : AppColors.kErrorColor300,
          ),
          borderRadius: BorderRadius.circular(8),
          color: status == SnackbarStatus.success
              ? AppColors.ksuccessColor300
              : status == SnackbarStatus.info
              ? AppColors
                    .kprimaryColor500 //still think this should be blue
              : AppColors.kErrorColor300,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: status == SnackbarStatus.success
                          ? AppColors.kWhite
                          : status == SnackbarStatus.info
                          ? AppColors
                                .kWhite //still think this should be blue sha
                          : AppColors.kWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    body,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: AppColors.kWhite),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // IconButton(
            //     onPressed: () {
            //     },
            //     icon:
            const Icon(Icons.cancel_outlined, color: AppColors.kWhite),
            // )
          ],
        ),
      ),
      // persistent: true,
      displayDuration: const Duration(seconds: 2),
      dismissType: DismissType.onTap,
    );
  }
}

enum SnackbarStatus { success, fail, warning, info }
