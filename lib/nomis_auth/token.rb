# frozen_string_literal: true

module NomisAuth
  Token = Struct.new(:access_token, :expires_in) do
    def self.from_json(json)
      access_token = json['access_token']

      # this will work for expires_in seconds
      expires_in = json['expires_in']

      new(access_token, expires_in)
    end
  end
end
