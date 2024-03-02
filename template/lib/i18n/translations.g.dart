/// Generated file. Do not edit.
///
/// Original: lib/i18n
/// To regenerate, run: `dart run slang`
///
/// Locales: 1
/// Strings: 37
///
/// Built on 2024-03-02 at 18:25 UTC

// coverage:ignore-file
// ignore_for_file: type=lint

import 'package:flutter/widgets.dart';
import 'package:slang/builder/model/node.dart';
import 'package:slang_flutter/slang_flutter.dart';
export 'package:slang_flutter/slang_flutter.dart';

const AppLocale _baseLocale = AppLocale.en;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale with BaseAppLocale<AppLocale, Translations> {
	en(languageCode: 'en', build: Translations.build);

	const AppLocale({required this.languageCode, this.scriptCode, this.countryCode, required this.build}); // ignore: unused_element

	@override final String languageCode;
	@override final String? scriptCode;
	@override final String? countryCode;
	@override final TranslationBuilder<AppLocale, Translations> build;

	/// Gets current instance managed by [LocaleSettings].
	Translations get translations => LocaleSettings.instance.translationMap[this]!;
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
/// Configurable via 'translate_var'.
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
Translations get t => LocaleSettings.instance.currentTranslations;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class TranslationProvider extends BaseTranslationProvider<AppLocale, Translations> {
	TranslationProvider({required super.child}) : super(settings: LocaleSettings.instance);

	static InheritedLocaleData<AppLocale, Translations> of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context);
}

/// Method B shorthand via [BuildContext] extension method.
/// Configurable via 'translate_var'.
///
/// Usage (e.g. in a widget's build method):
/// context.t.someKey.anotherKey
extension BuildContextTranslationsExtension on BuildContext {
	Translations get t => TranslationProvider.of(this).translations;
}

/// Manages all translation instances and the current locale
class LocaleSettings extends BaseFlutterLocaleSettings<AppLocale, Translations> {
	LocaleSettings._() : super(utils: AppLocaleUtils.instance);

	static final instance = LocaleSettings._();

	// static aliases (checkout base methods for documentation)
	static AppLocale get currentLocale => instance.currentLocale;
	static Stream<AppLocale> getLocaleStream() => instance.getLocaleStream();
	static AppLocale setLocale(AppLocale locale, {bool? listenToDeviceLocale = false}) => instance.setLocale(locale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale setLocaleRaw(String rawLocale, {bool? listenToDeviceLocale = false}) => instance.setLocaleRaw(rawLocale, listenToDeviceLocale: listenToDeviceLocale);
	static AppLocale useDeviceLocale() => instance.useDeviceLocale();
	@Deprecated('Use [AppLocaleUtils.supportedLocales]') static List<Locale> get supportedLocales => instance.supportedLocales;
	@Deprecated('Use [AppLocaleUtils.supportedLocalesRaw]') static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) => instance.setPluralResolver(
		language: language,
		locale: locale,
		cardinalResolver: cardinalResolver,
		ordinalResolver: ordinalResolver,
	);
}

/// Provides utility functions without any side effects.
class AppLocaleUtils extends BaseAppLocaleUtils<AppLocale, Translations> {
	AppLocaleUtils._() : super(baseLocale: _baseLocale, locales: AppLocale.values);

	static final instance = AppLocaleUtils._();

	// static aliases (checkout base methods for documentation)
	static AppLocale parse(String rawLocale) => instance.parse(rawLocale);
	static AppLocale parseLocaleParts({required String languageCode, String? scriptCode, String? countryCode}) => instance.parseLocaleParts(languageCode: languageCode, scriptCode: scriptCode, countryCode: countryCode);
	static AppLocale findDeviceLocale() => instance.findDeviceLocale();
	static List<Locale> get supportedLocales => instance.supportedLocales;
	static List<String> get supportedLocalesRaw => instance.supportedLocalesRaw;
}

