RSpec.describe AnalyticsEvent do
  subject { described_class }
  let(:instrumentation_class) { double(:notifications) }

  describe ".publish" do
    it "pushes the event to the instrumentation class" do
      expect(instrumentation_class).to receive(:instrument).with(:event, params: :hash)
      subject.publish(:event, params: :hash, instrumentation_class: instrumentation_class)
    end
  end

  describe ".publish_with_timings" do
    it "pushes the event to the instrumentation class, yielding a block" do
      proc = Proc.new { :proc }
      expect(instrumentation_class).to receive(:instrument).with(:event, params: :hash, &proc)
      subject.publish_with_timings(:event, params: :hash, instrumentation_class: instrumentation_class) do
        proc
      end
    end
  end
end
