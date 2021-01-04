class GH
  extend Cache

  GQLClient = GraphQL::Client

  GITHUB_API = "https://api.github.com/graphql"
  HTTP = GQLClient::HTTP.new(GITHUB_API) do
    def headers(context)
      { "Authorization": "bearer #{GITHUB_TOKEN}" }
    end
  end

  SchemaFilePath = "data/github_schema.json"
  Schema = if File.exists? SchemaFilePath
    GQLClient.load_schema SchemaFilePath
  else
    GQLClient.load_schema HTTP
  end

  Client = GQLClient.new schema: Schema, execute: HTTP

  REPO_NAME = "strading-cli"
  REPO_NAME = "travel-ledger"
  # REPO_NAME = "emsurge"
  # REPO_NAME = "emsurge"
  REPO_NAME = "nuggets"

  OWNER = "appliedblockchain"
  OWNER = "NuggetsLtd"

  NUM_WEEKS = 1
  NUM_WEEKS = 2
  NUM_WEEKS = 1
  WEEK = 604800 * NUM_WEEKS
  DATE = "#{(Time.new - WEEK).iso8601[0..-7]}Z"

  # query for all repositories commits for analytic purposes
  # we use this query and the zube cards to track progress on projects
  CommitsQuery = Client.parse %Q(
    query {
      repository(name: "#{REPO_NAME}", owner: "#{OWNER}") {
        id
        name
        refs(refPrefix: "refs/heads/", first: 30) {
          totalCount
          pageInfo {
            hasNextPage
          }
          edges {
            cursor
            node {
              id
              name
              target {
                abbreviatedOid
                ... on Commit {
                  history(first: 100, since: "#{DATE}") {
                    totalCount
                    pageInfo {
                      hasNextPage
                    }
                    edges {
                      cursor
                      node {
                        oid
                        additions
                        deletions
                        changedFiles
                        commitUrl
                        committedDate
                        pushedDate
                        author {
                          name
                          email
                          user {
                            login
                            email
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  )

  # extend Cache

  def self.activity
    reset!
    data = cache CommitsQuery do
      query = GH::Client.query CommitsQuery
      p query
      query.data
    end

    data.repository
  end

  def self.reset!
    `rm -f #{APP_PATH}/tmp/cache/GH::CommitsQuery.json`
  end

end
