module Nomis
  module Error
    Error = Class.new(StandardError)
    RequestTimeout = Class.new(Error)
    InvalidResponse = Class.new(Error)
  end
end
