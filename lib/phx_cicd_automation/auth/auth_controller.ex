defmodule PhxCicdAutomation.Auth.AuthController do
  use PhxCicdAutomationWeb, :controller
  alias PhxCicdAutomation.Auth.GitHub

  def request(conn, _params) do
    redirect(conn, external: GitHub.authorize_url())
  end
  def callback(conn, %{"code" => code}) do
    case GitHub.get_token(code) do
      {:ok, token} ->
        conn
        |> put_session(:github_token, token.access_token)
        |> put_flash(:info, "Successfully authenticated!")
        |> redirect(to: "/repos")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Authentication failed!")
        |> redirect(to: "/")
    end
  end

  def list_repos(conn, _params) do
    token = get_session(conn, :github_token)

    case GitHub.fetch_repos(token) do
      {:ok, repos} ->
        json(conn, repos)

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Failed to fetch repositories.")
        |> redirect(to: "/")
    end
  end


end
