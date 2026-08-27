// Smoke tests for the CookIN app shell and the on-boarding -> login flow.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

import 'package:cookin/common/auth_service.dart';
import 'package:cookin/common/cart_service.dart';
import 'package:cookin/common/food_data.dart';
import 'package:cookin/common/order_history_service.dart';
import 'package:cookin/common_widget/round_button.dart';
import 'package:cookin/common_widget/round_textfield.dart';
import 'package:cookin/main.dart';
import 'package:cookin/view/home/cart_view.dart';
import 'package:cookin/view/home/food_detail_view.dart';
import 'package:cookin/view/home/home_view.dart';
import 'package:cookin/view/login/login_view.dart';
import 'package:cookin/view/login/new_password_view.dart';
import 'package:cookin/view/login/otp_view.dart';
import 'package:cookin/view/login/reset_password_view.dart';
import 'package:cookin/view/login/sign_up_view.dart';
import 'package:cookin/view/login/welcome_view.dart';
import 'package:cookin/view/main_tabview/main_tabview.dart';
import 'package:cookin/view/main_tabview/menu_view.dart';
import 'package:cookin/view/main_tabview/more_view.dart';
import 'package:cookin/view/main_tabview/offer_view.dart';
import 'package:cookin/view/main_tabview/profile_view.dart';
import 'package:cookin/view/on_boarding/on_boarding_view.dart';
import 'package:cookin/view/on_boarding/startup_view.dart';

/// The screens are designed for a phone, so test them on a phone-sized surface
/// rather than the 800x600 default.
void usePhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(430, 932);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// SnackBars live on the app-level ScaffoldMessenger and don't reliably
/// clear themselves within a test's virtual time, so a stale one can mask
/// the next one queued behind it. Clear it explicitly between assertions.
void clearSnackBars(WidgetTester tester) {
  ScaffoldMessenger.of(tester.element(find.byType(Scaffold).first))
      .clearSnackBars();
}

