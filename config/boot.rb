# frozen_string_literal: true

require 'pathname'
APP_ENV = ENV.fetch('RACK_ENV', 'development')
APP_ROOT = Pathname.new(__dir__).join('../')

require 'rubygems'
require 'bundler/setup'

Bundler.require(:default, APP_ENV)
