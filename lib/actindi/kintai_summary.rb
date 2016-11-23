require "actindi/kintai_summary/version"
require 'date'

module Actindi
  module KintaiSummary
    class Parser
      class WorkingDay
        def initialize(line)
          @line = line
        end

        def to_date
          Date.new(*to_date_with_array)
        end

        def to_date_with_format
          to_date.strftime("%m/%d(#{week_names[to_date.wday]})")
        end

        def to_date_with_array
          %r!^(\d{4}/\d{2}/\d{2})! =~ @line
          $1.split(/\//).map(&:to_i)
        end

        def sections
          sections_to_s.map { |start_time, end_time|
            [Time.new(*to_date_with_array, start_time), Time.new(*to_date_with_array, end_time)]
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

        def embedded_worked_hours(to_i: true)
          if break_time(to_i: false) && \
            /(#{time_regexp_format})\t(#{time_regexp_format})/ =~ meta_text
            to_i ? $2.to_i : $2
          else
             /(#{time_regexp_format})/ =~ meta_text
            to_i ? $1.to_i : $1
          end
        end

        def worked_hours
          local_working_hour = sections.map { |start_time, end_time|
            (end_time - start_time) / 3600 # to_hoor
          }.inject(:+) || 0
          local_working_hour - break_time
        end

        def comment
          if /#{embedded_worked_hours(to_i: false)}(.+)/ =~ meta_text
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

        def paid_holiday?
          meta_text.include?('有給')
        end

        def holiday?
          /\t.?1.?\t#{Regexp.union(week_names)}/ === @line
        end

        def should_working_day?
          !(holiday? || paid_holiday?)
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
        @list = []
        text.split(/\r\n|\n/).each do |text_line|
          @list << WorkingDay.new(text_line)
        end
      end

      def left_average_working_hours
        left_working_hours_from_now / future_list.size.to_f
      end

      def average_worked_hours
        worked_hours / past_list.size.to_f
      end

      def should_working_hours_of_month
        should_working_days_of_month.size * should_working_hours_of_day
      end

      def should_working_days_of_month
        @list.select(&:should_working_day?)
      end

      def left_working_hours_from_now
        should_working_hours_of_month - worked_hours
      end

      def left_working_days
        future_list.size
      end

      def worked_hours
        past_list.map(&:worked_hours).inject(&:+)
      end

      def past_list
        today = Date.today
        @list.select(&:should_working_day?).select { |working_day|
          working_day.to_date < today
        }
      end

      def future_list
        (@list - past_list).select(&:should_working_day?)
      end

      def find(yyyy_mm_dd)
        @list.find { |x| x.to_date == Date.parse(yyyy_mm_dd) }
      end

      def find(yyyy_mm_dd)
        @list.find { |x| x.to_date == Date.parse(yyyy_mm_dd) }
      end

      def paid_holidays
        @list.select(&:paid_holiday?)
      end

      def list
        @list
      end

      private

      def should_working_hours_of_day
        8
      end
    end

    def self.parse(text)
      Parser.new(text)
    end
  end
end
