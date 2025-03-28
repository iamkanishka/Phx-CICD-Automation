defmodule PhxCicdAutomation.Auth.AuthController do
  use PhxCicdAutomationWeb, :controller
  alias PhxCicdAutomation.Auth.GitHub

  def request(conn, _params) do
    redirect(conn, external: GitHub.authorize_url())
  end



end
