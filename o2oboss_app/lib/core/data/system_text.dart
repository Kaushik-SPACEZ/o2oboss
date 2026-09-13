/// System chat messages and a few stored notes are saved as short codes
/// (`@key|arg1|arg2`) so they can be shown in each reader's own language.
abstract final class SystemText {
  static String encode(String key, [List<String> args = const []]) =>
      ['@$key', ...args].join('|');

  static (String key, List<String> args)? decode(String? text) {
    if (text == null || !text.startsWith('@')) return null;
    final parts = text.substring(1).split('|');
    return (parts.first, parts.skip(1).toList());
  }

  static const assigned = 'assigned'; // enquiryId, vendor
  static const newReferral = 'newReferral'; // enquiryId, hours
  static const referralAccepted = 'referralAccepted'; // vendor
  static const referralRejected = 'referralRejected'; // vendor
  static const connected = 'connected'; // vendor
  static const appointmentProposed = 'appointmentProposed'; // iso date
  static const appointmentConfirmed = 'appointmentConfirmed'; // iso date
  static const appointmentRescheduled = 'appointmentRescheduled'; // iso date
  static const appointmentCancelled = 'appointmentCancelled';
  static const appointmentCompleted = 'appointmentCompleted';
  static const quotationSubmitted = 'quotationSubmitted'; // number, version
  static const quotationSent = 'quotationSent'; // number, version
  static const revisionRequested = 'revisionRequested'; // number
  static const quotationAccepted = 'quotationAccepted'; // number
  static const quotationRejected = 'quotationRejected'; // number
  static const projectCreated = 'projectCreated'; // project id
  static const enquiryLost = 'enquiryLost';
  static const otherAccepted = 'otherAccepted';
}
