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
      self_harm_details: "",
      rule_45: "no",
      vulnerable_prisoner: "no",
      vulnerable_prisoner_details: "",
      controlled_unlock_required: "no",
      high_profile: "no",
      high_profile_details: "",
      intimidation: "yes",
      intimidation_to_public: false,
      intimidation_to_public_details: "",
      intimidation_to_other_detainees: true,
      intimidation_to_other_detainees_details: "",
      gang_member: "no",
      gang_member_details: "",
      violence_to_staff: "no",
      violence_to_staff_details: "",
      risk_to_females: "no",
      risk_to_females_details: "",
      homophobic: "no",
      homophobic_details: "",
      racist: "no",
      racist_details: "",
      discrimination_to_other_religions: "no",
      discrimination_to_other_religions_details: "",
      other_violence_due_to_discrimination: "no",
      other_violence_due_to_discrimination_details: "",
      current_e_risk: "yes",
      current_e_risk_details: "has a large poster on cell wall",
      previous_escape_attempts: "no",
      previous_escape_attempts_details: "",
      hostage_taker: "no",
      sex_offence: "no",
      arson: "no",
      must_return: "no",
      must_return_to_details: "",
      must_not_return: "no",
      other_risk: "no",
      other_risk_details: ""
    }.with_indifferent_access
  }

  subject(:mapper) { described_class.new(hash, move_date) }

  it 'returns a mapped hash with all the mandatory details' do
    result = mapper.call
    expect(result).to eq(expected_result)
  end
end
