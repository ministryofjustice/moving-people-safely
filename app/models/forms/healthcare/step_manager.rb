module Forms
  module Healthcare
    class StepManager
      HEALTHCARE_STEPS = DoubleLinkedList.new.tap do |l|
        l << Forms::Healthcare::Physical
        l << Forms::Healthcare::Mental
        l << Forms::Healthcare::Social
        l << Forms::Healthcare::Allergies
        l << Forms::Healthcare::Needs
        l << Forms::Healthcare::Transport
        l << Forms::Healthcare::Contact
      end

      def self.build_step_for(step_name, escort)
        node = HEALTHCARE_STEPS.find { |n| n.value.name == step_name }
        form = node.value.new(escort.healthcare)
        Step.new(node, form, escort)
      end

      def self.total_steps
        HEALTHCARE_STEPS.count
      end
    end

    class Step
      include Rails.application.routes.url_helpers

      def initialize(node, form, escort)
        @node = node
        @form = form
        @escort = escort
      end

      attr_reader :form

      delegate :position, :next, :prev, to: :@node, prefix: 'node'

      def next_path
        build_path_for_step(node_next)
      end

      def prev_path
        build_path_for_step(node_prev)
      end

      def path
        build_path_for_step(@node)
      end

      def has_next?
        node_next.present?
      end

      def has_prev?
        node_prev.present?
      end

      def name
        @node.value.name
      end

      private

      def build_path_for_step(step)
        if step
          public_send("#{step.value.name}_path", @escort)
        else
          profile_path(@escort)
        end
      end
    end
  end
end
