defmodule GbfRaidBot.RepoTest do
  use ExUnit.Case

  alias GbfRaidBot.Repo

  setup_all do
    Redix.command(:redix, ~w(FLUSHDB))
    :ok
  end

  test "boss names" do
    Repo.store_boss_name("Lv75 セレスト・マグナ")
    assert Repo.list_up_boss_names() == ["Lv75 セレスト・マグナ"]

    Repo.store_boss_name("Lv50 ティアマト・マグナ")
    assert Repo.list_up_boss_names() == ["Lv50 ティアマト・マグナ", "Lv75 セレスト・マグナ"]
  end
end
