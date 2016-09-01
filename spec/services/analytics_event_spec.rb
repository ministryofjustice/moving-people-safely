RSpec.describe AnalyticsEvent do
  subject { described_class }
  let(:instrumentation_class) { double(:notifications) }

  describe ".publish" do
    it "pushes the event to the instrumentation class" do
      expect(instrumentation_class).to receive(:instrument).with(:event, params: :hash)
      subject.publish(:event, params: :hash, instrumentation_class: instrumentation_class)
    end

    it "yields a block if given" do
      expect(instrumentation_class).to receive(:instrument).and_yield
      subject.publish(:event, instrumentation_class: instrumentation_class) do
        :block
      end
    end
  end
end
