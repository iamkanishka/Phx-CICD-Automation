defmodule PhxCicdAutomation.Auth.Github do
  @github_api "https://api.github.com"

  def client do
    OAuth2.Client.new(
      strategy: OAuth2.Strategy.AuthCode,
      client_id: Application.get_env(:my_app, __MODULE__)[:client_id],
      client_secret: Application.get_env(:my_app, __MODULE__)[:client_secret],
      site: "https://github.com",
      authorize_url: "/login/oauth/authorize",
      token_url: "/login/oauth/access_token"
    )
  end

end
