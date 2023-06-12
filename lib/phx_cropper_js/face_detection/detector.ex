defmodule PhxCropperJs.FaceDetection.Detector do
  alias PhxCropperJs.Python, as: Helper

  def check(image_file_path) do
    call_python(:detector, :detect, [image_file_path])
  end

  def send_message(message_to_echo) do
    call_python(:detector, :hello, [message_to_echo])
  end

  @doc """
  module - an atomized name of the python file is passed
  function_args - Function Arguments are received in python as binary string
    i.e b'some argument'
  """
  defp call_python(module, function, function_args) do
    python_pid = Helper.py_instance()
    result = Helper.py_call(python_pid, module, function, function_args)

    python_pid
    |> Helper.py_stop()

    result
  end
end
