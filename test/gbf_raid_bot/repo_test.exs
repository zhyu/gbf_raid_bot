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

  test "target bosses" do
    Repo.store_target_boss("Lv75 セレスト・マグナ")

    assert Repo.target_boss?("Lv75 セレスト・マグナ")
    refute Repo.target_boss?("Lv50 ティアマト・マグナ")
    assert Repo.list_up_target_bosses() == ["Lv75 セレスト・マグナ"]

    Repo.store_target_boss("Lv50 ティアマト・マグナ")

    assert Repo.target_boss?("Lv50 ティアマト・マグナ")
    assert Repo.list_up_target_bosses() == ["Lv50 ティアマト・マグナ", "Lv75 セレスト・マグナ"]
  end
end
