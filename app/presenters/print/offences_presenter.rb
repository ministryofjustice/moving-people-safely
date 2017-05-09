module Print
  class OffencesPresenter < SimpleDelegator
    include PresenterHelpers

    def label
      content = t('print.label.offences.current_offences')
      label_for(model.offences, content)
    end

    def relevant
      relevance_for(model.offences)
    end

    def formatted_list
      format_list(model.offences)
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
