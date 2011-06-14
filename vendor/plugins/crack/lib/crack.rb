module Crack
  VERSION = "0.1.7".freeze
  class ParseError < StandardError; end
end

require 'crack/core_extensions'
require 'crack/json'
require 'crack/xml'
