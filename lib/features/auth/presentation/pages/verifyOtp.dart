import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../constant/Inkbutton.dart';
import '../../../../constant/snackbar.dart';
import '../../../../core/utils/appColor.dart' show AppColors;
import '../../../../features/auth/presentation/provider/auth_provider.dart';
import 'package:gap/gap.dart';

import '../../domain/usecases/states.dart';

class VerifyEmailPage extends ConsumerStatefulWidget {
  String email;
  VerifyEmailPage({Key? key, required this.email}) : super(key: key);

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  final TextEditingController _otpController = TextEditingController();
  final StreamController<ErrorAnimationType> _errorController =
      StreamController<ErrorAnimationType>.broadcast();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Timer _timer;
  int _remainingSeconds = 60;
  String _currentOtp = "";
  SendEmailVerificationResultState? _lastShownState;

  @override
  void initState() {
    super.initState();
    _startCountdown();

    // Check initial state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final result = ref.read(authProvider).sendEmailVerificationResult;
      if (_lastShownState != result.state) {
        _showSnackBarIfNeeded(result);
      }
    });
  }

  void _showSnackBarIfNeeded(SendEmailVerificationResult result) {
    if (result.state == _lastShownState) return;
    _lastShownState = result.state;

    final responseMsg =
        result.response['message'] as String? ?? 'Unknown error';

    if (result.state == SendEmailVerificationResultState.isError) {
      SnackBarService.showSnackBar(
        context,
        title: 'Error',
        body: responseMsg,
        status: SnackbarStatus.fail,
      );
    } else if (result.state == SendEmailVerificationResultState.isData) {
      SnackBarService.showSnackBar(
        context,
        title: 'Success',
        body: responseMsg,
        status: SnackbarStatus.success,
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpController.dispose();
    _errorController.close();
    super.dispose();
  }

  void _startCountdown() {
    _remainingSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  Future<void> _resendCode() async {
    print('resendCode');
    setState(() {
      _remainingSeconds = 60;
    });
    _startCountdown();

    await ref.read(authProvider).sendemailVerification(email: widget.email);
    final sendotpState = ref
        .read(authProvider)
        .sendEmailVerificationResult
        .state;

    final responseMsg =
        ref.read(authProvider).sendEmailVerificationResult.response['message']
            as String? ??
        'Unknown error';
    if (sendotpState == SendEmailVerificationResultState.isError) {
      SnackBarService.showSnackBar(
        context,
        title: 'Error',
        body: responseMsg,
        status: SnackbarStatus.fail,
      );
    } else {
      SnackBarService.showSnackBar(
        context,
        title: 'Success',
        body: responseMsg,
        status: SnackbarStatus.success,
      );
    }
  }

  Future<void> _verifyAndContinue() async {
    if (_currentOtp.length != 6) {
      SnackBarService.showSnackBar(
        context,
        title: 'Error',
        body: 'OTP must be 6 digits.',
        status: SnackbarStatus.fail,
      );
      return;
    }

    final verifyState = ref.read(authProvider).verifyEmailResult.state;
    if (verifyState == EmailVerificationResultState.isLoading) {
      return;
    }

    SmartDialog.showLoading();
    await ref
        .read(authProvider)
        .verifyEmail(email: widget.email, otp: _currentOtp);
    SmartDialog.dismiss();

    final resultState = ref.read(authProvider).verifyEmailResult.state;
    final responseMsg =
        ref.read(authProvider).verifyEmailResult.response['message']
            as String? ??
        'Unknown error';

    if (resultState == EmailVerificationResultState.isError) {
      SnackBarService.showSnackBar(
        context,
        title: 'Error',
        body: responseMsg,
        status: SnackbarStatus.fail,
      );
    } else {
      SnackBarService.showSnackBar(
        context,
        title: 'Success',
        body: responseMsg,
        status: SnackbarStatus.success,
      );

      // Navigate to profile completion and remove this page from history
      context.go('/profile-complete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        leading: InkWell(
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.chevron_left, size: 28),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final sendOtpState = ref
                .watch(authProvider)
                .sendEmailVerificationResult;

            if (_lastShownState != sendOtpState.state) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showSnackBarIfNeeded(sendOtpState);
              });
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (sendOtpState.state ==
                      SendEmailVerificationResultState.isLoading)
                    const LinearProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.kprimaryColor500,
                      ),
                    ),
                  const Gap(20),
                  const Text(
                    'Verify Your Email',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),
                  const Gap(20),
                  const Text(
                    'We\'ve sent an OTP to your email address.\nPlease check your inbox.',
                    style: TextStyle(fontSize: 13),
                  ),
                  const Gap(30),
                  const Text(
                    'Enter the 4 digit code',
                    style: TextStyle(fontSize: 13),
                  ),
                  const Gap(5),
                  Form(
                    key: _formKey,
                    child: PinCodeTextField(
                      appContext: context,
                      length: 6,
                      animationType: AnimationType.fade,
                      blinkWhenObscuring: true,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      controller: _otpController,
                      errorAnimationController: _errorController,
                      keyboardType: TextInputType.number,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(10),
                        fieldHeight: 54,
                        fieldWidth: 45,
                        activeColor: const Color(0xffEBF1FF),
                        inactiveColor: const Color(0xffEBF1FF),
                        selectedColor: const Color(0xffEBF1FF),
                        inactiveFillColor: const Color(0xffEBF1FF),
                        selectedFillColor: const Color(0xffEBF1FF),
                        activeFillColor: const Color(0xffEBF1FF),
                      ),
                      cursorColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          _currentOtp = value;
                        });
                      },
                      onCompleted: (value) {
                        _currentOtp = value;
                      },
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Please enter 6 digits';
                        }
                        return null;
                      },
                      beforeTextPaste: (text) => true,
                    ),
                  ),
                  const Gap(40),
                  const Center(
                    child: Text(
                      'Didn\'t receive the email?',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  const Gap(10),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Resend Code?',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppColors.kprimaryColor500,
                          ),
                        ),
                        const Gap(10),
                        _remainingSeconds == 0
                            ? InkWell(
                                onTap: _resendCode,
                                child: const Text(
                                  'Send',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.kprimaryColor500,
                                  ),
                                ),
                              )
                            : Text(
                                '(${_formatTime(_remainingSeconds)})',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.kprimaryColor500,
                                ),
                              ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: InkWell(
                      onTap: _verifyAndContinue,
                      child: InkButton(title: 'Verify and continue'),
                    ),
                  ),
                  const Gap(20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(1, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
