module BxBlockContentmanagement
  module SetDurationNil
    class << self
      def call
        BxBlockContentmanagement::LessionContent.find_each do |lession_content|
          lession_content.duration = lession_content.duration.to_i
          lession_content.save(validate: false)
        end
      end
    end
  end
end

