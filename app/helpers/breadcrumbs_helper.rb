Breadcrumb = Struct.new(:title, :url)

module BreadcrumbsHelper
  def breadcrumbs
    @breadcrumbs ||= []
  end

  def root_breadcrumb
    @root_breadcrumb ||= Breadcrumb.new('Home', root_path)
  end

  def add_breadcrumb(title, url = nil)
    breadcrumbs << Breadcrumb.new(title, url)
  end
  alias breadcrumb add_breadcrumb

  def breadcrumbs_for_page(options = {}, &_block)
    breadcrumbs << root_breadcrumb if options.fetch(:root, false)
    yield if block_given?
  end

  def render_breadcrumbs
    render 'shared/breadcrumbs', breadcrumbs: breadcrumbs
  end

  def escort_breadcrumb(escort)
    "#{escort.number}: #{escort.detainee_surname}, #{escort.detainee_forenames}"
  end
end
