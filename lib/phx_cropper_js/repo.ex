defmodule PhxCropperJs.Repo do
  use Ecto.Repo,
    otp_app: :phx_cropper_js,
    adapter: Ecto.Adapters.Postgres
end
