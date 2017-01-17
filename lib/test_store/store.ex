defmodule TestStore.Store do
  @moduledoc false

  use Application
  use GenServer

  # Application callback function taking an empty list as an argument
  def start(_type, _args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # GenServer init callback function taking an empty list as an argument.
  def init([]) do
    path =
      file_path()

    with(
    {:ok, table} <- :dets.open_file(path),
     :dets.close(table)
    ) do
      :dets.open_file(path, ram_file: true)
    else
      {:error, reason} ->
        {:stop, reason}
    end
  end

  # GenServer terminate callback
  def terminate(_reason, table) do
    :dets.close(table)
  end

  def handle_call({:put, key, value}, _from, table) do
    with :ok <- :dets.insert(table, {key, value}) do
      {:reply, :ok, table}
    end
  end

  def handle_call({:get, key}, _from, table) do
    resp =
      case :dets.lookup(table, key) do
        [] ->
          {:error, :not_found}

        [{_key, value}] ->
          value

        {:error, _} = err ->
          err
      end

    {:reply, resp, table}
  end

  def handle_call({:delete, key}, _from, table) do
    resp =
      :dets.delete(table, key)

    {:reply, resp, table}
  end

  defp file_path do
    Application.get_env(:test_store, :file_path, "test/test_store.dets")
  end
end
