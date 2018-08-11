module DocumentsHelper

  # Truncate a string so it doesn't exceed specified length and also append '...'
  # @param str [String] string to truncate
  # @param length [Fixnum] target length
  # @return [String] truncated string
  def truncate(str, length)
    return str if str.length <= length
    # Rails truncate method (String.truncate(length)) has a bug with Unicode handling, so we don't want to use it here
    part = str.each_grapheme_cluster.take(length + 1)
    return str if part.length <= length

    omission = '.' * [3, length].min

    part.take(length - omission.length).join + omission
  end
end
