module Forms
  module Risks
    class StepManager
      RISKS_STEPS = DoubleLinkedList.new.tap do |l|
        l << Forms::Risks::ToSelf
        l << Forms::Risks::Violence
      end

      def self.build_step_for(step_name, escort)
        node = RISKS_STEPS.find { |n| n.value.name == step_name }
        form = node.value.new(escort.risks)
        Step.new(node, form, escort)
      end

      def self.total_steps
        RISKS_STEPS.count
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
