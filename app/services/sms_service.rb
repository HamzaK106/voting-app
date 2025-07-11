class SmsService
  def initialize
    @client = Twilio::REST::Client.new(
      Rails.application.credentials.twilio_account_sid,
      Rails.application.credentials.twilio_auth_token
    )
  rescue
    # Fallback for development without credentials
    @client = nil
  end

  def send_verification_code(phone_number, code)
    message = "Your voting verification code is: #{code}. Valid for 10 minutes."
    
    if Rails.env.development? || Rails.env.test?
      # Mock SMS sending in development/test
      Rails.logger.info "MOCK SMS to #{phone_number}: #{message}"
      return { success: true, sid: "mock_#{SecureRandom.hex(10)}" }
    else
      # Real SMS sending in production
      begin
        message = @client.messages.create(
          body: message,
          from: Rails.application.credentials.twilio_phone_number,
          to: phone_number
        )
        { success: true, sid: message.sid }
      rescue => e
        Rails.logger.error "SMS sending failed: #{e.message}"
        { success: false, error: e.message }
      end
    end
  end

  def format_phone_number(phone)
    # Ensure phone number is in E.164 format for Twilio
    phone_obj = Phonelib.parse(phone)
    phone_obj.full_e164.presence || phone
  end
end 