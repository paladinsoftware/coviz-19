# frozen_string_literal: true

module Coviz
  class App
    def call(env)
      req = Rack::Request.new(env)
      case req.path_info
      when '/'
        [
          200,
          { 'Content-Type' => 'text/html' },
          [File.read("#{__dir__}/app.html")]
        ]
      when %r{\A/data/(?<type>\w+).json\z}
        dataset = Dataset.get(Regexp.last_match[:type])
        [
          200,
          { 'Content-Type' => 'application/json' },
          [dataset.to_json]
        ]
      else
        [
          404,
          { 'Content-Type' => 'text/plain' },
          ['Not found ;(']
        ]
      end
    end
  end
end
