defmodule PhxCicdAutomationWeb.UploadLive do
  use PhxCicdAutomationWeb, :live_view
  alias ExAws.S3

  @bucket "your-s3-bucket-name"

  def render(assigns) do
    ~L"""
    <form phx-change="validate" phx-submit="save">
      <input type="file" phx-hook="UploadFile" />
      <button type="submit">Upload</button>
    </form>
    <%= if @uploaded_url do %>
      <p>Uploaded: <a href="<%= @uploaded_url %>" target="_blank">View File</a></p>
    <% end %>
    """
  end

  def handle_event("save", %{"file" => %Plug.Upload{path: path, filename: filename}}, socket) do
    s3_key = "uploads/#{filename}"

    case File.read(path) do
      {:ok, file_binary} ->
        case S3.put_object(@bucket, s3_key, file_binary) |> ExAws.request() do
          {:ok, _} ->
            url = "https://#{@bucket}.s3.amazonaws.com/#{s3_key}"
            {:noreply, assign(socket, uploaded_url: url)}

          {:error, reason} ->
            {:noreply, assign(socket, error: "Upload failed: #{reason}")}
        end

      {:error, reason} ->
        {:noreply, assign(socket, error: "File read failed: #{reason}")}
    end
  end


  def handle_event("get_upload_url", %{"filename" => filename}, socket) do
    s3_key = "uploads/#{filename}"
    # url = generate_presigned_upload_url(s3_key)
    {:noreply,
      socket
    # assign(socket, presigned_url: url)
  }
  end

end
