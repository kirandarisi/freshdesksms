# Copyright (c) 2004-2008 David Heinemeier Hansson
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'yaml'
require 'strscan'

module Crack
  class JSON
    def self.parse(json)
      YAML.load(convert_json_to_yaml(json))
    rescue ArgumentError => e
      raise ParseError, "Invalid JSON string"
    end

    protected
      # matches YAML-formatted dates
      DATE_REGEX = /^\d{4}-\d{2}-\d{2}$|^\d{4}-\d{1,2}-\d{1,2}[T \t]+\d{1,2}:\d{2}:\d{2}(\.[0-9]*)?(([ \t]*)Z|[-+]\d{2}?(:\d{2})?)?$/

      # Ensure that ":" and "," are always followed by a space
      def self.convert_json_to_yaml(json) #:nodoc:
        scanner, quoting, marks, pos, times = StringScanner.new(json), false, [], nil, []
        while scanner.scan_until(/(\\['"]|['":,\\]|\\.)/)
          case char = scanner[1]
          when '"', "'"
            if !quoting
              quoting = char
              pos = scanner.pos
            elsif quoting == char
              if json[pos..scanner.pos-2] =~ DATE_REGEX
                # found a date, track the exact positions of the quotes so we can
                # overwrite them with spaces later.
                times << pos << scanner.pos
              end
              quoting = false
            end
          when ":",","
            marks << scanner.pos - 1 unless quoting
          when "\\"
            scanner.skip(/\\/)
          end
        end

        if marks.empty?
          json.gsub(/\\([\\\/]|u[[:xdigit:]]{4})/) do
            ustr = $1
            if ustr.start_with?('u')
              [ustr[1..-1].to_i(16)].pack("U")
            elsif ustr == '\\'
              '\\\\'
            else
              ustr
            end
          end
        else
          left_pos  = [-1].push(*marks)
          right_pos = marks << scanner.pos + scanner.rest_size
          output    = []
          left_pos.each_with_index do |left, i|
            scanner.pos = left.succ
            chunk = scanner.peek(right_pos[i] - scanner.pos + 1)
            # overwrite the quotes found around the dates with spaces
            while times.size > 0 && times[0] <= right_pos[i]
              chunk[times.shift - scanner.pos - 1] = ' '
            end
            chunk.gsub!(/\\([\\\/]|u[[:xdigit:]]{4})/) do
              ustr = $1
              if ustr.start_with?('u')
                [ustr[1..-1].to_i(16)].pack("U")
              elsif ustr == '\\'
                '\\\\'
              else
                ustr
              end
            end
            output << chunk
          end
          output = output * " "

          output.gsub!(/\\\//, '/')
          output
        end
      end
  end
end
