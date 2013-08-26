# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^spec/.*spec_helper.rb})  { "spec" }
  watch(%r{^spec/factories/.+\.rb})  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/features/#{m[1]}_spec.rb", "spec/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/features" }
  watch('app/controllers/api/api_controller.rb')      { 'spec/api' }
  watch(%r{app/interactors/.+\.rb})                   { 'spec/interactors' }
  watch(%r{app/policies/.+\.rb})                      { 'spec/policies' }
  watch(%r{app/models/concerns/.+\.rb})               { 'spec/models' }
  watch(%r{^app/views/(.+)/.*\.(erb|haml|jbuilder)$}) { |m| ["spec/features/#{m[1]}_spec.rb", "spec/#{m[1]}_spec.rb"] }
end

