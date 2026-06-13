///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
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

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$authError$en authError = Translations$authError$en._(_root);
	late final Translations$emailVerificationLinkSent$en emailVerificationLinkSent = Translations$emailVerificationLinkSent$en._(_root);
	late final Translations$forgotPassword$en forgotPassword = Translations$forgotPassword$en._(_root);
	late final Translations$home$en home = Translations$home$en._(_root);
	late final Translations$resetPasswordLinkSent$en resetPasswordLinkSent = Translations$resetPasswordLinkSent$en._(_root);
	late final Translations$resetPassword$en resetPassword = Translations$resetPassword$en._(_root);
	late final Translations$signIn$en signIn = Translations$signIn$en._(_root);
	late final Translations$signUp$en signUp = Translations$signUp$en._(_root);
}

// Path: authError
class Translations$authError$en {
	Translations$authError$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Incorrect email or password.'
	String get invalidCredentials => 'Incorrect email or password.';

	/// en: 'Please verify your email address before signing in.'
	String get emailNotConfirmed => 'Please verify your email address before signing in.';

	/// en: 'An account with this email already exists.'
	String get userAlreadyExists => 'An account with this email already exists.';

	/// en: 'Minimum 8 characters, upper and lower case, with at least one special character.'
	String get weakPassword => 'Minimum 8 characters, upper and lower case, with at least one special character.';

	/// en: 'Too many attempts. Please wait a moment and try again.'
	String get rateLimited => 'Too many attempts. Please wait a moment and try again.';

	/// en: 'A network error occurred. Please check your connection and try again.'
	String get network => 'A network error occurred. Please check your connection and try again.';

	/// en: 'Something went wrong. Please try again.'
	String get unknown => 'Something went wrong. Please try again.';
}

// Path: emailVerificationLinkSent
class Translations$emailVerificationLinkSent$en {
	Translations$emailVerificationLinkSent$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Email Verification Link Sent'
	String get title => 'Email Verification Link Sent';

	/// en: 'Check your email for you email verification link.'
	String get subtitle => 'Check your email for you email verification link.';
}

// Path: forgotPassword
class Translations$forgotPassword$en {
	Translations$forgotPassword$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Forgot Password?'
	String get title => 'Forgot Password?';

	late final Translations$forgotPassword$form$en form = Translations$forgotPassword$form$en._(_root);
}

// Path: home
class Translations$home$en {
	Translations$home$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get title => 'Home';
}

// Path: resetPasswordLinkSent
class Translations$resetPasswordLinkSent$en {
	Translations$resetPasswordLinkSent$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reset Password Link'
	String get title => 'Reset Password Link';

	/// en: 'Check your email for your reset password link.'
	String get subtitle => 'Check your email for your reset password link.';

	late final Translations$resetPasswordLinkSent$resend$en resend = Translations$resetPasswordLinkSent$resend$en._(_root);
}

// Path: resetPassword
class Translations$resetPassword$en {
	Translations$resetPassword$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reset Password'
	String get title => 'Reset Password';

	late final Translations$resetPassword$form$en form = Translations$resetPassword$form$en._(_root);
}

// Path: signIn
class Translations$signIn$en {
	Translations$signIn$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sign In'
	String get title => 'Sign In';

	late final Translations$signIn$signUp$en signUp = Translations$signIn$signUp$en._(_root);
	late final Translations$signIn$forgotPassword$en forgotPassword = Translations$signIn$forgotPassword$en._(_root);
	late final Translations$signIn$form$en form = Translations$signIn$form$en._(_root);
}

// Path: signUp
class Translations$signUp$en {
	Translations$signUp$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sign Up'
	String get title => 'Sign Up';

	late final Translations$signUp$form$en form = Translations$signUp$form$en._(_root);
	late final Translations$signUp$resendEmailVerification$en resendEmailVerification = Translations$signUp$resendEmailVerification$en._(_root);
}

// Path: forgotPassword.form
class Translations$forgotPassword$form$en {
	Translations$forgotPassword$form$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$forgotPassword$form$email$en email = Translations$forgotPassword$form$email$en._(_root);
	late final Translations$forgotPassword$form$submit$en submit = Translations$forgotPassword$form$submit$en._(_root);
}

// Path: resetPasswordLinkSent.resend
class Translations$resetPasswordLinkSent$resend$en {
	Translations$resetPasswordLinkSent$resend$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Didn't receive a link?'
	String get question => 'Didn\'t receive a link?';

	/// en: 'Resend'
	String get action => 'Resend';

	/// en: 'Your reset password link was resent.'
	String get success => 'Your reset password link was resent.';
}

// Path: resetPassword.form
class Translations$resetPassword$form$en {
	Translations$resetPassword$form$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$resetPassword$form$password$en password = Translations$resetPassword$form$password$en._(_root);
	late final Translations$resetPassword$form$submit$en submit = Translations$resetPassword$form$submit$en._(_root);
}

// Path: signIn.signUp
class Translations$signIn$signUp$en {
	Translations$signIn$signUp$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Need an account?'
	String get question => 'Need an account?';

	/// en: 'Sign Up'
	String get action => 'Sign Up';
}

