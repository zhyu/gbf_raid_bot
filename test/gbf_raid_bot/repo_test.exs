defmodule GbfRaidBot.RepoTest do
  use ExUnit.Case

  alias GbfRaidBot.Repo

  setup_all do
    Redix.command(:redix, ~w(FLUSHDB))
    :ok
  end

  test "boss names" do
    Repo.add_boss_name!("Lv75 セレスト・マグナ")
    assert Repo.list_up_boss_names() == ["Lv75 セレスト・マグナ"]

    Repo.add_boss_name!("Lv50 ティアマト・マグナ")
    assert Repo.list_up_boss_names() == ["Lv50 ティアマト・マグナ", "Lv75 セレスト・マグナ"]

    Repo.remove_all_boss_names!
    assert Repo.list_up_boss_names() == []
  end

  test "target bosses" do
    Repo.add_target_boss!("Lv75 セレスト・マグナ")

    assert Repo.target_boss?("Lv75 セレスト・マグナ")
    refute Repo.target_boss?("Lv50 ティアマト・マグナ")
    assert Repo.list_up_target_bosses() == ["Lv75 セレスト・マグナ"]

    Repo.add_target_boss!("Lv50 ティアマト・マグナ")

    assert Repo.target_boss?("Lv50 ティアマト・マグナ")
    assert Repo.list_up_target_bosses() == ["Lv50 ティアマト・マグナ", "Lv75 セレスト・マグナ"]

    Repo.remove_target_boss!("Lv75 セレスト・マグナ")
    assert Repo.list_up_target_bosses() == ["Lv50 ティアマト・マグナ"]

    Repo.remove_all_target_bosses!()
    assert Repo.list_up_target_bosses() == []
  end

  test "notification" do
    refute Repo.send_notification?

    Repo.turn_on_notification!
    assert Repo.send_notification?

    Repo.turn_off_notification!
    refute Repo.send_notification?
  end
end
