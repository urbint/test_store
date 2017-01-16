defmodule TestStoreTest do
  use ExUnit.Case
  doctest TestStore

  test "read write operations" do
    :ok = TestStore.put("my_value", 1)
    assert TestStore.get("my_value") == 1
  end

  test "delete operations" do
    TestStore.delete("my_value")
    assert TestStore.get("my_value") == {:error, :not_found}
  end

  test "pre-stored data persists" do
    # This data has been manually set
    assert TestStore.get("pre_stored") == true
  end
end
