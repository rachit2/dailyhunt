module BuilderBase
  class ApplicationMailer < ::ApplicationMailer
    default from: ENV['MAIL_FROM']
    layout 'mailer'
  end
end
