desc "run"
task :run do
  sh "bundle exec ruby activity.rb"
end

task default: :run

# ---

desc "Dump graphql schema to json"
task :graphql_dump do
  require_relative 'env'
  GraphQL::Client.dump_schema GH::HTTP, "data/github_schema.json"
end
