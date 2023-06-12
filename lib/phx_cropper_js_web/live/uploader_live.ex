defmodule PhxCropperJsWeb.UploaderLive do
  use PhxCropperJsWeb, :live_view

  alias PhxCropperJs.FaceDetection.Detector

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg .png), max_entries: 1)}
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:too_many_files), do: "You have selected too many files"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  def handle_event("validate", _params, socket) do
    {:noreply, push_event(socket, "test", %{})}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
        [extname] = MIME.extensions(entry.client_type)

        dest =
          Path.join([
            :code.priv_dir(:phx_cropper_js),
            "static",
            "uploads",
            Path.basename(path) <> "." <> extname
          ])

        Detector.check(path)
        |> case do
          [0, 0] ->
            {:postpone, :no_face_no_eyes}

          [_, _] ->
            File.cp!(path, dest)

            Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
            |> then(&{:ok, {:ok, &1}})

          _ ->
            {:postpone, :error}
        end
      end)
      |> case do
        [:no_face_no_eyes] ->
          {:noreply,
           socket
           |> put_flash(:error, "No Face detected")
           |> push_redirect(to: Routes.uploader_path(socket, :index))}

        [ok: upload_path] ->
          {:noreply, socket |> push_redirect(to: upload_path)}

        _ ->
          {:noreply,
           socket
           |> put_flash(:error, "Somwthing went wrong while saving your upload")
           |> push_redirect(to: Routes.uploader_path(socket, :index))}
      end
  end
end
