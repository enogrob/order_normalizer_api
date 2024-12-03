namespace :fly do
  task :ssh do
    sh 'fly ssh console --pty -C "sudo -iu rails"'
  end

  task :console do
    sh 'fly ssh console --pty -C "/rails/bin/rails console"'
  end

  task :dbconsole do
    sh 'fly ssh console --pty -C "/rails/bin/rails dbconsole"'
  end
  task :dbmigrate do
    sh 'fly ssh console -C "/rails/bin/rails db:migrate"'
  end
end
