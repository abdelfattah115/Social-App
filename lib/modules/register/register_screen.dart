import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_layout.dart';
import 'cubit/register_cubit.dart';
import '../../shared/components/components.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is UserCreateSuccessStates) {
            navigateAndFinish(context, SocialScreen());
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Text(
                      'Register',
                      style:
                      Theme
                          .of(context)
                          .textTheme
                          .headline3!
                          .copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Register now to communicate with friends',
                      style:
                      Theme
                          .of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    defaultTextFormField(
                      controller: nameController,
                      type: TextInputType.emailAddress,
                      label: 'Name',
                      prefix: Icons.person,
                      validate: (String? val) {
                        if (val!.isEmpty) {
                          return 'Enter your Name';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    defaultTextFormField(
                      controller: emailController,
                      type: TextInputType.emailAddress,
                      label: 'Email Address',
                      prefix: Icons.email_outlined,
                      validate: (String? val) {
                        if (val!.isEmpty) {
                          return 'Enter your email';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    defaultTextFormField(
                      controller: passwordController,
                      type: TextInputType.visiblePassword,
                      label: 'Password',
                      prefix: Icons.lock_outline,
                      suffix: RegisterCubit
                          .get(context)
                          .suffix,
                      validate: (String? val) {
                        if (val!.isEmpty) {
                          return 'Please enter password';
                        }
                      },
                      isPassword: RegisterCubit
                          .get(context)
                          .isPassword,
                      onTap: () {

                      },
                      suffixPressed: () {
                        RegisterCubit.get(context)
                            .changePasswordVisibility();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    defaultTextFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      label: 'Phone',
                      prefix: Icons.phone,
                      validate: (String? val) {
                        if (val!.isEmpty) {
                          return 'Enter your Phone';
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ConditionalBuilder(
                      condition: state is! RegisterLoadingStates,
                      builder: (context) => defaultButton(
                          onPressed: () {
                            RegisterCubit.get(context).userRegister(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                phone: phoneController.text);
                          },
                          text: 'Register'),
                      fallback: (context) => const Center(child: CircularProgressIndicator())),
                    ],
                  ),
                ),
              ),
            ),
          ),);
        },
      ),
    );
  }
}
