require "actindi/kintai_summary/version"
require 'date'

module Actindi
  module KintaiSummary
    class Parser
      class Line
        def initialize(line)
          @line = line
        end

        def day
          binding.pry
          @line =~ %r!^(\d{4}/\d{2}/\d{2})!
          Date.parse($1)
        end
      end

      def initialize(text)
        @line_list = []
        text.split("\n").each do |text_line|
          @line_list << Line.new(text_line)
        end
      end

      def left_time
        @line_list.left_time
      end

      def over_time
      end

      def over_time?
      end

      def current_time
      end
    end

    def self.parse(text)
      Parser.new(text)
    end
  end
end
