require 'rails_helper'

RSpec.describe Detainees::ScheduledMoveMapper do
  let(:hash) {
    {
      "alerts":
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
    }.with_indifferent_access
  }
  let(:expected_result) {
    {
      violent: 'no',
      suicide: 'yes',
      self_harm: 'yes',
      escape_risk: 'yes',
      segregation: 'no',
      medical: 'no'
    }.with_indifferent_access
  }

  subject(:mapper) { described_class.new(hash) }

  it 'returns a mapped hash with all the mandatory details' do
    result = mapper.call
    expect(result).to eq(expected_result)
  end
end
