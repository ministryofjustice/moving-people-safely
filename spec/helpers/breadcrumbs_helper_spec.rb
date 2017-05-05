require 'rails_helper'

RSpec.describe BreadcrumbsHelper, type: :helper do
  describe '#breadcrumbs' do
    specify { expect(helper.breadcrumbs).to be_a(Array) }
    specify { expect(helper.breadcrumbs.empty?).to be_truthy }
  end

  describe '#root_breadcrumb' do
    specify { expect(helper.root_breadcrumb).to be_kind_of(Breadcrumb) }
    specify { expect(helper.root_breadcrumb.title).to eq('Home') }
    specify { expect(helper.root_breadcrumb.url).to eq(root_path) }
  end

  describe '#add_breadcrumb' do
    it 'adds a new breadcrumb to the existent breadcrumb list' do
      expect {
        helper.add_breadcrumb('New', '/dummy-url')
      }.to change { helper.breadcrumbs.size }.from(0).to(1)
      last_crumb = helper.breadcrumbs.last
      expect(last_crumb.title).to eq('New')
      expect(last_crumb.url).to eq('/dummy-url')

      expect {
        helper.add_breadcrumb('Other', '/other-url')
      }.to change { helper.breadcrumbs.size }.from(1).to(2)
      last_crumb = helper.breadcrumbs.last
      expect(last_crumb.title).to eq('Other')
      expect(last_crumb.url).to eq('/other-url')

      expect {
        helper.add_breadcrumb('No Link')
      }.to change { helper.breadcrumbs.size }.from(2).to(3)
      last_crumb = helper.breadcrumbs.last
      expect(last_crumb.title).to eq('No Link')
      expect(last_crumb.url).to be_nil
    end
  end

  describe '#breadcrumbs_for_page' do
    context 'when no options or block are provided' do
      it 'does not change the default empty breadcrumbs' do
        expect {
          helper.breadcrumbs_for_page
        }.not_to change { helper.breadcrumbs.size }.from(0)
      end
    end

    context 'when the root option is passed as false' do
      it 'does not change the default empty breadcrumbs' do
        expect {
          helper.breadcrumbs_for_page(root: false)
        }.not_to change { helper.breadcrumbs.size }.from(0)
      end
    end

    context 'when the root option is passed as true' do
      it 'adds the root crumb to the breadcrumbs' do
        expect {
          helper.breadcrumbs_for_page(root: true)
        }.to change { helper.breadcrumbs.size }.from(0).to(1)
        expect(helper.breadcrumbs.last).to eq(helper.root_breadcrumb)
      end
    end

    context 'when a block is provided' do
      it 'yields the provided block' do
        expect { |b| helper.breadcrumbs_for_page(&b) }.to yield_with_no_args
      end

      it 'adds any new breadcrumb after the root one (when defined)' do
        expect {
          helper.breadcrumbs_for_page(root:true) do
            helper.breadcrumb 'New', '/new-url'
          end
        }.to change { helper.breadcrumbs.size }.from(0).to(2)
        expect(helper.breadcrumbs.first).to eq(helper.root_breadcrumb)
        last_crumb = helper.breadcrumbs.last
        expect(last_crumb.title).to eq('New')
        expect(last_crumb.url).to eq('/new-url')
      end
    end
  end
end
