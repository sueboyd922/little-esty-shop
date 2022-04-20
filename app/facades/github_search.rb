require_relative "../services/github_service"
require_relative "../poros/contributor"

class GithubSearch
  def output
    json_contributers = GithubService.new.contributors
    json_repo = GithubService.new.repo
    json_contributers.class != Hash || json_repo.class != Hash ? wrap : json_repo[:message]
  end

  def wrap
    info = {}
    info[:repo] = create_repo
    info[:contributors] = contributor_information
    info
  end

  def create_repo
    name = service.repo[:name]
    Repo.new(name)
  end

  def contributor_information
    service.contributors.map do |data|
      Contributor.new(data)
    end
  end

  def service
    GithubService.new
  end
end
