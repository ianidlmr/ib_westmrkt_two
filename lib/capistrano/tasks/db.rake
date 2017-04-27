namespace :db do
  desc 'Runs rake db:seed'
  task :seed do
    raise 'not allowed' if fetch(:stage).eql?(:production)
    on primary :db do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  desc 'Runs rake db:reset'
  task :reset do
    raise 'not allowed' if fetch(:stage).eql?(:production)
    on primary :db do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :rake, 'db:reset'
        end
      end
    end
  end

  desc 'Runs rake db:drop && rake db:create'
  task :recreate do
    raise 'not allowed' if fetch(:stage).eql?(:production)
    on primary :db do
      within release_path do
        with rails_env: fetch(:stage) do
          execute :rake, 'db:drop'
          execute :rake, 'db:create'
        end
      end
    end
  end
end
