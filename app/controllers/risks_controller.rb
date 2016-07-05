class RisksController < ApplicationController
  include Wicked::Wizard
  include Wizardable

  steps :risks_to_self, :risk_from_others, :violence, :harassments,
    :sex_offences, :non_association_markers, :security, :substance_misuse,
    :concealed_weapons, :arson, :communication

  def show
    form.prepopulate!
    render :show, locals: { form: form, template_name: form.class.name }
  end

  def update
    if form.validate form_params
      form.save
      redirect_after_update
    else
      render :show, locals: { form: form, template_name: form.class.name }
    end
  end

  private

  def form_params
    params[step]
  end

  def form
    @_form ||= {
      risks_to_self: Forms::Risks::RisksToSelf,
      risk_from_others: Forms::Risks::RiskFromOthers,
      violence: Forms::Risks::Violence,
      harassments: Forms::Risks::Harassments,
      sex_offences: Forms::Risks::SexOffences,
      non_association_markers: Forms::Risks::NonAssociationMarkers,
      security: Forms::Risks::Security,
      substance_misuse: Forms::Risks::SubstanceMisuse,
      concealed_weapons: Forms::Risks::ConcealedWeapons,
      arson: Forms::Risks::Arson,
      communication: Forms::Risks::Communication
    }[step].new(escort.risks)
  end
end
