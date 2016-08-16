require 'nomis/refinements/downcased_hash_keys'

RSpec.describe Nomis::DowncasedHashKeys do
  class Example
    using Nomis::DowncasedHashKeys

    def self.call(hash)
      hash.downcase_keys
    end
  end

  describe '#downcase_keys' do
    it 'downcases the keys in a hash recursively' do
      h = {
        'Foo' => 'hello',
        'BarBaz' => 'mate',
        'Lol_Lol' => { 'One' => [ { 'Two' => 'Three' } ] }
      }

      expect(Example.(h)).
        to eq({
          'foo' => 'hello',
          'barbaz' => 'mate',
          'lol_lol' => { 'one' => [ { 'two' => 'Three' } ] }
        })
    end
  end
end
