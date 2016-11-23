# Actindi::KintaiSummary


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'actindi-kintai_summary'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install actindi-kintai_summary

## Usage
```ruby
$ cat kintai
2016/11/01	 11 		火			10:00	18:00						8:00	\-1.0
2016/11/02	 11 		水										0:00	有給休暇
2016/11/03	 11 	 1 	木										0:00
2016/11/04	 11 		金			10:00	19:00					1:00	8:00
2016/11/05	 11 	 1 	土										0:00
2016/11/06	 11 	 1 	日										0:00
2016/11/07	 11 		月			10:00	19:00					1:00	8:00
2016/11/08	 11 		火			10:00	21:00					1:00	10:00	\+2.0
2016/11/09	 11 		水			11:00	18:30					1:00	6:30	\-1.5
2016/11/10	 11 		木			9:00	18:30					1:00	8:30	\+0.5
2016/11/11	 11 		金			9:00	19:00					1:00	9:00	\+1.0
2016/11/12	 11 	 1 	土										0:00
2016/11/13	 11 	 1 	日										0:00
2016/11/14	 11 		月			9:00	14:00					1:00	4:00	\-4.0 早退
2016/11/15	 11 		火			9:00	18:00					1:00	8:00
2016/11/16	 11 		水										0:00	病欠 有給消化
2016/11/17	 11 		木			9:00	19:00					1:00	9:00	\+1.0
2016/11/18	 11 		金			9:00	18:00					1:00	8:00
2016/11/19	 11 	 1 	土										0:00
2016/11/20	 11 	 1 	日										0:00
2016/11/21	 11 		月			9:00	19:00					1:00	9:00	\+1.0
2016/11/22	 11 		火			10:00	19:00					1:00	8:00
2016/11/23	 11 	 1 	水										0:00
2016/11/24	 11 		木										0:00
2016/11/25	 11 		金										0:00
2016/11/26	 11 	 1 	土										0:00
2016/11/27	 11 	 1 	日										0:00
2016/11/28	 11 		月										0:00
2016/11/29	 11 		火										0:00
2016/11/30	 11 		水										0:00

$ ./bin/kintai_summary kintai
[2016-11-01 〜 2016-11-30]
現在: 103.0 / 144 時間
平均労働時間: 7.923076923076923
残り出勤日を: 1日あたり8.2 時間働くとボーダを超えます
有給使用日数: 2 日
残出勤日数: 5 日
残出勤日:
  11/24(木)
  11/25(金)
  11/28(月)
  11/29(火)
  11/30(水)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/actindi-kintai_summary.
