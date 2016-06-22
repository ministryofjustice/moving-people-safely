require 'rails_helper'

RSpec.describe HomepageCell, type: :cell do
  controller HomepageController

  let(:form) { Forms::Search.new }

  it 'renders a form to allow searching for a detainee' do
    html = cell(:homepage, form).()

    expect(html).to have_content('Find a detainee').
      and have_css('input#search_prison_number').
      and have_button('Search')
  end

  let(:create_button_text)  { 'Create new profile' }
  let(:review_link_text)    { 'Review profile' }

  context 'performing a search' do
    context 'when the input is invalid' do
      it 'displays an error message without profile controls' do
        form.validate(prison_number: 'busted')
        html = cell(:homepage, form).()

        expect(html).to have_content('Prison number is invalid')
        expect(html).not_to have_button(create_button_text)
        expect(html).not_to have_link(review_link_text)
      end
    end

    context 'when the search is valid without a result' do
      it 'returns a link to add a detainee' do
        form.validate(prison_number: 'A1234BC')
        html = cell(:homepage, form).()

        expect(html).to have_button(create_button_text)
      end
    end

    context 'when the search returns a valid result' do
      it 'returns info about the detainee with a link to their profile' do
        escort = create_escort_with_detainee_and_move

        form.validate(prison_number: 'A1234BC')

        html = cell(:homepage, form).()

        expect(html).
          to have_link(review_link_text, href: profile_path(escort))

        expect(html).to have_content('A1234BC').
          and have_content('Alcatraz').
          and have_content('Trump Donald').
          and have_content('14 Jun 1946').
          and have_content('10 Jul 2016')
      end

      def create_escort_with_detainee_and_move
        Escort.create.tap do |e|
          e.create_detainee(
            prison_number: 'A1234BC',
            forenames: 'Donald',
            surname: 'Trump',
            date_of_birth: Date.civil(1946, 6, 14)
          )
          e.create_move(to: 'Alcatraz', date: Date.civil(2016, 7, 10))
        end
      end
    end
  end
end
