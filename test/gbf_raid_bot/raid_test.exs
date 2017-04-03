defmodule GbfRaidBot.RaidTest do
  use ExUnit.Case

  alias GbfRaidBot.Raid
  alias ExTwitter.Model.Tweet

  test "parse a tweet with invalid source" do
    tweet = %Tweet{source: "unknown source"}

    assert Raid.parse_raid_tweet(tweet) == nil
  end

  test "parse and check a valid jp tweet without message" do
    tweet = %Tweet{
      source: ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>),
      text: "参加者募集！参戦ID：ABCD1234\nLv75 セレスト・マグナ\nhttps://t.co/FDiaOqEDYl"
    }
    raid = Raid.parse_raid_tweet(tweet)

    assert raid == %{message: "", battle_id: "ABCD1234",
                     boss_name: "Lv75 セレスト・マグナ", url: "https://t.co/FDiaOqEDYl"}
    assert Raid.valid_raid?(raid)
  end

  test "parse and check a valid jp tweet with message" do
    tweet = %Tweet{
      source: ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>),
      text: "トレハン 参加者募集！参戦ID：ABCD1234\nLv75 セレスト・マグナ\nhttps://t.co/FDiaOqEDYl"
    }
    raid = Raid.parse_raid_tweet(tweet)

    assert raid == %{message: "トレハン ", battle_id: "ABCD1234",
                     boss_name: "Lv75 セレスト・マグナ", url: "https://t.co/FDiaOqEDYl"}
    assert Raid.valid_raid?(raid)
  end

  test "parse and check a valid jp tweet with multiline message" do
    tweet = %Tweet{
      source: ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>),
      text: "トレハン\nください\n参加者募集！参戦ID：ABCD1234\nLv75 セレスト・マグナ\nhttps://t.co/FDiaOqEDYl"
    }
    raid = Raid.parse_raid_tweet(tweet)

    assert raid == %{message: "トレハン\nください\n", battle_id: "ABCD1234",
                     boss_name: "Lv75 セレスト・マグナ", url: "https://t.co/FDiaOqEDYl"}
    assert Raid.valid_raid?(raid)
  end

  test "parse and check a valid en tweet without message" do
    tweet = %Tweet{
      source: ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>),
      text: "I need backup!Battle ID: ABCD1234\nLvl 75 Celeste Omega\nhttps://t.co/kJO5WaX9iC"
    }
    raid = Raid.parse_raid_tweet(tweet)

    assert raid == %{message: "", battle_id: "ABCD1234",
                     boss_name: "Lvl 75 Celeste Omega", url: "https://t.co/kJO5WaX9iC"}
    assert Raid.valid_raid?(raid)
  end

  test "parse and check a valid en tweet with message" do
    tweet = %Tweet{
      source: ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>),
      text: "help! I need backup!Battle ID: ABCD1234\nLvl 75 Celeste Omega\nhttps://t.co/kJO5WaX9iC"
    }
    raid = Raid.parse_raid_tweet(tweet)

    assert raid == %{message: "help! ", battle_id: "ABCD1234",
                     boss_name: "Lvl 75 Celeste Omega", url: "https://t.co/kJO5WaX9iC"}
    assert Raid.valid_raid?(raid)
  end

  test "parse and check a valid en tweet with multiline message" do
    tweet = %Tweet{
      source: ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>),
      text: "help\nme\nI need backup!Battle ID: ABCD1234\nLvl 75 Celeste Omega\nhttps://t.co/kJO5WaX9iC"
    }
    raid = Raid.parse_raid_tweet(tweet)

    assert raid == %{message: "help\nme\n", battle_id: "ABCD1234",
                     boss_name: "Lvl 75 Celeste Omega", url: "https://t.co/kJO5WaX9iC"}
    assert Raid.valid_raid?(raid)
  end

  test "parse and check a valid jp tweet without url at the end" do
    tweet = %Tweet{
      source: ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>),
      text: "参加者募集！参戦ID：ABCD1234\nLv75 セレスト・マグナ"
    }
    raid = Raid.parse_raid_tweet(tweet)

    assert raid == %{message: "", battle_id: "ABCD1234",
                     boss_name: "Lv75 セレスト・マグナ", url: ""}
    assert Raid.valid_raid?(raid)
  end

  test "parse and check a valid jp tweet with a new line at the end" do
    tweet = %Tweet{
      source: ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>),
      text: "参加者募集！参戦ID：ABCD1234\nLv75 セレスト・マグナ\n"
    }
    raid = Raid.parse_raid_tweet(tweet)

    assert raid == %{message: "", battle_id: "ABCD1234",
                     boss_name: "Lv75 セレスト・マグナ", url: ""}
    assert Raid.valid_raid?(raid)
  end

  test "parse and check a daily fresh tweet" do
    tweet = %Tweet{
      source: ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>),
      text: "参加者募集！参戦ID：ABCD1234\nLv75 セレスト・マグナ スマホRPGは今これをやってるよ。今の推しキャラはこちら！　ゲーム内プロフィール→　https://t.co/5Xgohi9wlE https://t.co/Xlu7lqQ3km"
    }
    raid = Raid.parse_raid_tweet(tweet)

    assert raid == %{message: "", battle_id: "ABCD1234", url: "",
                     boss_name: "Lv75 セレスト・マグナ スマホRPGは今これをやってるよ。今の推しキャラはこちら！　ゲーム内プロフィール→　https://t.co/5Xgohi9wlE https://t.co/Xlu7lqQ3km"}
    assert !Raid.valid_raid?(raid)
  end

  test "parse and check another daily fresh tweet" do
    tweet = %Tweet{
      source: ~s(<a href="http://granbluefantasy.jp/" rel="nofollow">グランブルー ファンタジー</a>),
      text: "参加者募集！参戦ID：ABCD1234\nLv75 セレスト・マグナ\nスマホRPGは今これをやってるよ。今の推しキャラはこちら！　ゲーム内プロフィール→　https://t.co/5Xgohi9wlE https://t.co/Xlu7lqQ3km"
    }
    raid = Raid.parse_raid_tweet(tweet)

    assert raid == %{message: "", battle_id: "ABCD1234",
                     boss_name: "Lv75 セレスト・マグナ",
                     url: "スマホRPGは今これをやってるよ。今の推しキャラはこちら！　ゲーム内プロフィール→　https://t.co/5Xgohi9wlE https://t.co/Xlu7lqQ3km"}
    assert !Raid.valid_raid?(raid)
  end
end
