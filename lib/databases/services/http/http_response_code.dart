bool httpSuccessCode(int statusCode) {
  if ((statusCode == 200) || (statusCode == 201)) {
    return true;
  }
  return false;
}
