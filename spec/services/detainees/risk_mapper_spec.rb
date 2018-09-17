require 'rails_helper'

RSpec.describe Detainees::RiskMapper do
  let(:move_date) { 3.days.ago.to_date }
  let(:hash) {
    {
      "alerts":
      [
        {
          "alert_type":
            {
              "code": "X",
              "desc": "Security"
            },
          "alert_sub_type":
            {
              "code": "XEL",
              "desc": "Escape List"
            },
          "alert_date": 5.days.ago.to_date.to_s(:db),
          "status": "ACTIVE",
          "comment": "has a large poster on cell wall"
        },
        {
          "alert_type":
            {
              "code": "R",
              "desc": "Risk"
            },
          "alert_sub_type":
            {
              "code": "RKS",
              "desc": "Risk to Known Adult - Custody"
            },
          "alert_date": 5.days.ago.to_date.to_s(:db),
          "expiry_date": 20.days.from_now.to_date.to_s(:db),
          "status": "ACTIVE"
        },
        {
          "alert_type":
            {
              "code": "H",
              "desc": "Self harm"
            },
          "alert_sub_type":
            {
              "code": "HC",
              "desc": "Self Harm - Custody"
            },
          "alert_date": 2.days.ago.to_date.to_s(:db),
          "expiry_date": 20.days.from_now.to_date.to_s(:db),
          "status": "ACTIVE"
        }
      ]
    }.with_indifferent_access
  }
  let(:expected_result) {
    {
      self_harm: "no",
      rule_45: "no",
      vulnerable_prisoner: "no",
      controlled_unlock: "no",
      high_profile: "no",
      intimidation_public: "yes",
      intimidation_prisoners: "yes",
      gang_member: "no",
      violence_to_staff: "no",
      risk_to_females: "no",
      homophobic: "no",
      racist: "no",
      discrimination_to_other_religions: "no",
      current_e_risk: "yes",
      current_e_risk_details: "has a large poster on cell wall",
      previous_escape_attempts: "no",
      hostage_taker: "no",
      sex_offence: "no",
      arson: "no",
      must_return: "no",
      has_must_not_return_details: "no",
      other_risk: "no",
      violent_or_dangerous: "no"
    }.with_indifferent_access
  }

  subject(:mapper) { described_class.new(hash, move_date) }

  it 'returns a mapped hash with all the mandatory details' do
    result = mapper.call
    expect(result).to eq(expected_result)
  end
end
