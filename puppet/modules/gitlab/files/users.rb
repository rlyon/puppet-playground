# Hey, guess what this is really insecure.  Please don't use this in real life.
root = User.find_by(username: 'root')

root.username = 'root'
root.password = 'supersecretrootpassword'
root.password_confirmation = 'supersecretrootpassword'
root.password_expires_at = 1.year.from_now
root.authentication_token = 'mxKCg3dAQstgzqspELFa'
root.save!
root.confirm!

if root.valid?
  puts %Q[
    Root account created:

    login.........root
    password......supersecretrootpassword
    token.........mxKCg3dAQstgzqspELFa
  ]
end

user = User.find_by(username: 'puppet')

unless user
  user = User.new
  user.name = 'puppet'
  user.username = 'puppet'
  user.email = 'puppet@gitlab.local'
  user.password = 'supersecret'
  user.password_confirmation = 'supersecret'
  user.password_expires_at = 1.year.from_now
  user.authentication_token = 'mxKCg3dAQstgzqspELFb'
  user.projects_limit = 100
  user.admin = false
  user.save!
  user.confirm!
end

if user.valid?
  puts %Q[
    User account created:

    login.........puppet
    password......supersecret
    token.........nxKCg3dAQstgzqspELFb
  ]
end
