class ValidationRules {
  String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    return null;
  }

  String? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Full name is required";
    }
    return null;
  }

  String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }
    return null;
  }

  String? otp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "OTP is required";
    }
    return null;
  }

  String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email";
    }

    return null;
  }

  String? password(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }

    return null;
  }

  String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }

    if (value != password) {
      return "Passwords do not match";
    }

    return null;
  }
}