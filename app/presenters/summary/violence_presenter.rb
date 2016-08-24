module Summary
  class ViolencePresenter < SummaryPresenter
    def answer_for(attribute)
      if violence_question_unanswered?
        "<span class='text-error'>Missing</span>"
      elsif violence_question_answered_yes? && checkbox_checked?(attribute)
        '<b>Yes</b>'
      else
        'No'
      end
    end

    private

    def violence_question_unanswered?
      violent_question_value == 'unknown'
    end

    def violence_question_answered_yes?
      violent_question_value == 'yes'
    end

    def violent_question_value
      public_send(:violent)
    end

    def checkbox_checked?(attribute)
      public_send(attribute) == true
    end
  end
end
