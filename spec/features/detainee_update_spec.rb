require 'feature_helper'

RSpec.feature 'Detainee updates', type: :feature do
  let(:prison_number) { 'A1234BC' }
  let(:detainee) { create(:detainee, prison_number: prison_number) }
  let(:escort) { create(:escort, prison_number: prison_number, detainee: detainee) }

  context 'when detainee does not have an image set' do
    scenario 'displays an image placeholder' do
      login

      visit edit_escort_detainee_path(escort)
      new_detainee_page.assert_form_with_image_placeholder
    end

    context 'and pull option is provided' do
      context 'and image is retrieved successfully' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: { image: 'base-64-encoded-image' }.to_json)
        end

        scenario 'displays the retrieved image' do
          login

          visit edit_escort_detainee_path(escort, pull: :image)
          new_detainee_page.assert_form_with_detainee_image
        end
      end

      context 'and image is cannot be retrieved' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", status: 500)
        end

        scenario 'displays an image placeholder' do
          login

          visit edit_escort_detainee_path(escort, pull: :image)
          new_detainee_page.assert_form_with_image_placeholder
        end
      end

      context 'and image is not found' do
        before do
          stub_nomis_api_request(:get, "/offenders/#{prison_number}/image", body: { image: nil }.to_json)
        end

        scenario 'displays an image placeholder' do
          login

          visit edit_escort_detainee_path(escort, pull: :image)
          new_detainee_page.assert_form_with_image_placeholder
        end
      end
    end
  end

  context 'when detainee has an image set' do
    let(:detainee) { create(:detainee, prison_number: prison_number, image: 'encoded-base64-image') }

    scenario 'displays the detainee image' do
      login

      visit edit_escort_detainee_path(escort)
      new_detainee_page.assert_form_with_detainee_image
    end
  end
end
