import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('el'),
    Locale('en')
  ];

  /// No description provided for @goal.
  ///
  /// In en, this message translates to:
  /// **'goal'**
  String get goal;

  /// No description provided for @incidents.
  ///
  /// In en, this message translates to:
  /// **'Incidents'**
  String get incidents;

  /// No description provided for @expected_goals.
  ///
  /// In en, this message translates to:
  /// **'Expected goals'**
  String get expected_goals;

  /// No description provided for @inv_accept.
  ///
  /// In en, this message translates to:
  /// **'Invitation accept response sent'**
  String get inv_accept;

  /// No description provided for @inv_reject.
  ///
  /// In en, this message translates to:
  /// **'Invitation reject response sent'**
  String get inv_reject;

  /// No description provided for @optout_first.
  ///
  /// In en, this message translates to:
  /// **'You need to opt-out from '**
  String get optout_first;

  /// No description provided for @ball_possession.
  ///
  /// In en, this message translates to:
  /// **'Ball possession'**
  String get ball_possession;

  /// No description provided for @total_shots.
  ///
  /// In en, this message translates to:
  /// **'Total shots'**
  String get total_shots;

  /// No description provided for @shots_on_target.
  ///
  /// In en, this message translates to:
  /// **'Shots on target'**
  String get shots_on_target;

  /// No description provided for @corner_kicks.
  ///
  /// In en, this message translates to:
  /// **'Corner kicks'**
  String get corner_kicks;

  /// No description provided for @offsides.
  ///
  /// In en, this message translates to:
  /// **'Offsides'**
  String get offsides;

  /// No description provided for @yellow_cards.
  ///
  /// In en, this message translates to:
  /// **'Yellow cards'**
  String get yellow_cards;

  /// No description provided for @red_cards.
  ///
  /// In en, this message translates to:
  /// **'Red cards'**
  String get red_cards;

  /// No description provided for @goalkeeper_saves.
  ///
  /// In en, this message translates to:
  /// **'Keeper saves'**
  String get goalkeeper_saves;

  /// No description provided for @hit_woodwork.
  ///
  /// In en, this message translates to:
  /// **'Hit the post'**
  String get hit_woodwork;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'points'**
  String get points;

  /// No description provided for @accept_invitation.
  ///
  /// In en, this message translates to:
  /// **'Accept Invitation'**
  String get accept_invitation;

  /// No description provided for @accept_invitation_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to accept this league invitation?'**
  String get accept_invitation_confirm;

  /// No description provided for @reject_invitation.
  ///
  /// In en, this message translates to:
  /// **'Decline Invitation'**
  String get reject_invitation;

  /// No description provided for @reject_invitation_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to decline this league invitation?'**
  String get reject_invitation_confirm;

  /// No description provided for @buypreds.
  ///
  /// In en, this message translates to:
  /// **'Buy predictions of '**
  String get buypreds;

  /// No description provided for @monthlybetswon.
  ///
  /// In en, this message translates to:
  /// **'Monthly slips won:'**
  String get monthlybetswon;

  /// No description provided for @monthlypredswon.
  ///
  /// In en, this message translates to:
  /// **'Monthly correct predictions:'**
  String get monthlypredswon;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @forgot_pass.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_pass;

  /// No description provided for @tab_fantasy.
  ///
  /// In en, this message translates to:
  /// **'Fantasy'**
  String get tab_fantasy;

  /// No description provided for @tab_predictions.
  ///
  /// In en, this message translates to:
  /// **'Predictions'**
  String get tab_predictions;

  /// No description provided for @tab_invitations.
  ///
  /// In en, this message translates to:
  /// **'Invitations'**
  String get tab_invitations;

  /// No description provided for @tab_past_leagues.
  ///
  /// In en, this message translates to:
  /// **'Past Leagues'**
  String get tab_past_leagues;

  /// No description provided for @status_suspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get status_suspended;

  /// No description provided for @status_postponed.
  ///
  /// In en, this message translates to:
  /// **'Postponed'**
  String get status_postponed;

  /// No description provided for @status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get status_cancelled;

  /// No description provided for @status_delayed.
  ///
  /// In en, this message translates to:
  /// **'Delay'**
  String get status_delayed;

  /// No description provided for @status_will_cont.
  ///
  /// In en, this message translates to:
  /// **'Will cont.'**
  String get status_will_cont;

  /// No description provided for @status_finished.
  ///
  /// In en, this message translates to:
  /// **'FT'**
  String get status_finished;

  /// No description provided for @status_half_time.
  ///
  /// In en, this message translates to:
  /// **'HT'**
  String get status_half_time;

  /// No description provided for @status_half_time_et.
  ///
  /// In en, this message translates to:
  /// **'ET HT'**
  String get status_half_time_et;

  /// No description provided for @status_interrupt.
  ///
  /// In en, this message translates to:
  /// **'Interrupted'**
  String get status_interrupt;

  /// No description provided for @status_more_et.
  ///
  /// In en, this message translates to:
  /// **'ET'**
  String get status_more_et;

  /// No description provided for @status_more_pen.
  ///
  /// In en, this message translates to:
  /// **'Pen.'**
  String get status_more_pen;

  /// No description provided for @status_more_after_et.
  ///
  /// In en, this message translates to:
  /// **'After ET'**
  String get status_more_after_et;

  /// No description provided for @status_more_after_pen.
  ///
  /// In en, this message translates to:
  /// **'After Pen.'**
  String get status_more_after_pen;

  /// No description provided for @status_more_walkover.
  ///
  /// In en, this message translates to:
  /// **'Walkover'**
  String get status_more_walkover;

  /// No description provided for @january.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get january;

  /// No description provided for @february.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get february;

  /// No description provided for @march.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get march;

  /// No description provided for @april.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get april;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @june.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get june;

  /// No description provided for @july.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get july;

  /// No description provided for @august.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get august;

  /// No description provided for @september.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get september;

  /// No description provided for @october.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get october;

  /// No description provided for @november.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get november;

  /// No description provided for @december.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get december;

  /// No description provided for @topup_text.
  ///
  /// In en, this message translates to:
  /// **'The selected credits can be used whenever you like. They will not affect your leaderboard position, until you place a bet (of any odd).'**
  String get topup_text;

  /// No description provided for @extra_leagues_text.
  ///
  /// In en, this message translates to:
  /// **'Unlocking this feature gives you access to up to 10 championships for your fantasy league!'**
  String get extra_leagues_text;

  /// No description provided for @extra_users_text.
  ///
  /// In en, this message translates to:
  /// **'Unlocking this feature allows you to create a fantasy league with up to 10 users!'**
  String get extra_users_text;

  /// No description provided for @topup_explained.
  ///
  /// In en, this message translates to:
  /// **'*When a user has < 10 credits can add-on extra credits for all users in league'**
  String get topup_explained;

  /// No description provided for @i_want_it_text.
  ///
  /// In en, this message translates to:
  /// **'Yes, unlock this!'**
  String get i_want_it_text;

  /// No description provided for @allow_addon.
  ///
  /// In en, this message translates to:
  /// **'Allow add-on'**
  String get allow_addon;

  /// No description provided for @topup_button_text.
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get topup_button_text;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'global pos'**
  String get position;

  /// No description provided for @validation_pending.
  ///
  /// In en, this message translates to:
  /// **'validation pending'**
  String get validation_pending;

  /// No description provided for @all_time_bets.
  ///
  /// In en, this message translates to:
  /// **'All time slips'**
  String get all_time_bets;

  /// No description provided for @all_time_predictions.
  ///
  /// In en, this message translates to:
  /// **'All time predictions'**
  String get all_time_predictions;

  /// No description provided for @max_bet_amount.
  ///
  /// In en, this message translates to:
  /// **'Max bet amount is'**
  String get max_bet_amount;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @place_bet.
  ///
  /// In en, this message translates to:
  /// **'Submit prediction'**
  String get place_bet;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @won.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get won;

  /// No description provided for @lost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get lost;

  /// No description provided for @football.
  ///
  /// In en, this message translates to:
  /// **'Football'**
  String get football;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @password_reset_fail.
  ///
  /// In en, this message translates to:
  /// **'Password reset failed'**
  String get password_reset_fail;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get delete_account;

  /// No description provided for @delete_account_confirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This is irreversible!'**
  String get delete_account_confirm;

  /// No description provided for @slips.
  ///
  /// In en, this message translates to:
  /// **'Slips'**
  String get slips;

  /// No description provided for @preds.
  ///
  /// In en, this message translates to:
  /// **'Preds'**
  String get preds;

  /// No description provided for @returned.
  ///
  /// In en, this message translates to:
  /// **'Ret.'**
  String get returned;

  /// No description provided for @logout_text.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logout_text;

  /// No description provided for @confirm_button_text.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm_button_text;

  /// No description provided for @accept_button_text.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept_button_text;

  /// No description provided for @cancel_button_text.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel_button_text;

  /// No description provided for @decline_button_text.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline_button_text;

  /// No description provided for @view_predictions_text.
  ///
  /// In en, this message translates to:
  /// **'View preds'**
  String get view_predictions_text;

  /// No description provided for @congrats_text.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You finished in position {position} with {credits} credits! You can now view for FREE all the users\' predictions for current month!'**
  String congrats_text(Object position, Object credits);

  /// No description provided for @congrats_text_fantasy.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You finished in position {position} with {credits} credits at league {league}!'**
  String congrats_text_fantasy(Object credits, Object league, Object position);

  /// No description provided for @leaders_previous_month_text.
  ///
  /// In en, this message translates to:
  /// **'Here are the previous month winners! Keep the good work to be able to view all the users\' predictions for free!'**
  String get leaders_previous_month_text;

  /// No description provided for @dont_show_again_checkbox_label.
  ///
  /// In en, this message translates to:
  /// **'don\'t show again'**
  String get dont_show_again_checkbox_label;

  /// No description provided for @out_of.
  ///
  /// In en, this message translates to:
  /// **' out of '**
  String get out_of;

  /// No description provided for @winners.
  ///
  /// In en, this message translates to:
  /// **'Winners'**
  String get winners;

  /// No description provided for @no_pending_bets.
  ///
  /// In en, this message translates to:
  /// **'No pending slips'**
  String get no_pending_bets;

  /// No description provided for @no_lost_bets.
  ///
  /// In en, this message translates to:
  /// **'No lost slips'**
  String get no_lost_bets;

  /// No description provided for @no_won_bets.
  ///
  /// In en, this message translates to:
  /// **'No won slips'**
  String get no_won_bets;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'My stats'**
  String get me;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @leaders.
  ///
  /// In en, this message translates to:
  /// **'Leaders'**
  String get leaders;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @bets.
  ///
  /// In en, this message translates to:
  /// **'My preds'**
  String get bets;

  /// No description provided for @email_verification.
  ///
  /// In en, this message translates to:
  /// **'A verification email has been sent to '**
  String get email_verification;

  /// No description provided for @won_slips.
  ///
  /// In en, this message translates to:
  /// **'Won Slips'**
  String get won_slips;

  /// No description provided for @slips_percent.
  ///
  /// In en, this message translates to:
  /// **'Slips %'**
  String get slips_percent;

  /// No description provided for @credits_with_sign.
  ///
  /// In en, this message translates to:
  /// **'\$ Credits'**
  String get credits_with_sign;

  /// No description provided for @month_preds.
  ///
  /// In en, this message translates to:
  /// **'Month\nPreds'**
  String get month_preds;

  /// No description provided for @overall_preds.
  ///
  /// In en, this message translates to:
  /// **'Total\nPreds'**
  String get overall_preds;

  /// No description provided for @overall_slips.
  ///
  /// In en, this message translates to:
  /// **'Total\nSlips'**
  String get overall_slips;

  /// No description provided for @preds_perc.
  ///
  /// In en, this message translates to:
  /// **'Preds\nPerc'**
  String get preds_perc;

  /// No description provided for @month_roi.
  ///
  /// In en, this message translates to:
  /// **'Month\nROI'**
  String get month_roi;

  /// No description provided for @total_roi.
  ///
  /// In en, this message translates to:
  /// **'Total\nROI'**
  String get total_roi;

  /// No description provided for @leaderboard_info.
  ///
  /// In en, this message translates to:
  /// **'Positions calculated based on ROI (Ratio of returned amount to bet amount). '**
  String get leaderboard_info;

  /// No description provided for @leaderboard_info_pos.
  ///
  /// In en, this message translates to:
  /// **'You currently are in position: '**
  String get leaderboard_info_pos;

  /// No description provided for @login_error.
  ///
  /// In en, this message translates to:
  /// **'Login Error'**
  String get login_error;

  /// No description provided for @login_or_register.
  ///
  /// In en, this message translates to:
  /// **'Please login/register at the top left in order to bet.'**
  String get login_or_register;

  /// No description provided for @login_register.
  ///
  /// In en, this message translates to:
  /// **'Login/Register'**
  String get login_register;

  /// No description provided for @mail_requires_validation.
  ///
  /// In en, this message translates to:
  /// **'Your account requires validation. Please check inbox of '**
  String get mail_requires_validation;

  /// No description provided for @empty_list.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get empty_list;

  /// No description provided for @no_live_games.
  ///
  /// In en, this message translates to:
  /// **'No games'**
  String get no_live_games;

  /// No description provided for @max_selection.
  ///
  /// In en, this message translates to:
  /// **'Max selections size is '**
  String get max_selection;

  /// No description provided for @cannot_place_bet.
  ///
  /// In en, this message translates to:
  /// **'Cannot place bet. Please try again in a while'**
  String get cannot_place_bet;

  /// No description provided for @preds_next_month.
  ///
  /// In en, this message translates to:
  /// **'Cannot place bet. Please select predictions only for current month'**
  String get preds_next_month;

  /// No description provided for @match_in_progress.
  ///
  /// In en, this message translates to:
  /// **'League end date must be before all matches'**
  String get match_in_progress;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action required'**
  String get action;

  /// No description provided for @purchase_error.
  ///
  /// In en, this message translates to:
  /// **'Purchase was not completed'**
  String get purchase_error;

  /// No description provided for @purchase_handling.
  ///
  /// In en, this message translates to:
  /// **'Please wait while we handle your purchase'**
  String get purchase_handling;

  /// No description provided for @possible_earnings.
  ///
  /// In en, this message translates to:
  /// **'Possible earnings: '**
  String get possible_earnings;

  /// No description provided for @login_or_validate.
  ///
  /// In en, this message translates to:
  /// **'Please login or register'**
  String get login_or_validate;

  /// No description provided for @validation_username.
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 5 characters long'**
  String get validation_username;

  /// No description provided for @validation_password_length.
  ///
  /// In en, this message translates to:
  /// **'Password must be between 6 and 12 characters long'**
  String get validation_password_length;

  /// No description provided for @validation_password_number.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get validation_password_number;

  /// No description provided for @validation_password_special.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special char: !@#\$%^&*(),.?:|<>'**
  String get validation_password_special;

  /// No description provided for @validation_invalid_username.
  ///
  /// In en, this message translates to:
  /// **'Invalid username or password'**
  String get validation_invalid_username;

  /// No description provided for @validation_invalid_username_length.
  ///
  /// In en, this message translates to:
  /// **'Username must be between 6 and 18 characters long'**
  String get validation_invalid_username_length;

  /// No description provided for @validation_invalid_username_char.
  ///
  /// In en, this message translates to:
  /// **'Username can only contain letters and numbers'**
  String get validation_invalid_username_char;

  /// No description provided for @validation_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validation_invalid_email;

  /// No description provided for @email_or_username.
  ///
  /// In en, this message translates to:
  /// **'email or username'**
  String get email_or_username;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @betslip_positive_amount.
  ///
  /// In en, this message translates to:
  /// **'Please select a positive amount'**
  String get betslip_positive_amount;

  /// No description provided for @betslip_place_bet.
  ///
  /// In en, this message translates to:
  /// **'Place prediction '**
  String get betslip_place_bet;

  /// No description provided for @betslip_returning.
  ///
  /// In en, this message translates to:
  /// **' returning '**
  String get betslip_returning;

  /// No description provided for @betslip_selections.
  ///
  /// In en, this message translates to:
  /// **' selections to return: '**
  String get betslip_selections;

  /// No description provided for @password_repeat_missmatch.
  ///
  /// In en, this message translates to:
  /// **'your password repeat does not match with original'**
  String get password_repeat_missmatch;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @password_repeat.
  ///
  /// In en, this message translates to:
  /// **'repeat password'**
  String get password_repeat;

  /// No description provided for @password_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get password_reset;

  /// No description provided for @error_own_invite.
  ///
  /// In en, this message translates to:
  /// **'You cannot invite yourself'**
  String get error_own_invite;

  /// No description provided for @error_generic.
  ///
  /// In en, this message translates to:
  /// **'A generic error occurred'**
  String get error_generic;

  /// No description provided for @error_max_pending_inv.
  ///
  /// In en, this message translates to:
  /// **'Too many open invitations for league'**
  String get error_max_pending_inv;

  /// No description provided for @loginRegister.
  ///
  /// In en, this message translates to:
  /// **'Login / Register'**
  String get loginRegister;

  /// No description provided for @createLeague.
  ///
  /// In en, this message translates to:
  /// **'Create League'**
  String get createLeague;

  /// Title of the wizard step where user selects leagues
  ///
  /// In en, this message translates to:
  /// **'Step {step}: Select Leagues'**
  String selectLeaguesStep(Object step);

  /// No description provided for @unlockLeagues.
  ///
  /// In en, this message translates to:
  /// **'Unlock leagues'**
  String get unlockLeagues;

  /// No description provided for @proLeaguesEnabled.
  ///
  /// In en, this message translates to:
  /// **'Pro leagues enabled'**
  String get proLeaguesEnabled;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected:'**
  String get selected;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @pleaseSelectAtLeastOneLeague.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one league.'**
  String get pleaseSelectAtLeastOneLeague;

  /// Toast when user hits max allowed leagues
  ///
  /// In en, this message translates to:
  /// **'Max leagues are {maxLeagues}'**
  String maxLeaguesAre(Object maxLeagues);

  /// No description provided for @purchaseError.
  ///
  /// In en, this message translates to:
  /// **'Purchase error'**
  String get purchaseError;

  /// No description provided for @noProductsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No products available'**
  String get noProductsAvailable;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found {productId}'**
  String productNotFound(Object productId);

  /// No description provided for @youAreOffline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get youAreOffline;

  /// No description provided for @initial_credits.
  ///
  /// In en, this message translates to:
  /// **'Initial credits:'**
  String get initial_credits;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @no_invitations.
  ///
  /// In en, this message translates to:
  /// **'No invitations'**
  String get no_invitations;

  /// No description provided for @no_bets.
  ///
  /// In en, this message translates to:
  /// **'No predictions'**
  String get no_bets;

  /// No description provided for @opt_out_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Opt-Out'**
  String get opt_out_confirm;

  /// No description provided for @opt_out_text.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to opt out of this league? This action cannot be undone!'**
  String get opt_out_text;

  /// No description provided for @opt_out.
  ///
  /// In en, this message translates to:
  /// **'Opt-out'**
  String get opt_out;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @invitations_pend.
  ///
  /// In en, this message translates to:
  /// **'Invitations pending: '**
  String get invitations_pend;

  /// No description provided for @topup_allowed.
  ///
  /// In en, this message translates to:
  /// **'Top-up allowed'**
  String get topup_allowed;

  /// No description provided for @topup_notallowed.
  ///
  /// In en, this message translates to:
  /// **'Top-up not allowed'**
  String get topup_notallowed;

  /// No description provided for @waiting_to_start.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the league to start...'**
  String get waiting_to_start;

  /// No description provided for @invite_email.
  ///
  /// In en, this message translates to:
  /// **'Invite by Email'**
  String get invite_email;

  /// No description provided for @credits.
  ///
  /// In en, this message translates to:
  /// **'Credits: '**
  String get credits;

  /// No description provided for @already_inv.
  ///
  /// In en, this message translates to:
  /// **'This email has already been invited.'**
  String get already_inv;

  /// No description provided for @email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get email_invalid;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @reset_text.
  ///
  /// In en, this message translates to:
  /// **'Password reset mail sent to '**
  String get reset_text;

  /// No description provided for @step3_dates.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Select Dates'**
  String get step3_dates;

  /// No description provided for @step3_start_date.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get step3_start_date;

  /// No description provided for @step3_end_date.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get step3_end_date;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get no;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Prediction placed'**
  String get done;

  /// No description provided for @enter_amount.
  ///
  /// In en, this message translates to:
  /// **'Select amount'**
  String get enter_amount;

  /// No description provided for @reset_pass_error.
  ///
  /// In en, this message translates to:
  /// **'Could not reset password'**
  String get reset_pass_error;

  /// No description provided for @step2_leagues.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Select Leagues'**
  String get step2_leagues;

  /// No description provided for @step2_unlock_leagues.
  ///
  /// In en, this message translates to:
  /// **'Unlock extra leagues'**
  String get step2_unlock_leagues;

  /// No description provided for @step2_pro_leagues_on.
  ///
  /// In en, this message translates to:
  /// **'Pro leagues enabled'**
  String get step2_pro_leagues_on;

  /// No description provided for @step1_league_name.
  ///
  /// In en, this message translates to:
  /// **'Step 1: League Name'**
  String get step1_league_name;

  /// No description provided for @step1_select_league.
  ///
  /// In en, this message translates to:
  /// **'League Name'**
  String get step1_select_league;

  /// No description provided for @step4_league_settings.
  ///
  /// In en, this message translates to:
  /// **'Step 4: League Settings'**
  String get step4_league_settings;

  /// No description provided for @onboard1.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Login or create a new account to enable FantasyLeagues!'**
  String get onboard1;

  /// No description provided for @onboard2.
  ///
  /// In en, this message translates to:
  /// **'Step 2: After login you can create your own FantasyLeague!'**
  String get onboard2;

  /// No description provided for @onboard3.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Select the soccer Leagues you want to make tips on!'**
  String get onboard3;

  /// No description provided for @onboard4.
  ///
  /// In en, this message translates to:
  /// **'Step 4: Select the virtual amount you want to start with. Allow add ons when someone zeroes his balance!'**
  String get onboard4;

  /// No description provided for @onboard5.
  ///
  /// In en, this message translates to:
  /// **'Step 5: Start inviting your friends into your new FantasyLeague!'**
  String get onboard5;

  /// No description provided for @onboard6.
  ///
  /// In en, this message translates to:
  /// **'Step 6: Now you can start competing with your friends!'**
  String get onboard6;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to FantasyTips'**
  String get welcome;

  /// No description provided for @run_this.
  ///
  /// In en, this message translates to:
  /// **'flutter gen-l10n'**
  String get run_this;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['el', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el': return AppLocalizationsEl();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
