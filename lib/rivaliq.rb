require 'rivaliq/version'
require 'httparty'

# Create RivalIQ module
module RivalIQ
  include HTTParty
  API_URL = 'https://www.rivaliq.com/api/v1/landscapes'.freeze

  def self.key_set(key)
    @key = key
  end

  def self.response_format_set(response_format = nil)
    @format = response_format ? response_format : 'json'
  end

  def self.landscape_names
    get(API_URL, query: { apiKey: @key })
      .parsed_response['landscapes'].map { |ls| ls['name'] }
  end

  def self.landscape_ids
    get(API_URL, query: { apiKey: @key })
      .parsed_response['landscapes'].map { |ls| ls['id'] }
  end

  def self.summary(id, start, stop, options = {})
    get("#{API_URL}/#{id}/metrics/summary",
        query: {
          apiKey: @key,
          mainPeriodStart: start,
          mainPeriodEnd: stop,
          comparePeriodStart: options[:comp_start],
          comparePeriodEnd: options[:comp_stop],
          channel: options[:channel] ? options[:channel] : 'all'
        }).parsed_response['metrics']
  end

  def self.time_series(id, start, stop, options = {})
    get("#{API_URL}/#{id}/metrics/timeSeries",
        query: {
          apiKey: @key,
          mainPeriodStart: start,
          mainPeriodEnd: stop,
          channel: options[:channel] ? options[:channel] : 'all'
        }).parsed_response['metrics']
  end

  def self.position(id, options = {})
    get("#{API_URL}/#{id}/positioning/current",
        query: {
          apiKey: @key,
          channel: options[:channel] ? options[:channel] : 'all'
        }).parsed_response['metrics']
  end

  def self.social_posts(id, start, stop, options = {})
    get("#{API_URL}/#{id}/socialPosts",
        query: {
          apiKey: @key,
          mainPeriodStart: start,
          mainPeriodEnd: stop,
          channel: options[:channel] ? options[:channel] : 'all',
          searchTerm: options[:searchTerm],
          order: options[:order],
          direction: options[:direction],
          postType: options[:postType],
          limit: options[:limit]
        })
  end
end
