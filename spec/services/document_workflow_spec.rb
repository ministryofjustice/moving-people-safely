RSpec.describe DocumentWorkflow do
  subject { described_class.new(model) }
  let(:model) { double(:model, workflow_status: initial_status) }
  let(:initial_status) { :not_started }

  describe "#can_update_status?" do
    let(:result) { subject.can_update_status?(new_status) }

    context "transition to :incomplete" do
      let(:new_status) { :incomplete }

      it "returns true" do
        expect(result).to be true
      end
    end

    context "transition to :complete" do
      before { expect(model).to receive(:all_questions_answered?).and_return(all_answered) }
      let(:new_status) { :complete }

      context "when all questions have been answered" do
        let(:all_answered) { true }

        it "returns true" do
          expect(result).to be true
        end
      end

      context "when not all questions have been answered" do
        let(:all_answered) { false }

        it "returns false" do
          expect(result).to be false
        end
      end
    end
  end

  describe "#update_status!" do
    let(:result) { subject.update_status!(:complete) }

    context "when it cannot update the status" do
      before { allow(model).to receive(:all_questions_answered?).and_return(false) }

      it "throws an exception" do
        expect { result }.to raise_error DocumentWorkflow::WorkflowStateChangeError
      end
    end

    context "when it can update the status" do
      before { allow(model).to receive(:all_questions_answered?).and_return(true) }

      it "updates the workflow status of the model" do
        allow(model).to receive(:update_attribute)
        subject.update_status!(:complete)
      end
    end
  end

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
  end
end
