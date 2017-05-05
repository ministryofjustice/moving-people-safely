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
    render partial: 'shared/breadcrumbs', locals: { breadcrumbs: breadcrumbs }
  end

  def detainee_breadcrumb(detainee)
    "#{detainee.prison_number}: #{detainee.surname}, #{detainee.forenames}"
  end
end
