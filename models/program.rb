class Program < ActiveRecord::Base
  class << self
    def search(start_at: nil, end_at: nil, channel_name: nil)
      channel_name_like = channel_name.gsub('　', ' ').gsub(/\d+$/, '') + "%"

      self.where(start_at: start_at, end_at: end_at).where('channel_name LIKE ?', channel_name_like).first
    end
  end
end
