require 'shellwords'
require 'tmpdir'

namespace :deploy do
  namespace :check do
    desc "Audit the Gemfile/Gemfile.lock for known vulnerabilities"
    task :bundle_audit do
      on roles(:app), in: :sequence do |host|

        # Download the relevant files and run bundle-audit on them locally
        Dir.mktmpdir do |dir|
          Dir.chdir dir do
            gem_files = capture(:ls, "#{release_path}/Gemfile*").split("\n")
            gem_files.delete_if {|f| f.end_with? 'example' }
            gem_files.each do |gemfile|
              download! gemfile, File.split(gemfile).last
            end
            run_locally do

              # Get the latest vulnerability information
              execute "bundle-audit update &> /dev/null"

              bundle_audit_output = capture "bundle-audit #{"--ignore #{Shellwords.join(fetch(:bundle_audit_ignore))}" unless fetch(:bundle_audit_ignore).empty? }"

              # bundle-audit includes failures for both gem vulnerabilities
              # and insecure gem sources, and offers no way to distinguish those cases.
              # unfortunately, we only want to fail when vulnerable gems are required.
              # This should only fail if there is a bundle-audit output AND it has 
              # a solution available to upgrade. If no solution is available deploy
              # will still be allowed.
              if bundle_audit_output =~ /Solution: upgrade to/
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

namespace :load do
  task :defaults do
    set :bundle_audit_ignore, %W{#{ENV['BUNDLE_AUDIT_IGNORES']}}
    set :skip_bundle_audit, !!ENV['SKIP_BUNDLE_AUDIT']
  end
end
