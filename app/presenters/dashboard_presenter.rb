class DashboardPresenter
  attr_reader :moves

  def initialize(date)
    @moves = Move.for_date(date)
    @moves_count = moves.count
  end

  def render_detainees_indicator
    render_indicator('detainees', 'Detainees due to move', @moves_count)
  end

  def render_risk_indicator
    if count_of_incomplete_risk.zero?
      cl = 'risk complete'
      title = 'Risk completed'
    else
      cl = 'risk incomplete'
      title = 'Risk incomplete'
    end

    render_indicator(cl, title, count_of_incomplete_risk)
  end

  def render_health_indicator
    if count_of_incomplete_healthcare.zero?
      cl = 'healthcare complete'
      title = 'Health completed'
    else
      cl = 'healthcare incomplete'
      title = 'Health incomplete'
    end

    render_indicator(cl, title, count_of_incomplete_healthcare)
  end

  def render_offences_indicator
    if count_of_incomplete_offences.zero?
      cl = 'offences complete'
      title = 'Offences completed'
    else
      cl = 'offences incomplete'
      title = 'Offences incomplete'
    end

    render_indicator(cl, title, count_of_incomplete_offences)
  end

  private

  def render_indicator(cl, title, value)
    "<div class='gauge_wrapper #{cl}'>
      <div class='value'>#{value}</div>
      <div class='title'>#{title}</div>
    </div>"
  end

  def count_of_detainees
    @moves_count
  end

  def count_of_incomplete_risk
    moves.with_incomplete_risk.count
  end

  def count_of_incomplete_healthcare
    moves.with_incomplete_healthcare.count
  end

  def count_of_incomplete_offences
    moves.with_incomplete_offences.count
  end
end
