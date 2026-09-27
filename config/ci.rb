# Run using bin/ci. No database or live publisher needed.
CI.run do
  step "Style: Ruby", "bin/rubocop"
  step "Security: Gems", "bin/bundler-audit"
  step "Security: JavaScript", "bin/importmap audit"
  step "Security: Rails", "bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error"
  step "Tests", "bin/rails test"
  step "Autoloading", "env RAILS_ENV=test bin/rails zeitwerk:check"
  step "Production assets", "env RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile"
end
