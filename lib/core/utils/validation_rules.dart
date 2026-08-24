class ValidationRules {
  String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "NAME_IS_REQUIRED";
    }
    return null;
  }

  String? fullname(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "FULL_NAME_IS_REQUIRED";
    }
    return null;
  }

  String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "PHONE_IS_REQUIRED";
    }
    return null;
  }

  String? otp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "OTP_IS_REQUIRED";
    }
    return null;
  }

  String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "EMAIL_IS_REQUIRED";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return "ENTER_A_VALID_EMAIL";
    }

    return null;
  }

  String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "PASSWORD_IS_REQUIRED";
    }

    if (value.length < 6) {
      return "PASSWORD_MUST_BE_AT_LEAST_6_CHARACTERS";
    }

    return null;
  }
}
