defmodule PhxCicdAutomation.Aws.S3Uploader do
  alias ExAws.S3

  @bucket "your-s3-bucket-name"

  def upload_file(file_path, s3_key) do
    file_path
    |> File.read!()
    |> S3.put_object(@bucket, s3_key)
    |> ExAws.request()
  end
end