// translations

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations implements BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations.build({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	// Translations
	late final TranslationsSharedEn shared = TranslationsSharedEn._(_root);
	late final TranslationsSignInEn signIn = TranslationsSignInEn._(_root);
	late final TranslationsSignUpEn signUp = TranslationsSignUpEn._(_root);
	late final TranslationsForgotPasswordEn forgotPassword = TranslationsForgotPasswordEn._(_root);
	late final TranslationsForgotPasswordConfirmationEn forgotPasswordConfirmation = TranslationsForgotPasswordConfirmationEn._(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn._(_root);
	late final TranslationsResetPasswordEn resetPassword = TranslationsResetPasswordEn._(_root);
}

// Path: shared
class TranslationsSharedEn {
	TranslationsSharedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSharedRecordAudioEn recordAudio = TranslationsSharedRecordAudioEn._(_root);
}

// Path: signIn
class TranslationsSignInEn {
	TranslationsSignInEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Sign In';
	late final TranslationsSignInFormEn form = TranslationsSignInFormEn._(_root);
	late final TranslationsSignInCtasEn ctas = TranslationsSignInCtasEn._(_root);
	TextSpan forgotPassword({required InlineSpanBuilder tapHere}) => TextSpan(children: [
		tapHere('Forgot Password'),
	]);
	TextSpan newUserSignUp({required InlineSpanBuilder tapHere}) => TextSpan(children: [
		const TextSpan(text: 'New User? '),
		tapHere('Sign Up'),
	]);
}

// Path: signUp
class TranslationsSignUpEn {
	TranslationsSignUpEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Sign Up';
	late final TranslationsSignUpFormEn form = TranslationsSignUpFormEn._(_root);
	late final TranslationsSignUpCtasEn ctas = TranslationsSignUpCtasEn._(_root);
}

// Path: forgotPassword
class TranslationsForgotPasswordEn {
	TranslationsForgotPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Forgot Password';
	late final TranslationsForgotPasswordFormEn form = TranslationsForgotPasswordFormEn._(_root);
	late final TranslationsForgotPasswordCtasEn ctas = TranslationsForgotPasswordCtasEn._(_root);
}

// Path: forgotPasswordConfirmation
class TranslationsForgotPasswordConfirmationEn {
	TranslationsForgotPasswordConfirmationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Check your inbox.';
	String get subtitle => 'If this email is valid, you should receive a log-in link within a few minutes.';
	late final TranslationsForgotPasswordConfirmationCtasEn ctas = TranslationsForgotPasswordConfirmationCtasEn._(_root);
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Home';
	String get signOut => 'Sign Out';
	late final TranslationsHomeGetMyRecordingsEn getMyRecordings = TranslationsHomeGetMyRecordingsEn._(_root);
	late final TranslationsHomePlayRecordingEn playRecording = TranslationsHomePlayRecordingEn._(_root);
}

// Path: resetPassword
class TranslationsResetPasswordEn {
	TranslationsResetPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get title => 'Reset Password';
	late final TranslationsResetPasswordFormEn form = TranslationsResetPasswordFormEn._(_root);
	late final TranslationsResetPasswordCtasEn ctas = TranslationsResetPasswordCtasEn._(_root);
}

// Path: shared.recordAudio
class TranslationsSharedRecordAudioEn {
	TranslationsSharedRecordAudioEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get error => 'Uh oh, something went wrong.';
}

// Path: signIn.form
class TranslationsSignInFormEn {
	TranslationsSignInFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSignInFormEmailEn email = TranslationsSignInFormEmailEn._(_root);
	late final TranslationsSignInFormPasswordEn password = TranslationsSignInFormPasswordEn._(_root);
}

// Path: signIn.ctas
class TranslationsSignInCtasEn {
	TranslationsSignInCtasEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSignInCtasSignInEn signIn = TranslationsSignInCtasSignInEn._(_root);
}

// Path: signUp.form
class TranslationsSignUpFormEn {
	TranslationsSignUpFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSignUpFormEmailEn email = TranslationsSignUpFormEmailEn._(_root);
	late final TranslationsSignUpFormPasswordEn password = TranslationsSignUpFormPasswordEn._(_root);
}

// Path: signUp.ctas
class TranslationsSignUpCtasEn {
	TranslationsSignUpCtasEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsSignUpCtasSignUpEn signUp = TranslationsSignUpCtasSignUpEn._(_root);
}

// Path: forgotPassword.form
class TranslationsForgotPasswordFormEn {
	TranslationsForgotPasswordFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsForgotPasswordFormEmailEn email = TranslationsForgotPasswordFormEmailEn._(_root);
}

// Path: forgotPassword.ctas
class TranslationsForgotPasswordCtasEn {
	TranslationsForgotPasswordCtasEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsForgotPasswordCtasResetPasswordEn resetPassword = TranslationsForgotPasswordCtasResetPasswordEn._(_root);
}

// Path: forgotPasswordConfirmation.ctas
class TranslationsForgotPasswordConfirmationCtasEn {
	TranslationsForgotPasswordConfirmationCtasEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsForgotPasswordConfirmationCtasResendEmailEn resendEmail = TranslationsForgotPasswordConfirmationCtasResendEmailEn._(_root);
}

// Path: home.getMyRecordings
class TranslationsHomeGetMyRecordingsEn {
	TranslationsHomeGetMyRecordingsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get error => 'Uh oh, your recordings were not fetched.';
}

// Path: home.playRecording
class TranslationsHomePlayRecordingEn {
	TranslationsHomePlayRecordingEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get error => 'Uh oh, there was a problem with your recording.';
}

// Path: resetPassword.form
class TranslationsResetPasswordFormEn {
	TranslationsResetPasswordFormEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsResetPasswordFormNewPasswordEn newPassword = TranslationsResetPasswordFormNewPasswordEn._(_root);
}

// Path: resetPassword.ctas
class TranslationsResetPasswordCtasEn {
	TranslationsResetPasswordCtasEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsResetPasswordCtasResetPasswordEn resetPassword = TranslationsResetPasswordCtasResetPasswordEn._(_root);
}

// Path: signIn.form.email
class TranslationsSignInFormEmailEn {
	TranslationsSignInFormEmailEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get placeholder => 'Email';
	late final TranslationsSignInFormEmailErrorEn error = TranslationsSignInFormEmailErrorEn._(_root);
}

// Path: signIn.form.password
class TranslationsSignInFormPasswordEn {
	TranslationsSignInFormPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get placeholder => 'Password';
}

// Path: signIn.ctas.signIn
class TranslationsSignInCtasSignInEn {
	TranslationsSignInCtasSignInEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get label => 'Sign In';
	String get error => 'Could not sign in.';
}

// Path: signUp.form.email
class TranslationsSignUpFormEmailEn {
	TranslationsSignUpFormEmailEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get placeholder => 'Email';
	late final TranslationsSignUpFormEmailErrorEn error = TranslationsSignUpFormEmailErrorEn._(_root);
}

// Path: signUp.form.password
class TranslationsSignUpFormPasswordEn {
	TranslationsSignUpFormPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get placeholder => 'Password';
	TextSpan helpText({required InlineSpanBuilder tapHere}) => TextSpan(children: [
		tapHere('See password criteria'),
	]);
	late final TranslationsSignUpFormPasswordErrorEn error = TranslationsSignUpFormPasswordErrorEn._(_root);
}

// Path: signUp.ctas.signUp
class TranslationsSignUpCtasSignUpEn {
	TranslationsSignUpCtasSignUpEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get label => 'Sign Up';
	String get error => 'Could not sign up.';
}

// Path: forgotPassword.form.email
class TranslationsForgotPasswordFormEmailEn {
	TranslationsForgotPasswordFormEmailEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get placeholder => 'Email';
	late final TranslationsForgotPasswordFormEmailErrorEn error = TranslationsForgotPasswordFormEmailErrorEn._(_root);
}

// Path: forgotPassword.ctas.resetPassword
class TranslationsForgotPasswordCtasResetPasswordEn {
	TranslationsForgotPasswordCtasResetPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get label => 'Reset Password';
	String get error => 'Could not reset password.';
}

// Path: forgotPasswordConfirmation.ctas.resendEmail
class TranslationsForgotPasswordConfirmationCtasResendEmailEn {
	TranslationsForgotPasswordConfirmationCtasResendEmailEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get label => 'Re-send Email';
	String get success => 'Email resent.';
	String get error => 'Could not resend email.';
}

// Path: resetPassword.form.newPassword
class TranslationsResetPasswordFormNewPasswordEn {
	TranslationsResetPasswordFormNewPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get placeholder => 'New Password';
	late final TranslationsResetPasswordFormNewPasswordErrorEn error = TranslationsResetPasswordFormNewPasswordErrorEn._(_root);
}

// Path: resetPassword.ctas.resetPassword
class TranslationsResetPasswordCtasResetPasswordEn {
	TranslationsResetPasswordCtasResetPasswordEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get label => 'Reset password';
	String get success => 'Your password was reset.';
	String get error => 'Your password was not reset.';
}

// Path: signIn.form.email.error
class TranslationsSignInFormEmailErrorEn {
	TranslationsSignInFormEmailErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get invalid => 'Please enter a valid email address.';
}

// Path: signUp.form.email.error
class TranslationsSignUpFormEmailErrorEn {
	TranslationsSignUpFormEmailErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get invalid => 'Please enter a valid email address.';
}

// Path: signUp.form.password.error
class TranslationsSignUpFormPasswordErrorEn {
	TranslationsSignUpFormPasswordErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get invalid => 'Minimum 8 characters, upper and lower case, with at least one special character.';
}

// Path: forgotPassword.form.email.error
class TranslationsForgotPasswordFormEmailErrorEn {
	TranslationsForgotPasswordFormEmailErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get invalid => 'Please enter a valid email address.';
}

// Path: resetPassword.form.newPassword.error
class TranslationsResetPasswordFormNewPasswordErrorEn {
	TranslationsResetPasswordFormNewPasswordErrorEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	String get invalid => 'Minimum 8 characters, upper and lower case, with at least one special character.';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on Translations {
	dynamic _flatMapFunction(String path) {
		switch (path) {
			case 'shared.recordAudio.error': return 'Uh oh, something went wrong.';
			case 'signIn.title': return 'Sign In';
			case 'signIn.form.email.placeholder': return 'Email';
			case 'signIn.form.email.error.invalid': return 'Please enter a valid email address.';
			case 'signIn.form.password.placeholder': return 'Password';
			case 'signIn.ctas.signIn.label': return 'Sign In';
			case 'signIn.ctas.signIn.error': return 'Could not sign in.';
			case 'signIn.forgotPassword': return ({required InlineSpanBuilder tapHere}) => TextSpan(children: [
				tapHere('Forgot Password'),
			]);
			case 'signIn.newUserSignUp': return ({required InlineSpanBuilder tapHere}) => TextSpan(children: [
				const TextSpan(text: 'New User? '),
				tapHere('Sign Up'),
			]);
			case 'signUp.title': return 'Sign Up';
			case 'signUp.form.email.placeholder': return 'Email';
			case 'signUp.form.email.error.invalid': return 'Please enter a valid email address.';
			case 'signUp.form.password.placeholder': return 'Password';
			case 'signUp.form.password.helpText': return ({required InlineSpanBuilder tapHere}) => TextSpan(children: [
				tapHere('See password criteria'),
			]);
			case 'signUp.form.password.error.invalid': return 'Minimum 8 characters, upper and lower case, with at least one special character.';
			case 'signUp.ctas.signUp.label': return 'Sign Up';
			case 'signUp.ctas.signUp.error': return 'Could not sign up.';
			case 'forgotPassword.title': return 'Forgot Password';
			case 'forgotPassword.form.email.placeholder': return 'Email';
			case 'forgotPassword.form.email.error.invalid': return 'Please enter a valid email address.';
			case 'forgotPassword.ctas.resetPassword.label': return 'Reset Password';
			case 'forgotPassword.ctas.resetPassword.error': return 'Could not reset password.';
			case 'forgotPasswordConfirmation.title': return 'Check your inbox.';
			case 'forgotPasswordConfirmation.subtitle': return 'If this email is valid, you should receive a log-in link within a few minutes.';
			case 'forgotPasswordConfirmation.ctas.resendEmail.label': return 'Re-send Email';
			case 'forgotPasswordConfirmation.ctas.resendEmail.success': return 'Email resent.';
			case 'forgotPasswordConfirmation.ctas.resendEmail.error': return 'Could not resend email.';
			case 'home.title': return 'Home';
			case 'home.signOut': return 'Sign Out';
			case 'home.getMyRecordings.error': return 'Uh oh, your recordings were not fetched.';
			case 'home.playRecording.error': return 'Uh oh, there was a problem with your recording.';
			case 'resetPassword.title': return 'Reset Password';
			case 'resetPassword.form.newPassword.placeholder': return 'New Password';
			case 'resetPassword.form.newPassword.error.invalid': return 'Minimum 8 characters, upper and lower case, with at least one special character.';
			case 'resetPassword.ctas.resetPassword.label': return 'Reset password';
			case 'resetPassword.ctas.resetPassword.success': return 'Your password was reset.';
			case 'resetPassword.ctas.resetPassword.error': return 'Your password was not reset.';
			default: return null;
		}
	}
}
