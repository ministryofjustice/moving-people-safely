class Establishment < ApplicationRecord
  ESTABLISHMENT_TYPES = [
    :crown_court,
    :magistrates_court,
    :prison,
    # Uncomment this when we want police stations & custody suites to appear in
    # the move destination pick list. How this will be displayed is still under
    # discussion.
    #
    # :police_custody
  ].freeze
end
