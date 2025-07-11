# Create the first admin user without phone number first
admin_user = User.find_or_create_by(email: 'admin@votingapp.com') do |user|
  user.password = 'admin123'
  user.password_confirmation = 'admin123'
  user.is_admin = true
  user.phone_verified = true
end

# Update admin user to bypass validation
if admin_user.persisted?
  admin_user.update_columns(
    phone: '+15551234567',
    is_admin: true,
    phone_verified: true
  )
  puts "✅ Admin user created: #{admin_user.email}"
else
  puts "❌ Failed to create admin user: #{admin_user.errors.full_messages.join(', ')}"
end

# Create some sample regular users for testing
sample_users = [
  { email: 'user1@example.com', phone: '+15551234568' },
  { email: 'user2@example.com', phone: '+15551234569' },
  { email: 'user3@example.com', phone: '+15551234570' }
]

sample_users.each do |user_data|
  user = User.find_or_create_by(email: user_data[:email]) do |u|
    u.password = 'password123'
    u.password_confirmation = 'password123'
    u.is_admin = false
  end
  
  if user.persisted?
    user.update_column(:phone, user_data[:phone])
    puts "✅ Sample user created: #{user.email}"
  else
    puts "❌ Failed to create sample user: #{user.errors.full_messages.join(', ')}"
  end
end

puts "\n🎉 Seeding completed!"
puts "📧 Admin credentials: admin@votingapp.com / admin123"
puts "📧 Sample user credentials: user1@example.com / password123"
puts "\n🔐 Only admin users can access the admin dashboard"
puts "📱 Users can register and verify their phone numbers for voting"
