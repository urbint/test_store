defmodule TestStore do
  @moduledoc """
  A GenServer / DETs backed store for use with testing.


  ## Configuration

  The file path used by `TestStore` can be set via the `:test_store` `:file_path` key
  in the application config. Defaults to `test/test_store.dets`.

  ## Usage

      iex> TestStore.put("sample_data", 5)
      iex> TestStore.get("sample_data")
      5

  """

  @store __MODULE__.Store

  @type key :: term
  @type value :: term


  @doc """
  Inserts the provided `value` into the store from the provided `key`.

  """
  @spec put(key, value) :: :ok | {:error, any}
  def put(key, value) do
    GenServer.call(@store, {:put, key, value})
  end

  @doc """
  Gets the value for the provided `key`.

  If the value has not been set, returns `{:error, :not_found}`

  """
  @spec get(key) :: value | {:error, :not_found} | {:error, any}
  def get(key) do
    GenServer.call(@store, {:get, key})
  end

  @doc """
  Deletes the value associated with the provided `key`.

  Returns whether there was any value that was deleted

  """
  @spec delete(key) :: boolean | {:error, any}
  def delete(key) do
    GenServer.call(@store, {:delete, key})
  end
end
