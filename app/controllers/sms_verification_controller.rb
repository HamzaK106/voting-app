class SmsVerificationController < ApplicationController
  before_action :authenticate_user!
  before_action :check_rate_limit, only: [:request_code]
  before_action :ensure_phone_present, only: [:request_code, :verify]

  def request_code
    if current_user.phone_verified?
      redirect_to root_path, notice: 'Your phone is already verified.'
      return
    end

    # Generate verification code
    current_user.generate_verification_code
    
    # Send SMS
    sms_service = SmsService.new
    formatted_phone = sms_service.format_phone_number(current_user.phone)
    result = sms_service.send_verification_code(formatted_phone, current_user.verification_code)
    
    if result[:success]
      redirect_to verify_sms_verification_path, notice: 'Verification code sent to your phone.'
    else
      redirect_to request_sms_verification_path, alert: 'Failed to send verification code. Please try again.'
    end
  end

  def verify
    if request.post?
      code = params[:verification_code]
      
      if current_user.verify_code?(code)
        # Track successful attempt
        current_user.track_verification_attempt(code, true, request)
        
        # Mark phone as verified
        current_user.mark_phone_verified!
        
        redirect_to root_path, notice: 'Phone number verified successfully! You can now participate in voting.'
      else
        # Track failed attempt
        current_user.track_verification_attempt(code, false, request)
        
        flash.now[:alert] = 'Invalid or expired verification code. Please try again.'
        render :verify
      end
    end
  end

  private

  def check_rate_limit
    if current_user.rate_limited?
      redirect_to root_path, alert: 'Too many verification attempts. Please try again later.'
    end
  end

  def ensure_phone_present
    unless current_user.phone.present?
      redirect_to edit_user_registration_path, alert: 'Please add a phone number before verification.'
      return
    end
    
    # Check if phone number is valid
    unless Phonelib.valid?(current_user.phone)
      redirect_to edit_user_registration_path, alert: 'Please add a valid phone number in international format (e.g., +1234567890) before verification.'
      return
    end
  end
end
