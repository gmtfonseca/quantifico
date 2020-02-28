class TimeUtil {
  // solução bruteforce, podemos usar momentjs depois
  static secondsToDate (seconds) {
    const now = new Date()
    const dateTimeUtc = new Date(Number(seconds) * 1000)
    const dateTimeLocal = new Date(dateTimeUtc - (now.getTimezoneOffset() * 60000))
    return dateTimeLocal
  }
}

module.exports = TimeUtil
