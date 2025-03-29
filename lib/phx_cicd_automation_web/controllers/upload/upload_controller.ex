defmodule PhxCicdAutomationWeb.Upload.UploadController do
  use PhxCicdAutomationWeb, :controller
  alias ExAws.S3

  @bucket "your-s3-bucket-name"

  def upload(conn, %{"file" => %Plug.Upload{path: path, filename: filename}}) do
    s3_key = "uploads/#{filename}"

    case File.read(path) do
      {:ok, file_binary} ->
        case S3.put_object(@bucket, s3_key, file_binary) |> ExAws.request() do
          {:ok, _} ->
            url = "https://#{@bucket}.s3.amazonaws.com/#{s3_key}"
            json(conn, %{url: url})
          {:error, reason} ->
            json(conn, %{error: reason})
        end

      {:error, reason} ->
        json(conn, %{error: reason})
    end
  end
end
