require 'feature_helper'

RSpec.feature 'admin dashboard', type: :feature do
  let!(:escort_1) do
    create(:escort, :issued, :completed, date: Date.today,
           from_establishment: a_police_station,
           forenames: 'POLLY', surname: 'POLICE')
  end

  let!(:escort_2) do
    create(:escort, :issued, :completed, date: Date.today,
           from_establishment: a_court,
           forenames: 'COLIN', surname: 'COURT')
  end

  let!(:escort_3) do
    create(:escort, :issued, :completed, date: Date.today,
           from_establishment: a_prison,
           forenames: 'PRUNELLA', surname: 'PRISON')
  end

  let(:a_police_station) do
    create(:police_custody, name: 'Foo Police Station', sso_id: User::POLICE_ORGANISATION)
  end

  let(:a_court) do
    create(:crown_court, name: 'Bar Crown Court', sso_id: User::COURT_ORGANISATION)
  end

  let(:a_prison) do
    create(:prison, name: 'Baz Prison', sso_id: User::PRISON_ORGANISATION)
  end

  def expect_all_visible
    expect(page).to have_content(escort_1.surname)
    expect(page).to have_content(escort_2.surname)
    expect(page).to have_content(escort_3.surname)
    expect(page.all('.move-row').size).to eq 3
  end

  scenario 'login as MPS admin who is in no other non-admin teams' do
    login_options = {
      sso: {
        info: {
          permissions: [
            {'organisation' => User::ADMIN_ORGANISATION}
          ]
        }
      }
    }

    login(nil, login_options)

    expect(current_path).to eq root_path
    expect(page).to have_content('MoJ HQ')
    expect_all_visible
  end

  scenario 'login as MPS admin who is also in other non-admin teams' do
    login_options = {
      sso: {
        info: {
          permissions: [
            {'organisation' => User::POLICE_ORGANISATION},
            {'organisation' => User::COURT_ORGANISATION},
            {'organisation' => User::ADMIN_ORGANISATION},
            {'organisation' => User::PRISON_ORGANISATION}
          ]
        }
      }
    }
    login(nil, login_options)

    expect(current_path).to eq root_path
    expect(page).to have_content('MoJ HQ')
    expect_all_visible
  end
end
