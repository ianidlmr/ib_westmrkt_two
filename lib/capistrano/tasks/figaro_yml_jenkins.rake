namespace :figaro_yml_jenkins do

  desc 'Setup/update figaro `application.yml` file on Jenkins'
  task :setup do
    # This task assumes you have an SSH config file with aliases

    # Jenkins (build server)
    `scp config/application.yml jenkins:/home/ubuntu/wecannect`
  end

end