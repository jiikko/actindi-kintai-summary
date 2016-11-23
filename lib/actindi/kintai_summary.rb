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
          %r!^(\d{4}/\d{2}/\d{2})! =~ @line
          $1.split(/\//)
        end

        def sections
          sections_to_s.map { |start_time, end_time|
            [Time.new(*day, start_time), Time.new(*day, end_time)]
          }
        end

        def break_time(to_i: true)
          if /(#{time_regexp_format})\t(#{time_regexp_format})/ =~ meta_text
            to_i ? $1.to_i : $1
          else
            # 一致しない場合、休憩が未入力ということにする
            to_i ? 0 : nil
          end
        end

        def embedded_working_hour(to_i: true)
          if break_time(to_i: false) && \
            /(#{time_regexp_format})\t(#{time_regexp_format})/ =~ meta_text
            to_i ? $2.to_i : $2
          else
             /(#{time_regexp_format})/ =~ meta_text
            to_i ? $1.to_i : $1
          end
        end

        def working_hour
          local_working_hour = sections.map { |start_time, end_time|
            (end_time - start_time) / 3600 # to_hoor
          }.inject(:+) || 0
          local_working_hour - break_time
        end

        def comment
          if /#{embedded_working_hour(to_i: false)}(.+)/ =~ meta_text
            $1.strip
          end
        end

        def times_text
          @line.split(Regexp.union(week_names)).last
        end

        def meta_text
          if sections_to_s.empty?
            times_text.strip
          else
            break_time_sign = sections_to_s.last.last
            /#{break_time_sign}(.+)/ =~ times_text
            $1
          end
        end

        def vacatin?
          meta_text.include?('有給')
        end

        def holiday?
          /\t.?1.?\t#{Regexp.union(week_names)}/ === @line
        end

        def working_day?
          !(holiday? || vacatin?)
        end

        private

        def sections_to_s
          prev_end_time = nil
          times_text.scan(/#{time_regexp_format}\t#{time_regexp_format}/).inject([]) { |a, string_time|
            start_time = string_time.split("\t").first
            end_time = string_time.split("\t").last
            if prev_end_time && prev_end_time.to_i > end_time.to_i
              break(a)
            else
              prev_end_time = end_time
              a << [start_time, end_time]
            end
          }
        end

        def time_regexp_format
          '\d{1,2}:\d{1,2}'
        end

        def week_names
          %w(日 月 火 水 木 金 土)
        end
      end

      def initialize(text)
        @line_list = []
        text.split(/\r\n|\n/).each do |text_line|
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

      def current_working_hour
        @line_list.map { |line| line.working_hour }.inject(:+)
      end

      def should_working_hour
        @line_list.select { |line| line.working_day? }.size * working_hour_of_day
      end

      def working_hour_of_day
        8
      end
    end

    def self.parse(text)
      Parser.new(text)
    end
  end
end
