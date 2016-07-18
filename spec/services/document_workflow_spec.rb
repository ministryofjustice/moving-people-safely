RSpec.describe DocumentWorkflow do
  subject { described_class.new(model) }
  let(:model) { double(:model, workflow_status: initial_status) }
  let(:initial_status) { :not_started }

  describe "#update_status" do
    let(:result) { subject.update_status(new_status) }

    context "with an invalid workflow state" do
      let(:new_status) { :monkies }

      it "raises an InvalidWorkflowStateError" do
        expect { result }.to raise_error DocumentWorkflow::InvalidWorkflowStateError
      end
    end

    context "when it is OK to update the status" do
      before { allow(model).to receive(:update_attribute) }
      let(:new_status) { :incomplete } # no validations on transitions to this state

      it "returns the new status" do
        expect(result).to eql new_status
      end
    end

    context "when it is not possible to move to the new state" do
      before do
        allow(subject).
          to receive(:can_transition_to?).
          with(:not_started).
          and_return(false)
      end
      let(:new_status) { :not_started }

      it "returns false" do
        expect(result).to be false
      end
    end
  end
end
