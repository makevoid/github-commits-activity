require 'bundler'
require 'time'

Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8

Bundler.require :default

path = File.expand_path '../', __FILE__
PATH = path
APP_PATH = PATH

# TODO: you need to configure this token or pass it as an environment variable
default_github_token = nil

GITHUB_TOKEN = default_github_token || ENV["GITHUB_TOKEN"]

require "graphql/client/http"

require_relative 'lib/cache'
require_relative 'lib/gh'