// Path: signIn.forgotPassword
class Translations$signIn$forgotPassword$en {
	Translations$signIn$forgotPassword$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Forgot password?'
	String get question => 'Forgot password?';
}

// Path: signIn.form
class Translations$signIn$form$en {
	Translations$signIn$form$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$signIn$form$email$en email = Translations$signIn$form$email$en._(_root);
	late final Translations$signIn$form$password$en password = Translations$signIn$form$password$en._(_root);
	late final Translations$signIn$form$submit$en submit = Translations$signIn$form$submit$en._(_root);
}

// Path: signUp.form
class Translations$signUp$form$en {
	Translations$signUp$form$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$signUp$form$email$en email = Translations$signUp$form$email$en._(_root);
	late final Translations$signUp$form$password$en password = Translations$signUp$form$password$en._(_root);
	late final Translations$signUp$form$submit$en submit = Translations$signUp$form$submit$en._(_root);
}

// Path: signUp.resendEmailVerification
class Translations$signUp$resendEmailVerification$en {
	Translations$signUp$resendEmailVerification$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Still need to verify you email?'
	String get question => 'Still need to verify you email?';

	/// en: 'Resend'
	String get action => 'Resend';

	late final Translations$signUp$resendEmailVerification$dialog$en dialog = Translations$signUp$resendEmailVerification$dialog$en._(_root);
}

// Path: forgotPassword.form.email
class Translations$forgotPassword$form$email$en {
	Translations$forgotPassword$form$email$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Email'
	String get label => 'Email';

	/// en: 'john.doe@example.com'
	String get hint => 'john.doe@example.com';

	late final Translations$forgotPassword$form$email$error$en error = Translations$forgotPassword$form$email$error$en._(_root);
}

// Path: forgotPassword.form.submit
class Translations$forgotPassword$form$submit$en {
	Translations$forgotPassword$form$submit$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reset Password'
	String get label => 'Reset Password';
}

// Path: resetPassword.form.password
class Translations$resetPassword$form$password$en {
	Translations$resetPassword$form$password$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Password'
	String get label => 'Password';

	late final Translations$resetPassword$form$password$error$en error = Translations$resetPassword$form$password$error$en._(_root);
}

// Path: resetPassword.form.submit
class Translations$resetPassword$form$submit$en {
	Translations$resetPassword$form$submit$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Reset Password'
	String get label => 'Reset Password';

	/// en: 'Your password was reset.'
	String get success => 'Your password was reset.';
}

// Path: signIn.form.email
class Translations$signIn$form$email$en {
	Translations$signIn$form$email$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Email'
	String get label => 'Email';

	/// en: 'john.doe@example.com'
	String get hint => 'john.doe@example.com';

	late final Translations$signIn$form$email$error$en error = Translations$signIn$form$email$error$en._(_root);
}

// Path: signIn.form.password
class Translations$signIn$form$password$en {
	Translations$signIn$form$password$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Password'
	String get label => 'Password';

	late final Translations$signIn$form$password$error$en error = Translations$signIn$form$password$error$en._(_root);
}

// Path: signIn.form.submit
class Translations$signIn$form$submit$en {
	Translations$signIn$form$submit$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sign In'
	String get label => 'Sign In';
}

// Path: signUp.form.email
class Translations$signUp$form$email$en {
	Translations$signUp$form$email$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Email'
	String get label => 'Email';

	/// en: 'john.doe@example.com'
	String get hint => 'john.doe@example.com';

	late final Translations$signUp$form$email$error$en error = Translations$signUp$form$email$error$en._(_root);
}

// Path: signUp.form.password
class Translations$signUp$form$password$en {
	Translations$signUp$form$password$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Password'
	String get label => 'Password';

	late final Translations$signUp$form$password$error$en error = Translations$signUp$form$password$error$en._(_root);
}

// Path: signUp.form.submit
class Translations$signUp$form$submit$en {
	Translations$signUp$form$submit$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sign Up'
	String get label => 'Sign Up';
}

// Path: signUp.resendEmailVerification.dialog
class Translations$signUp$resendEmailVerification$dialog$en {
	Translations$signUp$resendEmailVerification$dialog$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Email Verification Link'
	String get title => 'Email Verification Link';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	late final Translations$signUp$resendEmailVerification$dialog$submit$en submit = Translations$signUp$resendEmailVerification$dialog$submit$en._(_root);
}

// Path: forgotPassword.form.email.error
class Translations$forgotPassword$form$email$error$en {
	Translations$forgotPassword$form$email$error$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please enter your email address.'
	String get empty => 'Please enter your email address.';

	/// en: 'Please enter a valid email address.'
	String get invalid => 'Please enter a valid email address.';
}

// Path: resetPassword.form.password.error
class Translations$resetPassword$form$password$error$en {
	Translations$resetPassword$form$password$error$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please enter a password.'
	String get empty => 'Please enter a password.';

	/// en: 'Minimum 8 characters, upper and lower case, with at least one special character.'
	String get invalid => 'Minimum 8 characters, upper and lower case, with at least one special character.';
}

