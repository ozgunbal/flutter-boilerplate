import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FormPage extends StatelessWidget {
  const FormPage({super.key});

  FormGroup buildForm() => fb.group(<String, Object>{
        'name': FormControl<String>(
          value: '',
          validators: [
            Validators.required,
            Validators.minLength(2),
            Validators.maxLength(50),
          ],
        ),
        'email': FormControl<String>(
          value: '',
          validators: [
            Validators.required,
            Validators.email,
          ],
        ),
        'age': FormControl<int>(
          value: null,
          validators: [
            Validators.required,
            Validators.min(18),
            Validators.max(100),
          ],
        ),
        'terms': FormControl<bool>(
          value: false,
          validators: [
            Validators.requiredTrue,
          ],
        ),
        'country': FormControl<String>(
          value: null,
          validators: [
            Validators.required,
          ],
        ),
        'gender': FormControl<String>(
          value: null,
          validators: [
            Validators.required,
          ],
        ),
      });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
      form: buildForm,
      builder: (context, form, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('form.title'.tr()),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ReactiveTextField<String>(
                  formControlName: 'name',
                  decoration: InputDecoration(
                    labelText: 'form.name'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'form.validation.required'.tr(),
                    ValidationMessage.minLength: (error) => 'form.validation.min_length'.tr(args: ['2']),
                    ValidationMessage.maxLength: (error) => 'form.validation.max_length'.tr(args: ['50']),
                  },
                ),
                SizedBox(height: 16.h),
                
                ReactiveTextField<String>(
                  formControlName: 'email',
                  decoration: InputDecoration(
                    labelText: 'form.email'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'form.validation.required'.tr(),
                    ValidationMessage.email: (_) => 'form.validation.invalid_email'.tr(),
                  },
                ),
                SizedBox(height: 16.h),
                
                ReactiveTextField<int>(
                  formControlName: 'age',
                  decoration: InputDecoration(
                    labelText: 'form.age'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'form.validation.required'.tr(),
                    ValidationMessage.min: (error) => 'form.validation.min_age'.tr(args: ['18']),
                    ValidationMessage.max: (error) => 'form.validation.max_age'.tr(args: ['100']),
                  },
                ),
                SizedBox(height: 16.h),
                
                ReactiveDropdownField<String>(
                  formControlName: 'country',
                  decoration: InputDecoration(
                    labelText: 'form.country'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  items: [
                    DropdownMenuItem(value: 'us', child: Text('form.countries.us'.tr())),
                    DropdownMenuItem(value: 'uk', child: Text('form.countries.uk'.tr())),
                    DropdownMenuItem(value: 'de', child: Text('form.countries.de'.tr())),
                    DropdownMenuItem(value: 'fr', child: Text('form.countries.fr'.tr())),
                    DropdownMenuItem(value: 'az', child: Text('form.countries.az'.tr())),
                    DropdownMenuItem(value: 'ru', child: Text('form.countries.ru'.tr())),
                  ],
                  validationMessages: {
                    ValidationMessage.required: (_) => 'form.validation.required'.tr(),
                  },
                ),
                SizedBox(height: 16.h),
                
                Text(
                  'form.gender'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                ReactiveRadioListTile<String>(
                  formControlName: 'gender',
                  value: 'male',
                  title: Text('form.gender.male'.tr()),
                ),
                ReactiveRadioListTile<String>(
                  formControlName: 'gender',
                  value: 'female',
                  title: Text('form.gender.female'.tr()),
                ),
                ReactiveRadioListTile<String>(
                  formControlName: 'gender',
                  value: 'other',
                  title: Text('form.gender.other'.tr()),
                ),
                ReactiveFormField<String, String>(
                  formControlName: 'gender',
                  builder: (field) {
                    return field.control.hasErrors
                        ? Padding(
                            padding: EdgeInsets.only(left: 16.w, top: 4.h),
                            child: Text(
                              'form.validation.required'.tr(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12.sp,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 16.h),
                
                ReactiveCheckboxListTile(
                  formControlName: 'terms',
                  title: Text('form.terms'.tr()),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                ReactiveFormField<bool, bool>(
                  formControlName: 'terms',
                  builder: (field) {
                    return field.control.hasErrors
                        ? Padding(
                            padding: EdgeInsets.only(left: 16.w, top: 4.h),
                            child: Text(
                              'form.validation.terms_required'.tr(),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12.sp,
                              ),
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 24.h),
                
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (form.valid) {
                        final formValue = form.value;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('form.success'.tr()),
                            backgroundColor: Colors.green,
                          ),
                        );
                        debugPrint('Form Value: $formValue');
                      } else {
                        form.markAllAsTouched();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('form.validation.form_invalid'.tr()),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: Text(
                      'form.submit'.tr(),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: OutlinedButton(
                    onPressed: () => context.go('/'),
                    child: Text(
                      'form.back_to_home'.tr(),
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}