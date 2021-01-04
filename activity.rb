require_relative 'env'
require 'pp'

USERS = {
  github_username: "label (name / surname)",
  luigi: "Luigi World",
  "luigi-world": "Luigi World (2)",
}

STATS = {

}

STATS_BIG = {

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
    additions = :BIG if additions > 300
    stat = STATS[user_id.to_sym] || 0
    STATS[user_id.to_sym] = stat + additions unless additions == :BIG
    stat = STATS_BIG[user_id.to_sym] || 0
    STATS_BIG[user_id.to_sym] = stat + 1 if additions == :BIG
    puts Time.parse(commit.committed_date).strftime("%b %d")
    puts "#{user_id}: #{additions}"
    puts
  end
end
puts "\n\n"

puts "Date: #{Time.now.strftime("%b %d")}"
puts "Weeks: #{GH::NUM_WEEKS}"
puts "\n\n"

puts "STATS:"
puts "-"*8
STATS.sort_by{ |k, v| -v }.each do |user, value|
  puts "#{user}: #{value}"
end
puts "\n\n"
puts "STATS_BIG:"
puts "-"*8
STATS_BIG.sort_by{ |k, v| -v }.each do |user, value|
  puts "#{user}: #{value}"
end
puts "\n\n"
