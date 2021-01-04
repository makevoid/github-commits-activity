require_relative 'env'
require 'pp'

USERS = {
  github_username: "label (name / surname)",
  luigi: "Luigi World",
  "luigi-world": "Luigi World (2)",
}

STATS = {

}

def extract_user_id(user:, author:)
  email = user && user.email
  email = author.email if !email || email == ""
  user = email.split("@")[0]
  USERS[user.to_sym] || user
end

repo = GH.activity

puts "Repo: #{repo.name}"

# get repos data
repo.refs.edges.map do |ref_edge|
  node = ref_edge.node
  next unless node.name == "master"
  node.target.history.edges.map do |commit_edge|
    commit = commit_edge.node
    author = commit.author
    user   = author.user
    user_id  = extract_user_id user: user, author: author
    additions = commit.additions
    stat = STATS[user_id.to_sym] || 0
    STATS[user_id.to_sym] = stat + additions
    # NOTE: extract statistic relative to your metric / zube card cross referencing like timestamps to compare it to actions/velocity and to change of status (the work is efficiently picked up / devs don't get stuck gathering requirements and open straight away a WIP PR [current best practice])
    puts Time.parse(commit.committed_date).strftime("%b %d")
    puts "#{user_id}: #{additions}"
    puts
  end
end
puts "\n\n"

puts "Date: #{Time.now.strftime("%b %d")}"
puts "Weeks: #{GH::NUM_WEEKS}"
puts "\n\n"

# TODO: output prettyfication code from
p STATS
