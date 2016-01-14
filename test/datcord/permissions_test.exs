defmodule Datcord.PermissionSetTest do
  use ExUnit.Case, async: true
  alias Datcord.PermissionSet

  test "new permissions cannot be made using invalid permissions" do
    assert {:error, _} = PermissionSet.new([:xD], [])
  end

  test "only valid permissions can be allowed/denied" do
    permissions = %PermissionSet{}
    assert {:error, _} = PermissionSet.allow(permissions, :poop)
    assert {:error, _} = PermissionSet.deny(permissions, :everything)
    assert {:error, _} = PermissionSet.allow(permissions, [:bad, :thing])
    assert {:error, _} = PermissionSet.deny(permissions, [:potty, :d])
  end

  test "permissions can be converted to integers" do
    permissions = [:read_messages, :send_messages]
    assert PermissionSet.permissions_to_integer(permissions) == 3072
  end

  test "integers can be converted to permissions" do
    permissions = [:read_messages, :send_messages]
    assert PermissionSet.integer_to_permissions(3072) == permissions
  end
end
