require "rspec/expectations"

RSpec::Matchers.define :allow_content_type do |*content_types|
  match do |record| 
    matcher.matches?(record, content_types)
  end

  chain :for do |attr_name|
    matcher.for(attr_name)
  end

  chain :with_message do |message|
    matcher.with_message(message)
  end

  private

  def matcher
    @matcher ||= AllowContentTypeMatcher.new
  end

  class AllowContentTypeMatcher
    def for(attr_name)
      @attr_name = attr_name
    end

    def with_message(message)
      @message = message
    end
      
    def matches?(record, content_types)
      Array.wrap(content_types).all? do |content_type|
        record.send(attr_name).attach attachment_for(content_type)
        record.valid?
        !record.errors[attr_name].include? message
      end
    end

    private

    attr_reader :attr_name

    def attachment_for(content_type)
      suffix = content_type.to_s.split("/").last

      { io: StringIO.new("Hello world!"), filename: "test.#{suffix}", content_type: content_type }
    end

    def message
      @message || I18n.translate("activerecord.errors.messages.content_type")
    end
  end
end

RSpec::Matchers.alias_matcher :allow_content_types, :allow_content_type