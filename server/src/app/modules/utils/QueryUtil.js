class QueryUtil {
  static toArray (queryString) {
    if (!queryString) {
      return []
    }

    return queryString.split(',')
  }
}

module.exports = QueryUtil
