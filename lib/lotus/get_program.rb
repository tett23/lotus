module Lotus
  class GetProgram
    def initialize
    end

    def fetch
      connection = Faraday.new(url: 'http://cal.syoboi.jp') do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end

      response = connection.get('rss2.php', query)
      raise '' unless response.status == 200

      JSON.parse(response.body)['items'].each do |item|
        episode_name = item['SubTitle'].nil? ? nil : item['SubTitle'].first(255)
        program = Program.where({
          start_at: Time.at(item['StTime'].to_i),
          end_at: Time.at(item['EdTime'].to_i),
          title: item['Title'],
          episode_name: episode_name,
          count: item['Count'].to_i,
          channel_name: item['ChName'],
          channel_id: item['ChID'].to_i,
        }).first_or_create()
        program.save()

        last_updated_at = item['LastUpdate'].to_i
        if program.last_updated_at.nil? or not(program.last_updated_at.localtime.to_time.to_i == last_updated_at)
          program.update(last_updated_at: Time.at(last_updated_at))
        end
      end
    end

    private
    def query(start_on: nil, end_on: nil)
      {
        start: (start_on || Time.now.beginning_of_day-2.day).strftime('%Y%m%d%H%M'),
        end: (end_on || Time.now.beginning_of_day+6.day).strftime('%Y%m%d%H%M'),
        count: 1000,
        titlefmt: '$(Title),$(Count),$(SubTitleA),$(PID),$(ChName)',
        alt: 'json'
      }
    end
  end
end
