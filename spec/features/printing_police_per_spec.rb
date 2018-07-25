require 'feature_helper'

RSpec.feature 'printing a police PER', type: :feature do
  let(:reviewer) {
    create(:user, first_name: 'Nel', last_name: 'Bee')
  }
  let(:approver) {
    create(:user, first_name: 'Ned', last_name: 'Nok')
  }
  let(:police_custody) {
    create(:police_custody, name: 'My Jolly Police Custody Suite')
  }
  let(:pnc_number) { '99/000000Z' }
  let(:prison_number) { 'W1234BY' }
  let(:escort) {
    create(
      :escort,
      pnc_number: pnc_number,
      prison_number: prison_number,
      detainee: detainee,
      move: move,
      risk: risk,
      healthcare: healthcare,
      offences: offences,
      offences_workflow: offences_workflow,
      approver: approver,
      approved_at: DateTime.civil(2016, 3, 10, 12, 30)
    )
  }
  let(:move) {
    create(
      :move,
      from_establishment: police_custody,
      to: 'Luton Crown Court',
      date: Date.civil(2099, 4, 22)
    )
  }

  let(:offences_workflow) {
    create(:offences_workflow,
      status: :confirmed,
      reviewer: reviewer,
      reviewed_at: DateTime.civil(2016, 3, 10, 12, 30)
    )
  }

  let(:offences) { [] }

  let(:detainee) {
    create(
      :detainee,
      pnc_number: pnc_number,
      prison_number: prison_number,
      forenames: 'Testy',
      surname: 'McTest',
      date_of_birth: Date.civil(1970, 12, 10),
      aliases: 'Terry Tibbs, Mr T',
      gender: 'male',
      nationalities: 'British',
      diet: 'Gluten free',
      language: 'English',
      interpreter_required: 'yes',
      interpreter_required_details: 'English-American translator',
      religion: 'Baptist',
      ethnicity: 'European',
      cro_number: '56TYY/UU',
      peep: 'yes',
      peep_details: 'Broken leg'
    )
  }

  context 'when a PER is completed with all answers as no' do
    let(:risk) {
      create(:risk, :confirmed,
        acct_status: 'none',
        reviewer: reviewer,
        reviewed_at: DateTime.civil(2016, 3, 10, 12, 30)
      )
    }
    let(:healthcare) {
      create(:healthcare, :confirmed,
        contact_number: '1-131-999-0232',
        reviewer: reviewer,
        reviewed_at: DateTime.civil(2016, 3, 10, 12, 30)
      )
    }

    scenario 'user prints the PER' do
      login
      visit escort_path(escort)
      escort_page.click_print

      expect(page.body).
        to validate_as_pdf_that_contains_text('police/pdf-text-all-no-answers.txt')
    end
  end
end
