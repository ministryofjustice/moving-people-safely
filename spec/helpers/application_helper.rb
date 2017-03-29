require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#link_to_print_in_new_window' do
    let(:move) { create(:move) }
    
    it 'produces a link to a pdf that opens in a new window' do
      expect(helper.link_to_print_in_new_window(move)).
        to eq("<a target=\"_blank\" href=\"/moves/#{move.id}/print\">Print</a>")
    end
    
    it 'takes customized text for the link' do
      expect(helper.link_to_print_in_new_window(move, text: "foo")).
        to include('>foo</a>')
    end
    
    it 'takes custom styles' do
      expect(helper.link_to_print_in_new_window(move, styles: "bar baz")).
        to include('class="bar baz"')
    end
  end
end