class DashboardPresenter
  attr_reader :moves

  def initialize(date)
    @moves = Move.for_date(date)
    @moves_count = moves.count
  end

  def render_detainees_indicator
    render_indicator('detainees', 'Detainees', @moves_count)
  end

  def render_risks_indicator
    if count_of_incomplete_risks == 0
      cl = 'risks complete'
      title = 'Risks completed'
    else
      cl = 'risks incomplete'
      title = 'Incomplete risks'
    end

    render_indicator(cl, title, count_of_incomplete_risks)
  end

  def render_health_indicator
    if count_of_incomplete_healthcare == 0
      cl = 'healthcare complete'
      title = 'Health completed'
    else
      cl = 'healthcare incomplete'
      title = 'Incomplete health'
    end

    render_indicator(cl, title, count_of_incomplete_healthcare)
  end

  def render_offences_indicator
    if count_of_incomplete_offences == 0
      cl = 'offences complete'
      title = 'Offences completed'
    else
      cl = 'offences incomplete'
      title = 'Incomplete offences'
    end

    render_indicator(cl, title, count_of_incomplete_offences)
  end

  def render_indicator(cl, title, value)
    "<div class='gauge_wrapper #{cl}'>
      <span class='title'>#{title}</span>
      <span class='gauge'><span>#{value}</span></span>
    </div>".html_safe
  end

  def count_of_detainees
    @moves_count
  end

  def count_of_incomplete_risks
    moves.with_incomplete_risks.count
  end

  def count_of_incomplete_healthcare
    moves.with_incomplete_healthcare.count
  end

  def count_of_incomplete_offences
    moves.with_incomplete_offences.count
  end
end
