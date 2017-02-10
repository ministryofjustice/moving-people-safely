module Page
  class MovePrint < Base
    def assert_detainee_details(detainee)
      within('.detainee') do
        assert_detainee_identifer(detainee)
        assert_content(detainee.forenames)
        assert_content(detainee.prison_number, within: '#prison-number')
        assert_content(detainee.date_of_birth.strftime('%d %b %Y'), within: '#date-of-birth')
        assert_content(AgeCalculator.age(detainee.date_of_birth), within: '#age')
        assert_content_or_default(detainee.cro_number, within: '#cro-number')
        assert_content_or_default(detainee.pnc_number, within: '#pnc-number')
        assert_list_or_default(detainee.nationalities, within: '.nationality')
        assert_list_or_default(detainee.aliases, within: '.alias')
        assert_image_content(detainee.image)
        assert_gender_content(detainee.gender, within: '#gender')
      end
    end

    def assert_move_details(move)
      within('.move') do
        assert_content(move.from)
        assert_content(move.to)
        assert_content(move.date.strftime('%d %b %Y'))
      end
    end

    private

    def assert_content(content, options = {})
      within_container = options[:within]
      if within_container.present?
        within(within_container) { expect(page).to have_content(content) }
      else
        expect(page).to have_content(content)
      end
    end

    def assert_content_or_default(value, options = {})
      default = options.fetch(:default, 'None')
      content = value.present? ? value : default
      assert_content(content, options)
    end

    def assert_list_or_default(value, options = {})
      default = options.fetch(:default, 'None')
      list_sep = options.fetch(:list_sep, ',')
      if value.present?
        value.split(list_sep).each do |v|
          assert_content(v.strip, options)
        end
      else
        assert_content(default, options)
      end
    end

    def assert_detainee_identifer(detainee)
      content = "#{detainee.prison_number}: #{detainee.surname}"
      assert_content(content, within: '#detainee-identifier')
    end

    def assert_image_content(image)
      expect(page).to have_css('div.image')
      if image.present?
        expect(page).not_to have_css('.image-unavailable-text')
      else
        expect(page).to have_css('.image-unavailable-text')
      end
    end

    def assert_gender_content(gender, options = {})
      code = gender == 'male' ? 'M' : 'F'
      assert_content(code, options)
    end
  end
end
