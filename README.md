# Voting App - SMS Verification System

A Rails application implementing advanced SMS verification for voting participation with security features and admin monitoring.

## Features

### SMS Verification System
- **Phone Number Collection**: Users must provide a valid phone number during registration
- **SMS Code Verification**: 6-digit verification codes sent via Twilio (mocked in development)
- **Rate Limiting**: Prevents abuse with IP-based rate limiting
- **Security Measures**: Code expiration (10 minutes), attempt tracking, suspicious request blocking

### Admin Dashboard
- **Verification Monitoring**: Track all verification attempts with success/failure rates
- **Statistics Dashboard**: Real-time metrics on verification attempts
- **User Management**: Promote/demote admin users with secure controls
- **Filtering & Search**: Filter by date range, success status, and user
- **Security Logging**: IP addresses, user agents, and attempt timestamps

### Security Features
- **Rate Limiting**: Rack Attack middleware for API protection
- **Phone Validation**: Phonelib for international phone number validation
- **Attempt Tracking**: Comprehensive logging of all verification attempts
- **Bot Protection**: Blocks suspicious user agents and automated requests
- **Admin Role System**: Boolean-based admin privileges with secure access control

## Setup Instructions

### Prerequisites
- Ruby 3.1.4
- PostgreSQL
- Redis (for rate limiting)

### Installation

1. **Clone and install dependencies:**
   ```bash
   git clone https://github.com/HamzaK106/voting-app
   cd voting_app
   bundle install
   ```

2. **Database setup:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. **Start the server:**
   ```bash
   rails server
   ```

### Environment Configuration

For production SMS sending, add Twilio credentials to `config/credentials.yml.enc`:

```bash
rails credentials:edit
```

Add:
```yaml
twilio_account_sid: your_account_sid
twilio_auth_token: your_auth_token
twilio_phone_number: your_twilio_phone_number
```

## Demo Instructions

### 1. Admin Access
The first admin user is automatically created via seeds:
- **Email**: `admin@votingapp.com`
- **Password**: `admin123`
- **Phone**: Already verified for demo purposes

### 2. Sample Users
Three sample users are created for testing:
- `user1@example.com` / `password123`
- `user2@example.com` / `password123`
- `user3@example.com` / `password123`

### 3. User Registration & Phone Verification
1. Visit `http://localhost:3000`
2. Click "Register" and create an account with a phone number
3. After registration, you'll be redirected to the home page
4. Click "Verify Phone Number" to start SMS verification
5. Click "Send Verification Code" (will show mock SMS in logs)
6. Enter the 6-digit code from the logs
7. Success! Phone is now verified

### 4. Admin Dashboard Demo
1. Sign in as `admin@votingapp.com` / `admin123`
2. Click "Admin Dashboard" on the home page
3. View verification statistics and attempt logs
4. Navigate to "User Management" to promote/demote admin users
5. Use filters to explore different time periods and success rates

### 5. Security Features Demo
1. **Rate Limiting**: Try requesting SMS codes rapidly (limited to 5 per hour per IP)
2. **Code Expiration**: Wait 10+ minutes after receiving a code, then try to use it
3. **Phone Validation**: Try registering with invalid phone numbers
4. **Admin Monitoring**: Check the admin dashboard to see all attempts logged

## API Endpoints

### SMS Verification
- `GET /sms_verification/request` - Request verification code
- `GET /sms_verification/verify` - Show verification form
- `POST /sms_verification/verify` - Submit verification code

### Admin
- `GET /admin/verification_attempts` - Admin dashboard (requires admin access)
- `GET /admin/users` - User management (requires admin access)
- `GET /admin/users/:id/toggle_admin` - Toggle admin status (requires admin access)

## Security Measures

### Rate Limiting
- SMS requests: 5 per hour per IP
- Code verification: 10 per hour per IP
- Registration: 3 per hour per IP

### Code Security
- 6-digit random codes
- 10-minute expiration
- One-time use only
- Attempt tracking with IP/user agent logging

### Bot Protection
- Blocks requests with suspicious user agents
- Comprehensive attempt logging
- IP-based rate limiting

### Admin Security
- Boolean-based admin role system
- Secure admin creation via seeds only
- No admin options in public registration
- Self-protection (admins can't remove their own admin status)

## Development Notes

- SMS sending is mocked in development/test environments
- Check `log/development.log` for mock SMS messages
- Admin access requires `is_admin: true` in database
- All verification attempts are logged for security monitoring
- First admin user created automatically via `rails db:seed`

## Production Considerations

1. **Twilio Setup**: Configure real Twilio credentials for SMS sending
2. **Redis**: Ensure Redis is running for rate limiting
3. **Admin Security**: Admin users should be created via secure processes
4. **Monitoring**: Set up alerts for failed verification attempts
5. **Backup**: Regular database backups for verification logs
6. **Seeds**: Run `rails db:seed` to create initial admin user
