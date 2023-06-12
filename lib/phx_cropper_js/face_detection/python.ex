defmodule PhxCropperJs.Python do
  @moduledoc false

  defp python_script(config) do
    Keyword.fetch!(config, :python_script_path)
  end

  defp python_interpretor(config) do
    Keyword.fetch!(config, :python_interpretor_path)
  end

  # defp expire_after() do
  #   # default 10 minutes
  #   Keyword.get(config(), :expire_after, 600)
  # end

  defp config() do
    Application.fetch_env!(:python, __MODULE__)
  end

  @doc """
  Initate Python instance that calls a specified python file
  """
  def py_instance() do
    config = config()

    # Tested with Python 3.9.6
    {:ok, python_pid} =
      :python.start(
        python_path: to_charlist(python_script(config)),
        python: to_charlist(python_interpretor(config))
      )

    python_pid
  end

  @spec py_call(atom | pid | {atom, any} | {:via, atom, any}, atom, atom, list) :: any
  @doc """
  Makes a synchronous call to the modules function with arguments if specificed
  """
  def py_call(pid, module, func, args \\ []) do
    pid
    |> :python.call(module, func, args)
  end

  @doc """
  Terminates the python instance
  """
  def py_stop(pid) do
    :python.stop(pid)
  end
end
