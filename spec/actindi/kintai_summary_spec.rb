require "spec_helper"
require 'pry'

describe Actindi::KintaiSummary do
  describe Actindi::KintaiSummary::Parser::Line do
    context 'simpe format' do
      it 'be success' do
        line_text = "2016/11/01	 11 		火			10:00	18:00						8:00"
        line = Actindi::KintaiSummary::Parser::Line.new(line_text)
        expect(line.day).to eq(Date.new(2016, 11, 1))
        expect(line.working_sections.first).to eq([
          Date.new(2016, 11, 1, 18, 0, 0),
          Date.new(2016, 11, 1, 18, 0, 0),
        ])
      end
    end
    context 'do\'t work' do
      context 'has holiday flag' do
        it 'be success' do
          line_text = "2016/11/03	 11 	 1 	木										0:00"
          line = Actindi::KintaiSummary::Parser::Line.new(line_text)
        end
      end
    end

    it "has a version number" do
      expect(Actindi::KintaiSummary::VERSION).not_to be nil
    end

    describe '#current_time' do
      let(:kintai) do
        <<-KINTAI
2016/11/01	 11 		火			10:00	18:00						8:00
2016/11/02	 11 		水										0:00
2016/11/03	 11 	 1 	木										0:00
2016/11/04	 11 		金			10:00	19:00					1:00	8:00
2016/11/05	 11 	 1 	土										0:00
2016/11/06	 11 	 1 	日										0:00
2016/11/07	 11 		月			10:00	19:00					1:00	8:00
2016/11/08	 11 		火			10:00	21:00					1:00	10:00
2016/11/09	 11 		水			11:00	18:30					1:00	6:30
2016/11/10	 11 		木			9:00	18:30					1:00	8:30
2016/11/11	 11 		金			9:00	19:00					1:00	9:00
2016/11/12	 11 	 1 	土										0:00
2016/11/13	 11 	 1 	日										0:00
2016/11/14	 11 		月			9:00	14:00					1:00	4:00
2016/11/15	 11 		火			9:00	18:00					1:00	8:00
2016/11/16	 11 		水										0:00
2016/11/17	 11 		木			9:00	19:00					1:00	9:00
2016/11/18	 11 		金			9:00	18:00					1:00	8:00
2016/11/19	 11 	 1 	土										0:00
2016/11/20	 11 	 1 	日										0:00
2016/11/21	 11 		月			9:00							15:00
2016/11/22	 11 		火										0:00
2016/11/23	 11 	 1 	水										0:00
2016/11/24	 11 		木										0:00
2016/11/25	 11 		金										0:00
2016/11/26	 11 	 1 	土										0:00
2016/11/27	 11 	 1 	日										0:00
2016/11/28	 11 		月										0:00
2016/11/29	 11 		火										0:00
2016/11/30	 11 		水										0:00
        KINTAI
      end
      it 'return current_time' do
        summary = Actindi::KintaiSummary.parse(kintai)
        summary.current_time
      end
    end
  end
end
