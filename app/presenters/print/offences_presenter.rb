module Print
  class OffencesPresenter < SimpleDelegator
    include Print::Helpers

    def current_offences_label
      content = t('print.label.offences.current_offences')
      label_for(model.current_offences, content)
    end

    def current_offences_relevant
      relevance_for(model.current_offences)
    end

    def current_offences
      format_list(model.current_offences)
    end

    def past_offences_label
      content = t('print.label.offences.past_offences')
      label_for(model.past_offences, content)
    end

    def past_offences_relevant
      relevance_for(model.past_offences)
    end

    def past_offences
      format_list(model.past_offences)
    end

    private

    def label_for(list, content)
      list.present? ? highlighted_content(content) : content
    end

    def relevance_for(list)
      list.present? ? highlighted_content('Yes') : 'None'
    end

    def format_list(list)
      return if list.empty?
      safe_join(list.map do |item|
        array = [item.offence]
        if item.respond_to?(:case_reference) && item.case_reference.present?
          array << "(#{item.case_reference})"
        end
        array.join(' ')
      end, ' | ')
    end

    def model
      __getobj__
    end
  end
end
