import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';

import '../../../../constant/snackbar.dart';
import '../../../../core/widgets/loader_dialog.dart';
import '../../domain/usecases/states.dart';
import '../controller/auth_controller.dart';
import '../provider/auth_provider.dart';
import '../widgets/auth_footer.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_password_field.dart';
import '../widgets/custom_phone_field.dart';
import '../widgets/custom_text_form_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  File? _pickedImage;
  bool _isPickingImage = false;

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
        _isPickingImage = false;
      });
    } else {
      setState(() => _isPickingImage = false);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _phoneNumber = PhoneNumber(
      countryISOCode: 'NG',
      countryCode: '+234',
      number: '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _lastnameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  late PhoneNumber _phoneNumber;

  void _register(AuthController authcontroller) async {
    if (_formKey.currentState!.validate()) {
      if (_pickedImage == null) {
        SnackBarService.notifyAction(
          context,
          message: 'Please select an image',
          status: SnackbarStatus.fail,
        );
        return;
      }
      try {
        if (authcontroller.registerResult.state ==
            RegisterResultStates.isLoading) {
          return;
        }

        LoaderDialog.show(context, message: 'Creating your account...');
        await authcontroller.registerWithProfileImage(
          email: _emailController.text,
          address: _addressController.text,
          password: _passwordController.text,
          firstname: _nameController.text,
          lastname: _lastnameController.text,
          phoneNumber: _phoneNumber.completeNumber,
          profileImage: _pickedImage,
        );
        LoaderDialog.hide(context);
        if (authcontroller.registerResult.state ==
            RegisterResultStates.isData) {
          SnackBarService.showSnackBar(
            context,
            title: 'Success',
            status: SnackbarStatus.success,
            body: authcontroller.registerResult.message ?? '',
          );
          ref
              .read(authProvider)
              .sendemailVerification(email: _emailController.text);
          context.push('/verify-email', extra: _emailController.text);
        }
        if (authcontroller.registerResult.state ==
            RegisterResultStates.isError) {
          SnackBarService.showSnackBar(
            context,
            title: 'Error',
            status: SnackbarStatus.fail,
            body: authcontroller.registerResult.message ?? '',
          );
        }
      } catch (e) {
        LoaderDialog.hide(context);
        SnackBarService.showSnackBar(
          context,
          title: 'Error',
          status: SnackbarStatus.fail,
          body: e.toString(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authcontroller = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image picker avatar
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundImage: _pickedImage != null
                            ? FileImage(_pickedImage!)
                            : null,
                        backgroundColor: Colors.grey[200],
                        child: _pickedImage == null && !_isPickingImage
                            ? const Icon(
                                Icons.person,
                                size: 48,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      if (_isPickingImage)
                        Positioned.fill(
                          child: Center(
                            child: SizedBox(
                              width: 32,
                              height: 32,
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                CustomTextFormField(
                  controller: _nameController,
                  labelText: 'First Name',
                  hintText: 'Enter your first name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  controller: _lastnameController,
                  labelText: 'Last Name',
                  hintText: 'Enter your last name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  controller: _emailController,
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  controller: _addressController,
                  labelText: 'Address',
                  hintText: 'Enter your address',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomPhoneField(
                  controller: _phoneNumberController,
                  initialCountryCode: 'NG',
                  onChanged: (phone) => _phoneNumber = phone,
                ),
                const SizedBox(height: 24),
                CustomPasswordField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  isVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                const SizedBox(height: 32),
                CustomElevatedButton(
                  onPressed: () => _register(authcontroller),
                  text: 'Sign Up',
                ),
                const SizedBox(height: 24),
                const AuthFooter(
                  text: 'Already have an account?',
                  buttonText: 'Sign In',
                  onPressed: null, // Will be handled by Navigator.pop(context)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