// Path: signIn.form.email.error
class Translations$signIn$form$email$error$en {
	Translations$signIn$form$email$error$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please enter your email address.'
	String get empty => 'Please enter your email address.';

	/// en: 'Please enter a valid email address.'
	String get invalid => 'Please enter a valid email address.';
}

// Path: signIn.form.password.error
class Translations$signIn$form$password$error$en {
	Translations$signIn$form$password$error$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please enter a password.'
	String get empty => 'Please enter a password.';
}

// Path: signUp.form.email.error
class Translations$signUp$form$email$error$en {
	Translations$signUp$form$email$error$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please enter your email address.'
	String get empty => 'Please enter your email address.';

	/// en: 'Please enter a valid email address.'
	String get invalid => 'Please enter a valid email address.';
}

// Path: signUp.form.password.error
class Translations$signUp$form$password$error$en {
	Translations$signUp$form$password$error$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please enter a password.'
	String get empty => 'Please enter a password.';

	/// en: 'Minimum 8 characters, upper and lower case, with at least one special character.'
	String get invalid => 'Minimum 8 characters, upper and lower case, with at least one special character.';
}

// Path: signUp.resendEmailVerification.dialog.submit
class Translations$signUp$resendEmailVerification$dialog$submit$en {
	Translations$signUp$resendEmailVerification$dialog$submit$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Resend'
	String get label => 'Resend';

	/// en: 'Your email verification link was resent.'
	String get success => 'Your email verification link was resent.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'authError.invalidCredentials' => 'Incorrect email or password.',
			'authError.emailNotConfirmed' => 'Please verify your email address before signing in.',
			'authError.userAlreadyExists' => 'An account with this email already exists.',
			'authError.weakPassword' => 'Minimum 8 characters, upper and lower case, with at least one special character.',
			'authError.rateLimited' => 'Too many attempts. Please wait a moment and try again.',
			'authError.network' => 'A network error occurred. Please check your connection and try again.',
			'authError.unknown' => 'Something went wrong. Please try again.',
			'emailVerificationLinkSent.title' => 'Email Verification Link Sent',
			'emailVerificationLinkSent.subtitle' => 'Check your email for you email verification link.',
			'forgotPassword.title' => 'Forgot Password?',
			'forgotPassword.form.email.label' => 'Email',
			'forgotPassword.form.email.hint' => 'john.doe@example.com',
			'forgotPassword.form.email.error.empty' => 'Please enter your email address.',
			'forgotPassword.form.email.error.invalid' => 'Please enter a valid email address.',
			'forgotPassword.form.submit.label' => 'Reset Password',
			'home.title' => 'Home',
			'resetPasswordLinkSent.title' => 'Reset Password Link',
			'resetPasswordLinkSent.subtitle' => 'Check your email for your reset password link.',
			'resetPasswordLinkSent.resend.question' => 'Didn\'t receive a link?',
			'resetPasswordLinkSent.resend.action' => 'Resend',
			'resetPasswordLinkSent.resend.success' => 'Your reset password link was resent.',
			'resetPassword.title' => 'Reset Password',
			'resetPassword.form.password.label' => 'Password',
			'resetPassword.form.password.error.empty' => 'Please enter a password.',
			'resetPassword.form.password.error.invalid' => 'Minimum 8 characters, upper and lower case, with at least one special character.',
			'resetPassword.form.submit.label' => 'Reset Password',
			'resetPassword.form.submit.success' => 'Your password was reset.',
			'signIn.title' => 'Sign In',
			'signIn.signUp.question' => 'Need an account?',
			'signIn.signUp.action' => 'Sign Up',
			'signIn.forgotPassword.question' => 'Forgot password?',
			'signIn.form.email.label' => 'Email',
			'signIn.form.email.hint' => 'john.doe@example.com',
			'signIn.form.email.error.empty' => 'Please enter your email address.',
			'signIn.form.email.error.invalid' => 'Please enter a valid email address.',
			'signIn.form.password.label' => 'Password',
			'signIn.form.password.error.empty' => 'Please enter a password.',
			'signIn.form.submit.label' => 'Sign In',
			'signUp.title' => 'Sign Up',
			'signUp.form.email.label' => 'Email',
			'signUp.form.email.hint' => 'john.doe@example.com',
			'signUp.form.email.error.empty' => 'Please enter your email address.',
			'signUp.form.email.error.invalid' => 'Please enter a valid email address.',
			'signUp.form.password.label' => 'Password',
			'signUp.form.password.error.empty' => 'Please enter a password.',
			'signUp.form.password.error.invalid' => 'Minimum 8 characters, upper and lower case, with at least one special character.',
			'signUp.form.submit.label' => 'Sign Up',
			'signUp.resendEmailVerification.question' => 'Still need to verify you email?',
			'signUp.resendEmailVerification.action' => 'Resend',
			'signUp.resendEmailVerification.dialog.title' => 'Email Verification Link',
			'signUp.resendEmailVerification.dialog.cancel' => 'Cancel',
			'signUp.resendEmailVerification.dialog.submit.label' => 'Resend',
			'signUp.resendEmailVerification.dialog.submit.success' => 'Your email verification link was resent.',
			_ => null,
		};
	}
}
