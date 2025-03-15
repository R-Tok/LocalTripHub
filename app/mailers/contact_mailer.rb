class ContactMailer < ApplicationMailer
  def send_email(contact)
    @contact = contact
    recipient = Rails.env.production? ? ENV["MAIL_ADDRESS"] : "sample@gmail.com"
    mail to: recipient, subject: "【LocalTripHub お問い合わせ】" + @contact.subject
  end
end
