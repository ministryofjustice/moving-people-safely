class DashboardPresenter
  include ActionView::Helpers::TranslationHelper

  attr_reader :escorts

  def initialize(escorts)
    @escorts = escorts
  end

  def render_no_moves_indicator
    render_indicator(:detainees, :detainees_due_to_move, 0)
  end

  def render_detainees_indicator
    render_indicator(:detainees, :detainees_due_to_move, escorts.uncancelled.count)
  end

  def render_risk_indicator
    if count_of_incomplete_risk.zero?
      render_complete_indicator(:risk, :risk_complete)
    else
      render_incomplete_indicator(:risk, :risk_incomplete, count_of_incomplete_risk)
    end
  end

  def render_health_indicator
    if count_of_incomplete_healthcare.zero?
      render_complete_indicator(:healthcare, :healthcare_complete)
    else
      render_incomplete_indicator(:healthcare, :healthcare_incomplete, count_of_incomplete_healthcare)
    end
  end

  def render_offences_indicator
    if count_of_incomplete_offences.zero?
      render_complete_indicator(:offences, :offences_complete)
    else
      render_incomplete_indicator(:offences, :offences_incomplete, count_of_incomplete_offences)
    end
  end

  private

  def render_complete_indicator(gauge, title)
    render_indicator(gauge, title, '&#10004;', classes: %i[complete])
  end

  def render_incomplete_indicator(gauge, title, value)
    render_indicator(gauge, title, value, classes: %i[incomplete])
  end

  def render_indicator(gauge, title, value, options = {})
    localised_title = t("homepage.gauges.#{title}")
    classes = options.fetch(:classes, [])
    "<div id='#{gauge}_gauge' class='gauge_wrapper #{classes.join(' ')}'>
      <div class='value'>#{value}</div>
      <div class='title'>#{localised_title}</div>
    </div>"
  end

  def count_of_incomplete_risk
    escorts.uncancelled.with_incomplete_risk.count + escorts.uncancelled.without_risk_assessment.count
  end

  def count_of_incomplete_healthcare
    escorts.uncancelled.with_incomplete_healthcare.count + escorts.uncancelled.without_healthcare_assessment.count
  end

  def count_of_incomplete_offences
    escorts.uncancelled.with_incomplete_offences.count
  end
end
