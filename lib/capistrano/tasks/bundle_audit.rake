require 'tmpdir'

namespace :deploy do
  namespace :check do
    desc "Audit the Gemfile/Gemfile.lock for known vulnerabilities"
    task :bundle_audit do
      on roles(:app) do |host|

        # Download the relevant files and run bundle-audit on them locally
        Dir.mktmpdir do |dir| 
          Dir.chdir dir do
            download! "#{release_path}/Gemfile.lock", "Gemfile.lock"
            download! "#{release_path}/Gemfile", "Gemfile"

            run_locally do

              # Get the latest vulnerability information
              execute "bundle-audit update &> /dev/null"

              bundle_audit_output = capture "bundle-audit"

              # bundle-audit includes failures for both gem vulnerabilities
              # and insecure gem sources, and offers no way to distinguish those cases.
              # unfortunately, we only want to fail when vulnerable gems are required.
              if bundle_audit_output =~ /Name:/
                fail "Bundle audit failed; update your vulnerable dependencies before deploying"
              end
            end
          end
        end
      end
    end
  end
  
  after 'deploy:updating', 'deploy:check:bundle_audit' unless ENV['SKIP_BUNDLE_AUDIT']
end
