class AssessmentIntroPresenter
  include PresenterHelpers

  attr_reader :name

  def initialize(name)
    @name = name
  end

  def title
    t("#{name}.intro.title")
  end

  def contents
    t("#{name}.intro.content", default: '').split(/\n/)
  end

  def notes
    t("#{name}.intro.note", default: '').split(/\n/)
  end
end
