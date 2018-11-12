require 'rails_helper'

RSpec.describe Escorts::DeleteHistoricUnissued do
  let(:options) { { logger: Rails.logger } }

  it 'soft deletes all unissued escorts past their date' do
    create(:escort, move: create(:move, date: 3.days.ago))
    create(:escort, move: create(:move, date: 1.day.ago))

    create(:escort, :issued, move: create(:move, date: 3.days.ago))
    create(:escort, :issued, move: create(:move, date: 1.day.ago))

    create(:escort, move: create(:move, date: Date.today))
    create(:escort, :issued, move: create(:move, date: 1.hour.ago))

    expect { described_class.call(options) }.to change { Escort.count }.from(6).to(4)
    expect(Escort.unscoped.count).to eq(6)
    expect(Escort.unscoped.where('deleted_at is not null').count).to eq(2)
  end
end
