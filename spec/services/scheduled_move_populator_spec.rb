require 'rails_helper'

RSpec.describe ScheduledMovePopulator, type: :service do
  let(:escort) { create(:escort, prison_number: 'A1234BC') }
  let(:offender_alerts_path) { "/offenders/#{escort.prison_number}/alerts" }
  let(:nomis_api_response) {
    {
      "alerts"=>
        [
          {
            "alert_type"=>{"code"=>"X", "desc"=>"Security"},
            "alert_sub_type"=>{"code"=>"XNR", "desc"=>"Not For Release"},
            "alert_date"=>"2009-12-22",
            "status"=>"ACTIVE",
            "comment"=>"DiaHNZYoTthiDiaHNZYoTth"
          },
          {
            "alert_type"=>{"code"=>"S", "desc"=>"Sexual Offence"},
            "alert_sub_type"=>{"code"=>"SOR", "desc"=>"Registered sex offender"},
            "alert_date"=>"2016-08-02",
            "status"=>"ACTIVE"
          },
          {
            "alert_type"=>{"code"=>"T", "desc"=>"Hold Against Transfer"},
            "alert_sub_type"=>{"code"=>"TPR", "desc"=>"Parole Review Hold"},
            "alert_date"=>"2016-08-05",
            "status"=>"ACTIVE"
          },
          {
            "alert_type"=>{"code"=>"P", "desc"=>"MAPPP Case"},
            "alert_sub_type"=>{"code"=>"PL1", "desc"=>"MAPPA Level 1"},
            "alert_date"=>"2016-08-15",
            "status"=>"ACTIVE"
          },
          {
            "alert_type"=>{"code"=>"P", "desc"=>"MAPPP Case"},
            "alert_sub_type"=>{"code"=>"PVN", "desc"=>"ViSOR Nominal"},
            "alert_date"=>"2016-08-16",
            "status"=>"ACTIVE",
            "comment"=>"KasaaKasaa"
          },
          {
            "alert_type"=>{"code"=>"P", "desc"=>"MAPPP Case"},
            "alert_sub_type"=>{"code"=>"PC1", "desc"=>"MAPPA Cat 1"},
            "alert_date"=>"2016-08-18",
            "status"=>"ACTIVE"
          },
          {
            "alert_type"=>{"code"=>"X", "desc"=>"Security"},
            "alert_sub_type"=>{"code"=>"XA", "desc"=>"Arsonist"},
            "alert_date"=>"2018-11-05",
            "status"=>"ACTIVE"
          },
          {
            "alert_type"=>{"code"=>"X", "desc"=>"Security"},
            "alert_sub_type"=>{"code"=>"XEL", "desc"=>"Escape List"},
            "alert_date"=>"2018-11-05",
            "status"=>"ACTIVE"
          },
          {
            "alert_type"=>{"code"=>"X", "desc"=>"Security"},
            "alert_sub_type"=>{"code"=>"XRF", "desc"=>"Risk to Females"},
            "alert_date"=>"2018-11-05",
            "status"=>"ACTIVE"
          },
          {
            "alert_type"=>{"code"=>"X", "desc"=>"Security"},
            "alert_sub_type"=>{"code"=>"XSA", "desc"=>"Staff Assaulter"},
            "alert_date"=>"2018-11-05",
            "status"=>"ACTIVE"
          },
          {
            "alert_type"=>{"code"=>"H", "desc"=>"Self Harm"},
            "alert_sub_type"=>{"code"=>"HA", "desc"=>"ACCT Open (HMPS)"},
            "alert_date"=>"2018-11-05",
            "status"=>"ACTIVE"
          },
          {
            "alert_type"=>{"code"=>"X", "desc"=>"Security"},
            "alert_sub_type"=>{"code"=>"XTACT", "desc"=>"Terrorism Act or Related Offence"},
            "alert_date"=>"2018-11-05",
            "status"=>"ACTIVE"
          }
        ]
    }
  }

  subject { described_class.new(escort) }

  context 'NOMIS API is working' do
    before do
      stub_nomis_api_request(:get, offender_alerts_path, body: nomis_api_response.to_json)
    end

    let(:scheduled_move_attrs) {
      {
        'violent' => 'no',
        'suicide' => 'yes',
        'self_harm' => 'yes',
        'escape_risk' => 'yes',
        'segregation' => 'no',
        'medical' => 'no'
      }
    }

    it 'populates the scheduled move' do
      subject.call

      expect(escort.scheduled_move.attributes).to include scheduled_move_attrs
    end
  end

  context 'NOMIS API is not working' do
    before do
      stub_nomis_api_request(:get, offender_alerts_path)
    end

    it 'does not populate the scheduled move' do
      subject.call

      expect(escort.scheduled_move).to be_nil
    end
  end
end
