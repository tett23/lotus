class FilterRegexp < ActiveRecord::Base
  enum target: [
    :filename,
    :description,
    :program
  ]

  def self.list(options={})
    self.all().order(updated_at: :desc)
  end

  def name
    "#{self.regexp}, #{self.alter}"
  end

  def to_regexp
    Regexp.new(self.regexp)
  end

  private
  def check_valid_regexp
    Regexp.new(self.regexp) rescue [false, '妥当な正規表現でない']

    true
  end

  def check_target_and_regexp
    aleady_exest = FilterRegexp.get(
      target: self.target,
      regexp: self.regexp
    )

    return true if aleady_exest.blank?

    [false, 'すでに存在するルール']
  end
end
