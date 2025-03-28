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

  def authorize_url do
    client()
    # Access to private repos
    |> OAuth2.Client.authorize_url!(scope: "repo")
  end

  def get_token(code) do
    client()
    |> OAuth2.Client.get_token!(code: code)
  end

  def fetch_repos(token) do
    headers = [{"Authorization", "Bearer #{token}"}]
    url = "#{@github_api}/user/repos?per_page=100"

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
