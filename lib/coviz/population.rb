# frozen_string_literal: true

require 'csv'
require 'singleton'
module Coviz
  class Population
    include Singleton

    def initialize
      path = APP_ROOT.join 'data/population.csv'
      opts = { headers: true, converters: :numeric }
      @data = CSV.read(path, **opts).map(&:to_h)
    end

    def get(country)
      record = @data.detect { |d| match?(d['country'], country) }
      return unless record
      record.fetch('population')
    end

    def match?(name1, name2)
      n1 = name1.downcase.strip
      n2 = name2.downcase.strip
      n1 == n2
    end
  end
end
