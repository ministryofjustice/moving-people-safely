module Nomis
  class Error < StandardError
    RequestTimeout = Class.new(self)
    InvalidResponse = Class.new(self)
  end
end
