require 'tmpdir'

namespace :deploy do
  namespace :check do
    task :bundle_audit do
       on roles(:app) do |host|
        Dir.mktmpdir do |dir| 
          Dir.chdir dir do
            download! "#{release_path}/Gemfile.lock", "Gemfile.lock"
            download! "#{release_path}/Gemfile", "Gemfile"
            
            run_locally do
              execute "bundle-audit update &> /dev/null"
              bundle_audit_output = capture "bundle-audit"
              unless ENV['SKIP_BUNDLE_AUDIT']
                if bundle_audit_output =~ /Name:/
                  raise "Bundle audit failed; update your vulnerable dependencies and redeploy"
                end
              end
            end
          end
        end
      end
    end
  end
  
  before 'deploy:starting', 'deploy:check:bundle_audit' 
end
