# frozen_string_literal: true

require 'csv'
require 'date'

module Coviz
  class Dataset
    def self.get(type)
      path = APP_ROOT.join \
        'COVID-19/csse_covid_19_data/csse_covid_19_time_series/' \
        "time_series_covid19_#{type}_global.csv"

      opts = { headers: true, converters: :numeric }
      data = CSV.read(path, **opts).map(&:to_h)
      new(data)
    end

    DATE_PATTERN = %r{\d{1,2}/\d{1,2}/\d{2}}.freeze

    def initialize(data)
      @dates = extract_days(data.first.keys)
      @countries = process(data)
    end

    def to_json
      MultiJson.dump(dates: @dates, countries: @countries)
    end

    def process(data)
      data = sum_by_country(data)
      data.map do |country, d|
        values = d.values_at(*d.keys.grep(DATE_PATTERN))
        population = Population.instance.get(country)
        relatives = values.map do |val|
          next 0 unless population
          1_000_000 * val / population
        end

        {
          country: country,
          population: Population.instance.get(country),
          total: values.last,
          absolutes: values,
          relatives: relatives,
          relatives_aligned: relatives.drop_while(&:zero?)
        }
      end
    end

    def sum_by_country(data)
      data.each_with_object({}) do |d, result|
        country = d['Country/Region']
        if !result[country]
          result[country] = d
        else
          d.keys.grep(DATE_PATTERN).each do |key|
            result[country][key] += d[key]
          end
        end
      end
    end

    def extract_days(keys)
      keys.grep(DATE_PATTERN).map do |d|
        Date.strptime(d, '%m/%d/%y')
      end
    end
  end
end