void main() {
  setUp(() {
    CartService.instance.clear();
    OrderHistoryService.instance.clear();
    AuthService.instance.reset();
  });

  testWidgets('app starts on the splash screen', (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MyApp());

    expect(find.byType(StartupView), findsOneWidget);

    // Let the splash timer fire so the test ends with no pending timers.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('splash moves on to on-boarding', (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MyApp());

    // The splash waits 3 seconds before routing on.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.byType(StartupView), findsNothing);
    expect(find.byType(OnBoardingView), findsOneWidget);
  });

  testWidgets('on-boarding shows its first page and a Next button',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: OnBoardingView()));
    await tester.pumpAndSettle();

    expect(find.text('Find Food You Love'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });

  testWidgets('Next advances through the on-boarding pages',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: OnBoardingView()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Fast Delivery'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Live Tracking'), findsOneWidget);

    // The last page swaps the label so the user knows the flow ends here.
    expect(find.text('Get Started'), findsOneWidget);
  });

  testWidgets('Get Started opens the welcome screen',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: OnBoardingView()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeView), findsOneWidget);
    expect(find.text('Create an Account'), findsOneWidget);
  });

  testWidgets('welcome -> login -> home tabs', (WidgetTester tester) async {
    usePhoneSurface(tester);
    AuthService.instance.register(
      name: 'Akila',
      phone: '0710000000',
      address: '1 Main St',
      email: 'akila@example.com',
      password: 'password1',
      confirmPassword: 'password1',
    );

    await tester.pumpWidget(const MaterialApp(home: WelcomeView()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginView), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Your Email'),
        'akila@example.com');
    await tester.enterText(
        find.widgetWithText(RoundTextfield, ' Password'), 'password1');

    // The login screen's own Login button lands on the main tab shell.
    await tester.tap(find.widgetWithText(RoundButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.byType(MainTabView), findsOneWidget);

    // Home is the default tab and its content should be visible immediately.
    expect(find.text('Good morning Akila!'), findsOneWidget);
  });

  testWidgets('Login rejects a wrong password with a clear error',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    AuthService.instance.register(
      name: 'Akila',
      phone: '0710000000',
      address: '1 Main St',
      email: 'akila@example.com',
      password: 'password1',
      confirmPassword: 'password1',
    );

    await tester.pumpWidget(const MaterialApp(home: LoginView()));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Your Email'),
        'akila@example.com');
    await tester.enterText(
        find.widgetWithText(RoundTextfield, ' Password'), 'wrongpass');
    await tester.tap(find.widgetWithText(RoundButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Incorrect password'), findsOneWidget);
    expect(find.byType(LoginView), findsOneWidget);
  });

  testWidgets('Login rejects an email with no account',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: LoginView()));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Your Email'),
        'nobody@example.com');
    await tester.enterText(
        find.widgetWithText(RoundTextfield, ' Password'), 'password1');
    await tester.tap(find.widgetWithText(RoundButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('No account found for this email. Please sign up.'),
        findsOneWidget);
  });

  testWidgets('every bottom tab shows its own real content',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: MainTabView()));
    await tester.pumpAndSettle();

    expect(find.text('Good morning Akila!'), findsOneWidget);

    await tester.tap(find.text('Menu'));
    await tester.pumpAndSettle();
    expect(find.byType(MenuView), findsOneWidget);
    expect(find.text('Search the menu'), findsOneWidget);

    await tester.tap(find.text('Offer'));
    await tester.pumpAndSettle();
    expect(find.byType(OfferView), findsOneWidget);
    expect(find.text("Today's Offers"), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileView), findsOneWidget);
    expect(find.text('Your Orders'), findsOneWidget);

    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.byType(MoreView), findsOneWidget);
    expect(find.text('Log Out'), findsOneWidget);
  });

  testWidgets('Menu tab search filters the catalogue',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: MenuView()));
    await tester.pumpAndSettle();

    expect(find.text('Barita'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'barita');
    await tester.pumpAndSettle();

    expect(find.text('Barita'), findsOneWidget);
    expect(find.text('Bakes by Tella'), findsNothing);
  });

  testWidgets('Offer tab lists only discounted items and opens detail',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: OfferView()));
    await tester.pumpAndSettle();

    // Every item on this screen must actually be discounted.
    for (final item in FoodData.offers) {
      expect(find.text(item.name), findsOneWidget);
    }
    expect(find.text('Bakes by Tella'), findsNothing);

    await tester.tap(find.text(FoodData.offers.first.name));
    await tester.pumpAndSettle();
    expect(find.byType(FoodDetailView), findsOneWidget);
  });

  testWidgets('Profile shows order history after an order is placed',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    CartService.instance
        .add('History Test Dish', 'assets/img/item_1.png', 5.0);
    OrderHistoryService.instance.add(Order(
      items: List.of(CartService.instance.value),
      total: CartService.instance.total,
      placedAt: DateTime(2026, 1, 1, 12, 30),
    ));
    CartService.instance.clear();

    await tester.pumpWidget(const MaterialApp(home: ProfileView()));
    await tester.pumpAndSettle();

    expect(find.text('History Test Dish'), findsOneWidget);
    expect(find.text('\$5.00'), findsOneWidget);
  });

  testWidgets('Log Out from Profile returns to the welcome screen',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: ProfileView()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(RoundButton, 'Log Out'));
    await tester.pumpAndSettle();

    expect(find.byType(WelcomeView), findsOneWidget);
    expect(find.byType(ProfileView), findsNothing);
  });

  // The OTP field's blinking cursor is a never-ending repeating animation,
  // so pumpAndSettle would hang forever while OtpView is on screen. Use a
  // single bounded pump instead whenever OtpView is still mounted.

  testWidgets('OTP Next refuses an incomplete code',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: OtpView()));
    await tester.pump();

    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Please enter the 4-digit OTP'), findsOneWidget);
    expect(find.byType(OtpView), findsOneWidget);
  });

  testWidgets('OTP Next with a full code goes to login',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: OtpView()));
    await tester.pump();

    await tester.enterText(
        find.descendant(
            of: find.byType(OtpPinField), matching: find.byType(TextField)),
        '1234');
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);
  });

  testWidgets('Sign Up refuses invalid details and never reaches OTP',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: SignUpView()));
    await tester.pumpAndSettle();

    // Every field left empty - should be rejected before OTP.
    await tester.tap(find.widgetWithText(RoundButton, 'Sign Up'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.byType(OtpView), findsNothing);
  });

  testWidgets('sign up -> OTP -> login is fully wired end to end',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: SignUpView()));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Name'), 'Nadia');
    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Phone No'), '0711234567');
    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Address'), '221B Baker St');
    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Email'), 'nadia@example.com');
    await tester.enterText(
        find.widgetWithText(RoundTextfield, ' Password'), 'password1');
    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Confirm Password'), 'password1');

    await tester.tap(find.widgetWithText(RoundButton, 'Sign Up'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byType(OtpView), findsOneWidget);

    await tester.enterText(
        find.descendant(
            of: find.byType(OtpPinField), matching: find.byType(TextField)),
        '1234');
    await tester.pump();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);

    // The new account should actually be able to log in with it.
    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Your Email'),
        'nadia@example.com');
    await tester.enterText(
        find.widgetWithText(RoundTextfield, ' Password'), 'password1');
    await tester.tap(find.widgetWithText(RoundButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.byType(MainTabView), findsOneWidget);
  });

  testWidgets('Reset Password refuses an email with no account',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: ResetPasswordView()));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Your Email'),
        'nobody@example.com');
    await tester.tap(find.widgetWithText(RoundButton, 'Send'));
    await tester.pumpAndSettle();

    expect(find.text('No account found for this email'), findsOneWidget);
    expect(find.byType(NewPasswordView), findsNothing);
  });

  testWidgets('forgot password -> reset -> new password -> login',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    AuthService.instance.register(
      name: 'Akila',
      phone: '0710000000',
      address: '1 Main St',
      email: 'akila@example.com',
      password: 'oldpass1',
      confirmPassword: 'oldpass1',
    );

    await tester.pumpWidget(const MaterialApp(home: ResetPasswordView()));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Your Email'),
        'akila@example.com');
    await tester.tap(find.widgetWithText(RoundButton, 'Send'));
    await tester.pumpAndSettle();
    expect(find.byType(NewPasswordView), findsOneWidget);

    // Mismatched passwords should not navigate anywhere.
    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'New Password').first, 'abc123');
    await tester.tap(find.widgetWithText(RoundButton, 'Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text("Passwords don't match"), findsOneWidget);
    expect(find.byType(NewPasswordView), findsOneWidget);
    clearSnackBars(tester);
    await tester.pump();

    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Confirm Password'), 'abc123');
    await tester.tap(find.widgetWithText(RoundButton, 'Next'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);

    // The password should genuinely be updated - old password now fails,
    // new one works.
    await tester.enterText(
        find.widgetWithText(RoundTextfield, 'Your Email'),
        'akila@example.com');
    await tester.enterText(
        find.widgetWithText(RoundTextfield, ' Password'), 'oldpass1');
    await tester.tap(find.widgetWithText(RoundButton, 'Login'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Incorrect password'), findsOneWidget);
    clearSnackBars(tester);
    await tester.pump();

    await tester.enterText(
        find.widgetWithText(RoundTextfield, ' Password'), 'abc123');
    await tester.tap(find.widgetWithText(RoundButton, 'Login'));
    await tester.pumpAndSettle();
    expect(find.byType(MainTabView), findsOneWidget);
  });

  testWidgets('tapping a food item opens its detail page with a price',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: HomeView()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Minute by tuk tuk').first);
    await tester.pumpAndSettle();

    expect(find.byType(FoodDetailView), findsOneWidget);
    expect(find.textContaining('Add to Cart'), findsOneWidget);
  });

  testWidgets('adding to cart updates the home page cart badge',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: HomeView()));
    await tester.pumpAndSettle();

    expect(find.text('1'), findsNothing);

    await tester.tap(find.text('Minute by tuk tuk').first);
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Add to Cart'));
    await tester.pumpAndSettle();

    // Back on the home page, the cart badge should now show 1 item.
    expect(find.byType(HomeView), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('cart page lists items, updates total, and places an order',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    CartService.instance.add('Test Burger', 'assets/img/item_1.png', 10.0);

    // Open the cart the way a real user does - pushed from Home - since
    // "Place Order" pops back to whatever is beneath the cart on the stack.
    await tester.pumpWidget(const MaterialApp(home: HomeView()));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(find.byType(CartView), findsOneWidget);

    expect(find.text('Test Burger'), findsOneWidget);
    // Per-item price and the total both read "$10.00" while quantity is 1.
    expect(find.text('\$10.00'), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);
    expect(find.text('\$20.00'), findsOneWidget);

    await tester.tap(find.widgetWithText(RoundButton, 'Place Order'));
    await tester.pumpAndSettle();

    expect(find.text('Order placed!'), findsOneWidget);
    expect(CartService.instance.value, isEmpty);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Both the dialog and the cart page itself pop, landing back on Home.
    expect(find.byType(CartView), findsNothing);
    expect(find.byType(HomeView), findsOneWidget);
  });

  testWidgets('empty cart shows a friendly placeholder',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: CartView()));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
  });

  testWidgets('category and view-all taps acknowledge instead of doing nothing',
      (WidgetTester tester) async {
    usePhoneSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: HomeView()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Offers'));
    await tester.pumpAndSettle();
    expect(find.textContaining('coming soon'), findsOneWidget);

    await tester.tap(find.text('View all').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('coming soon'), findsOneWidget);
  });
}
