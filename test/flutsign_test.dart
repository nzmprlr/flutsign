// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:flutsign/flutsign.dart';
import 'package:flutsign/src/constants.dart';
import 'package:flutsign/src/widgets/animated_text.dart';
import 'utils.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized()
          as TestWidgetsFlutterBinding;

  void setScreenSize(Size size) {
    binding.window.physicalSizeTestValue = size;
    binding.window.devicePixelRatioTestValue = 1.0;
  }

  void clearScreenSize() {
    binding.window.clearPhysicalSizeTestValue();
  }

  testWidgets('Default email validator throws error if not match email regex',
      (WidgetTester tester) async {
    await tester.pumpWidget(defaultFlutterLogin());

    // wait for loading animation to finish
    await tester.pumpAndSettle();

    // empty email
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findEmailTextField(), '');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    // TODO: put error messages into variables
    expect(
        emailTextFieldWidget(tester).decoration!.errorText, 'Invalid email!');

    // missing '@'
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findEmailTextField(), 'neargmail.com');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(
        emailTextFieldWidget(tester).decoration!.errorText, 'Invalid email!');

    // missing the part before '@'
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findEmailTextField(), '@gmail.com');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(
        emailTextFieldWidget(tester).decoration!.errorText, 'Invalid email!');

    // missing the part after '@'
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findEmailTextField(), 'near@.com');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(
        emailTextFieldWidget(tester).decoration!.errorText, 'Invalid email!');

    // missing domain extension (.com, .org...)
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findEmailTextField(), 'near@gmail');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(
        emailTextFieldWidget(tester).decoration!.errorText, 'Invalid email!');

    // valid email based on default validator
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findEmailTextField(), 'near@gmail.com');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(emailTextFieldWidget(tester).decoration!.errorText, null);
  });

  testWidgets('Default username validator throws error if username is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(defaultFlutterLogin());

    // wait for loading animation to finish
    await tester.pumpAndSettle();

    // empty
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findUsernameTextField(), '');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(usernameTextFieldWidget(tester).decoration!.errorText,
        'Invalid username!');

    // too short
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findUsernameTextField(), '12');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(usernameTextFieldWidget(tester).decoration!.errorText, null);
  });

  testWidgets(
      'Default password validator throws error if password is less than 3 characters',
      (WidgetTester tester) async {
    await tester.pumpWidget(defaultFlutterLogin());

    // wait for loading animation to finish
    await tester.pumpAndSettle();

    // empty
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findPasswordTextField(), '');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(passwordTextFieldWidget(tester).decoration!.errorText,
        'Password is too short!');

    // too short
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findPasswordTextField(), '12');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(passwordTextFieldWidget(tester).decoration!.errorText,
        'Password is too short!');

    // valid password based on default validator
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findPasswordTextField(), '123');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(passwordTextFieldWidget(tester).decoration!.errorText, null);

    // valid password based on default validator
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(
        findPasswordTextField(), 'aslfjsldfjlsjflsfjslfklsdjflsdjf');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(passwordTextFieldWidget(tester).decoration!.errorText, null);
  });

  testWidgets('Confirm password field throws error if not match with password',
      (WidgetTester tester) async {
    await tester.pumpWidget(defaultFlutterLogin());

    // wait for loading animation to finish
    await tester.pumpAndSettle();

    // click register button to expand confirm password TextField (hidden when login)
    clickSwitchAuthButton();
    await tester.pumpAndSettle();
    expect(isSignup(tester), true);

    // not match
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findPasswordTextField(), 'abcde');
    await tester.pumpAndSettle();
    await tester.enterText(findConfirmPasswordTextField(), 'abcdE');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(passwordTextFieldWidget(tester).decoration!.errorText, null);
    expect(confirmPasswordTextFieldWidget(tester).decoration!.errorText,
        SignMessages.defaultConfirmPasswordError);

    // match
    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findPasswordTextField(), 'abcdE');
    await tester.pumpAndSettle();
    await tester.enterText(findConfirmPasswordTextField(), 'abcdE');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(passwordTextFieldWidget(tester).decoration!.errorText, null);
    expect(confirmPasswordTextFieldWidget(tester).decoration!.errorText, null);
  });

  testWidgets('Custom emailValidator should show error when return a string',
      (WidgetTester tester) async {
    final loginBuilder = () => widget(FlutSign(
          onSignup: (data) => null,
          onLogin: (data) => null,
          onRecoverPassword: (data) => null,
          emailValidator: (value) =>
              value!.endsWith('.com') ? null : 'Invalid!',
        ));
    await tester.pumpWidget(loginBuilder());
    await tester.pumpAndSettle(loadingAnimationDuration);

    // invalid value
    await simulateOpenSoftKeyboard(tester, loginBuilder());
    await tester.enterText(findEmailTextField(), 'abc.org');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(emailTextFieldWidget(tester).decoration!.errorText, 'Invalid!');

    // valid value
    await simulateOpenSoftKeyboard(tester, loginBuilder());
    await tester.enterText(findEmailTextField(), 'abc.com');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(emailTextFieldWidget(tester).decoration!.errorText, null);
  });

  testWidgets('Custom passwordValidator should show error when return a string',
      (WidgetTester tester) async {
    final loginBuilder = () => widget(FlutSign(
          onSignup: (data) => null,
          onLogin: (data) => null,
          onRecoverPassword: (data) => null,
          passwordValidator: (value) => value!.length == 5 ? null : 'Invalid!',
        ));
    await tester.pumpWidget(loginBuilder());
    await tester.pumpAndSettle(loadingAnimationDuration);

    // invalid value
    await simulateOpenSoftKeyboard(tester, loginBuilder());
    await tester.enterText(findPasswordTextField(), '123456');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(passwordTextFieldWidget(tester).decoration!.errorText, 'Invalid!');

    // valid value
    await simulateOpenSoftKeyboard(tester, loginBuilder());
    await tester.enterText(findPasswordTextField(), '12345');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(passwordTextFieldWidget(tester).decoration!.errorText, null);
  });

  testWidgets('Password recovery should show success message if email is valid',
      (WidgetTester tester) async {
    const users = ['near@gmail.com', 'hunter69@gmail.com'];
    final loginBuilder = () => widget(FlutSign(
          onSignup: (data) => null,
          onLogin: (data) => null,
          onRecoverPassword: (data) =>
              users.contains(data) ? null : Future.value('User not exists'),
          emailValidator: (value) => null,
        ));
    await tester.pumpWidget(loginBuilder());
    await tester.pumpAndSettle(loadingAnimationDuration);

    // Go to forgot password page
    clickForgotPasswordButton();
    await tester.pumpAndSettle();

    // invalid name
    await simulateOpenSoftKeyboard(tester, loginBuilder());
    await tester.enterText(findEmailTextField(), 'not.exists@gmail.com');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pump(); // First pump is to active the animation
    await tester.pump(
        const Duration(seconds: 4)); // second pump is to open the flushbar

    expect(find.text('User not exists'), findsOneWidget);

    // valid name
    await simulateOpenSoftKeyboard(tester, loginBuilder());
    await tester.enterText(findEmailTextField(), 'near@gmail.com');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pump(); // First pump is to active the animation
    await tester.pump(
        const Duration(seconds: 4)); // second pump is to open the flushbar

    expect(
        find.text(SignMessages.defaultRecoverPasswordSuccess), findsOneWidget);
    waitForFlushbarToClose(tester);
  });

  testWidgets('Custom login messages should display correct texts',
      (WidgetTester tester) async {
    const recoverIntro = "Don't feel bad. Happens all the time.";
    const recoverDescription =
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry';
    const recoverSuccess = 'Password rescued successfully';
    final loginBuilder = () => widget(FlutSign(
          onSignup: (data) => null,
          onLogin: (data) => null,
          onRecoverPassword: (data) => null,
          messages: SignMessages(
            emailOrUsernameHint: 'Email or Username',
            usernameHint: 'Username',
            passwordHint: 'Pass',
            confirmPasswordHint: 'Confirm',
            loginButton: 'LOG IN',
            signupButton: 'REGISTER',
            forgotPasswordButton: 'Forgot huh?',
            recoverPasswordButton: 'HELP ME',
            goBackButton: 'GO BACK',
            confirmPasswordError: 'Not match!',
            recoverPasswordIntro: recoverIntro,
            recoverPasswordDescription: recoverDescription,
            recoverPasswordSuccess: recoverSuccess,
          ),
        ));
    await tester.pumpWidget(loginBuilder());
    await tester.pumpAndSettle(loadingAnimationDuration);

    var emailTextField = emailTextFieldWidget(tester);
    expect(emailTextField.decoration!.labelText, 'Email or Username');
    expect(find.text('Email or Username'), findsOneWidget);

    final usernameTextField = usernameTextFieldWidget(tester);
    expect(usernameTextField.decoration!.labelText, 'Username');
    expect(find.text('Username'), findsOneWidget);

    final passwordTextField = passwordTextFieldWidget(tester);
    expect(passwordTextField.decoration!.labelText, 'Pass');
    expect(find.text('Pass'), findsOneWidget);

    final confirmPasswordTextField = confirmPasswordTextFieldWidget(tester);
    expect(confirmPasswordTextField.decoration!.labelText, 'Confirm');
    expect(find.text('Confirm'), findsOneWidget);

    var submitButton = submitButtonWidget();
    expect(submitButton.text, 'LOG IN');
    expect(find.text('LOG IN'), findsOneWidget);

    final forgotPasswordButton = forgotPasswordButtonWidget();
    expect((forgotPasswordButton.child as Text).data, 'Forgot huh?');
    expect(find.text('Forgot huh?'), findsOneWidget);

    final switchAuthButton = switchAuthButtonWidget();
    expect((switchAuthButton.child as AnimatedText).text, 'REGISTER');
    expect(find.text('REGISTER'), findsOneWidget);

    // enter passwords to display not matching error
    clickSwitchAuthButton();
    await tester.pumpAndSettle();
    expect(isSignup(tester), true);

    await simulateOpenSoftKeyboard(tester, loginBuilder());
    await tester.enterText(findPasswordTextField(), 'abcde');
    await tester.pumpAndSettle();
    await tester.enterText(findConfirmPasswordTextField(), 'abcdE');
    await tester.pumpAndSettle();
    clickSubmitButton();
    await tester.pumpAndSettle();

    expect(confirmPasswordTextFieldWidget(tester).decoration!.errorText,
        'Not match!');

    // Go to forgot password page
    clickForgotPasswordButton();
    await tester.pumpAndSettle();

    emailTextField = emailTextFieldWidget(tester);
    expect(emailTextField.decoration!.labelText, 'Email');
    expect(find.text('Email'), findsOneWidget);

    submitButton = submitButtonWidget();
    expect(submitButton.text, 'HELP ME');
    expect(find.text('HELP ME'), findsOneWidget);

    final goBackButton = goBackButtonWidget();
    expect((goBackButton.child as Text).data, 'GO BACK');
    expect(find.text('GO BACK'), findsOneWidget);

    final recoverIntroText = recoverIntroTextWidget();
    expect(recoverIntroText.data, recoverIntro);
    expect(find.text(recoverIntro), findsOneWidget);

    final recoverDescriptionText = recoverDescriptionTextWidget();
    expect(recoverDescriptionText.data, recoverDescription);
    expect(find.text(recoverDescription), findsOneWidget);

    // trigger recover password success message
    await simulateOpenSoftKeyboard(tester, loginBuilder());
    await tester.enterText(findEmailTextField(), 'near@gmail.com');
    await tester.pumpAndSettle();
    clickSubmitButton();

    await tester.pump(); // First pump is to active the animation
    await tester.pump(
        const Duration(seconds: 4)); // second pump is to open the flushbar

    expect(find.text(recoverSuccess), findsOneWidget);
    waitForFlushbarToClose(tester);
  });

  testWidgets('showDebugButtons = false should not show debug buttons',
      (WidgetTester tester) async {
    var flutterLogin = widget(FlutSign(
      onSignup: (data) => null,
      onLogin: (data) => null,
      onRecoverPassword: (data) => null,
      showDebugButtons: true,
    ));
    await tester.pumpWidget(flutterLogin);
    await tester.pumpAndSettle(loadingAnimationDuration);

    expect(findDebugToolbar(), findsOneWidget);

    flutterLogin = widget(FlutSign(
      onSignup: (data) => null,
      onLogin: (data) => null,
      onRecoverPassword: (data) => null,
      showDebugButtons: false,
    ));
    await tester.pumpWidget(flutterLogin);
    await tester.pumpAndSettle(loadingAnimationDuration);

    expect(findDebugToolbar(), findsNothing);
  });

  testWidgets('Leave logo parameter empty should not display login logo image',
      (WidgetTester tester) async {
    // default device height is 600. Logo is hidden in all cases because there is no space to display
    setScreenSize(Size(786, 1024));

    var flutterLogin = widget(FlutSign(
      onSignup: (data) => null,
      onLogin: (data) => null,
      onRecoverPassword: (data) => null,
    ));
    await tester.pumpWidget(flutterLogin);
    await tester.pumpAndSettle(loadingAnimationDuration);

    expect(findLogoImage(), findsNothing);

    flutterLogin = widget(FlutSign(
      onSignup: (data) => null,
      onLogin: (data) => null,
      onRecoverPassword: (data) => null,
      logo: 'assets/images/ecorp.png',
    ));
    await tester.pumpWidget(flutterLogin);
    await tester.pumpAndSettle(loadingAnimationDuration);

    expect(findLogoImage(), findsOneWidget);

    // resets the screen to its orinal size after the test end
    addTearDown(() => clearScreenSize());
  });

  testWidgets('Leave title parameter empty should not display login title',
      (WidgetTester tester) async {
    var flutterLogin = widget(FlutSign(
      onSignup: (data) => null,
      onLogin: (data) => null,
      onRecoverPassword: (data) => null,
      title: '',
    ));
    await tester.pumpWidget(flutterLogin);
    await tester.pumpAndSettle(loadingAnimationDuration);

    expect(findTitle(), findsNothing);

    flutterLogin = widget(FlutSign(
      onSignup: (data) => null,
      onLogin: (data) => null,
      onRecoverPassword: (data) => null,
      title: null,
    ));
    await tester.pumpWidget(flutterLogin);
    await tester.pumpAndSettle(loadingAnimationDuration);

    expect(findTitle(), findsNothing);

    flutterLogin = widget(FlutSign(
      onSignup: (data) => null,
      onLogin: (data) => null,
      onRecoverPassword: (data) => null,
      title: 'My Login',
    ));
    await tester.pumpWidget(flutterLogin);
    await tester.pumpAndSettle(loadingAnimationDuration);

    expect(findTitle(), findsOneWidget);
  });

  testWidgets(
      'Name, pass and confirm pass fields should remember their content when switching between login/signup and recover password',
      (WidgetTester tester) async {
    await tester.pumpWidget(defaultFlutterLogin());
    await tester.pumpAndSettle(loadingAnimationDuration);

    clickSwitchAuthButton();
    await tester.pumpAndSettle();
    expect(isSignup(tester), true);

    await simulateOpenSoftKeyboard(tester, defaultFlutterLogin());
    await tester.enterText(findEmailTextField(), 'near@gmail.com');
    await tester.pumpAndSettle();
    await tester.enterText(findPasswordTextField(), '12345');
    await tester.pumpAndSettle();
    await tester.enterText(findConfirmPasswordTextField(), 'abcde');
    await tester.pumpAndSettle();

    clickForgotPasswordButton();
    await tester.pumpAndSettle();

    expect(emailTextFieldWidget(tester).controller!.text, 'near@gmail.com');

    clickGoBackButton();
    await tester.pumpAndSettle();

    expect(emailTextFieldWidget(tester).controller!.text, 'near@gmail.com');
    expect(passwordTextFieldWidget(tester).controller!.text, '12345');
    expect(confirmPasswordTextFieldWidget(tester).controller!.text, 'abcde');
  });

  // https://github.com/NearHuscarl/flutsign/issues/20
  testWidgets(
      'Logo should be hidden if its height is less than kMinLogoHeight. Logo height should be never larger than kMaxLogoHeight',
      (WidgetTester tester) async {
    final flutterLogin = widget(FlutSign(
      onSignup: (data) => null,
      onLogin: (data) => null,
      onRecoverPassword: (data) => null,
      logo: 'assets/images/ecorp.png',
      title: 'Yang2020',
    ));

    const veryLargeHeight = 2000.0;
    const enoughHeight = 680.0;
    const verySmallHeight = 500.0;

    setScreenSize(Size(480, veryLargeHeight));
    await tester.pumpWidget(flutterLogin);
    await tester.pumpAndSettle(loadingAnimationDuration);
    expect(logoWidget(tester).height, kMaxLogoHeight);

    setScreenSize(Size(480, enoughHeight));
    await tester.pumpWidget(flutterLogin);
    await tester.pumpAndSettle(loadingAnimationDuration);
    expect(logoWidget(tester).height,
        inInclusiveRange(kMinLogoHeight, kMaxLogoHeight));

    setScreenSize(Size(480, verySmallHeight));
    await tester.pumpWidget(flutterLogin);
    await tester.pumpAndSettle(loadingAnimationDuration);
    expect(findLogoImage(), findsNothing);

    // resets the screen to its orinal size after the test end
    addTearDown(() => clearScreenSize());
  });

  // TODO: wait for flutter to add support for testing in web environment on Windows 10
  // https://github.com/flutter/flutter/issues/44583
  // https://github.com/NearHuscarl/flutsign/issues/7
  testWidgets('AnimatedText should be centered in mobile and web consistently',
      (WidgetTester tester) async {
    await tester.pumpWidget(defaultFlutterLogin());
    await tester.pumpAndSettle(loadingAnimationDuration);

    final text = find.byType(AnimatedText).first;
    print(tester.getTopLeft(text));
    print(tester.getCenter(text));
    print(tester.getBottomRight(text));

    expect(true, true);
  });

  testWidgets(
      'hideSignUpButton & hideForgotPasswordButton should hide SignUp and forgot password button',
      (WidgetTester tester) async {
    final loginBuilder = () => widget(FlutSign(
          onSignup: (data) => null,
          onLogin: (data) => null,
          onRecoverPassword: (data) => null,
          passwordValidator: (value) => value!.length == 5 ? null : 'Invalid!',
          hideSignUpButton: true,
          hideForgotPasswordButton: true,
          messages: SignMessages(
            signupButton: 'REGISTER',
            forgotPasswordButton: 'Forgot huh?',
          ),
        ));
    await tester.pumpWidget(loginBuilder());
    await tester.pumpAndSettle(loadingAnimationDuration);
    expect(find.text('REGISTER'), findsNothing);
    expect(find.text('Forgot huh?'), findsNothing);
  });

  testWidgets('LoginProvider buttons should login or throw error.',
      (WidgetTester tester) async {
    final loginBuilder = () => widget(FlutSign(
          onSignup: (data) => null,
          onLogin: (data) => null,
          onRecoverPassword: (data) => null,
          passwordValidator: (value) => value!.length == 5 ? null : 'Invalid!',
          loginProviders: [
            LoginProvider(
              icon: Icons.check,
              callback: () async {
                return 'No problems!';
              },
            ),
            LoginProvider(
              icon: Icons.warning,
              callback: () async {
                return 'Failed to login';
              },
            ),
          ],
        ));
    await tester.pumpWidget(loginBuilder());
    await tester.pumpAndSettle(loadingAnimationDuration);
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byIcon(Icons.warning), findsOneWidget);

    await tester.tap(find.byIcon(Icons.warning));

    // Because of multiple animations, in order to get to the flushbar we need
    // to pump the animations two times.
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('Failed to login'), findsOneWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.check));

    // Because of multiple animations, in order to get to the flushbar we need
    // to pump the animations two times.
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(seconds: 4));
    expect(find.text('No problems!'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('Redirect to login page after sign up.',
      (WidgetTester tester) async {
    final loginBuilder = () => widget(FlutSign(
          loginAfterSignUp: false,
          onSignup: (data) => null,
          onLogin: (data) => null,
          onRecoverPassword: (data) => null,
          passwordValidator: (value) => null,
        ));
    await tester.pumpWidget(loginBuilder());
    await tester.pumpAndSettle(loadingAnimationDuration);

    clickSwitchAuthButton();
    await tester.pumpAndSettle();
    expect(isSignup(tester), true);

    await simulateOpenSoftKeyboard(tester, loginBuilder());
    await tester.enterText(findEmailTextField(), 'near@gmail.com');
    await tester.pumpAndSettle();
    await tester.enterText(findUsernameTextField(), 'username');
    await tester.pumpAndSettle();
    await tester.enterText(findPasswordTextField(), '12345678');
    await tester.pumpAndSettle();
    await tester.enterText(findConfirmPasswordTextField(), '12345678');
    await tester.pumpAndSettle();

    clickSubmitButton();
    await tester.pumpAndSettle();
    expect(isSignup(tester), false);
  });

  testWidgets('Check if footer text is visible.', (WidgetTester tester) async {
    final loginBuilder = () => widget(FlutSign(
        onSignup: (data) => null,
        onLogin: (data) => null,
        onRecoverPassword: (data) => null,
        passwordValidator: (value) => null,
        footer: 'Copyright flutter_login'));
    await tester.pumpWidget(loginBuilder());
    await tester.pumpAndSettle(loadingAnimationDuration);

    expect(find.text('Copyright flutter_login'), findsOneWidget);
  });
}
