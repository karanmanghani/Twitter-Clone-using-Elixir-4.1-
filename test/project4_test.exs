defmodule Project4Test do
  use ExUnit.Case
  doctest Project

  def runner() do
    Server.start_link()
    Server.createaccounts()
    Active.createactiveusers()
    Follower.createf()
    Tweets.createtweets()
    Hashtags.createhashtags()
    Mentions.creatementions()
    Newsfeed.createfeed()
  end

  test "usertest1" do
  	runner()
    Project.intialize(2)
    assert :ets.member(:users_table,"user1")== true && :ets.member(:users_table,"user2") == true
  end

  test "usertest2" do
    runner()
    activelist = Project.activateusers(2)
    IO.inspect activelist
    assert :ets.member(:active_users,"user1")== true || :ets.member(:active_users,"user2") == true
  end

  test "usertest3" do
    runner()
    _activelist = Project.activateusers(2)
    refute :ets.member(:active_users,"user1")== true && :ets.member(:active_users,"user2") == true
  end

  test "Follower2" do
      runner()
      Project.intialize(2)
      _activelist =  Project.activateusers(2)
      #IO.inspect activelist
      Project.addfollowers(2)
      [{_a,b}] = :ets.lookup(:followers,"user1")
      [{_c,d}]  = :ets.lookup(:followers,"user2")
      assert b== [] && d== []
  end

  test "Follower4" do
      runner()
      Project.intialize(4)
      _activelist =  Project.activateusers(4)
      Project.addfollowers(4)
      Process.sleep(500)
      # Enum.each(1..4, fn x->  IO.inspect :ets.lookup(:followers,"user#{x}") end)
      [{_a,b}] = :ets.lookup(:followers,"user1")
      [{_c,d}]  = :ets.lookup(:followers,"user2")
      [{_e,f}] = :ets.lookup(:followers,"user3")
      [{_g,h}]  = :ets.lookup(:followers,"user4")
      refute b== [] && d== [] && f== [] && h== []
  end

  test "Follower6" do
      runner()
      Project.intialize(6)
      _activelist =  Project.activateusers(6)
      Project.addfollowers(6)
      Process.sleep(500)
      # Enum.each(1..6, fn x->  IO.inspect :ets.lookup(:followers,"user#{x}") end)
      [{_a,b}] = :ets.lookup(:followers,"user1")
      [{_c,d}]  = :ets.lookup(:followers,"user2")
      [{_e,f}] = :ets.lookup(:followers,"user3")
      [{_g,h}]  = :ets.lookup(:followers,"user4")
      [{_i,j}] = :ets.lookup(:followers,"user3")
      [{_k,l}]  = :ets.lookup(:followers,"user4")
      refute b== [] && d== [] && f== [] && h== [] && j== [] && l== [] 
  end

  test "Tweets4" do
      runner()
      Project.intialize(4)
      activelist =  Project.activateusers(4)
      Project.addfollowers(4)
      Process.sleep(500)
      Project.tweeter(4,2)
      Process.sleep(500)
      [{_a,b}] = :ets.lookup(:tweets,"user#{Enum.at(activelist,0)}")
      [{_c,d}]  = :ets.lookup(:tweets,"user#{Enum.at(activelist,1)}")
      refute b== [] || d== []
  end

  test "Tweets6" do
      runner()
      Project.intialize(6)
      activelist =  Project.activateusers(6)
      Project.addfollowers(6)
      Process.sleep(500)
      Project.tweeter(6,2)
      Process.sleep(500)
      [{_a,b}] = :ets.lookup(:tweets,"user#{Enum.at(activelist,0)}")
      [{_c,d}]  = :ets.lookup(:tweets,"user#{Enum.at(activelist,1)}")
      [{_e,f}]  = :ets.lookup(:tweets,"user#{Enum.at(activelist,2)}")
      refute b== [] || d== [] || f==[]
  end
  
  test "deletion1" do
      runner()
      Project.intialize(6)
      activelist =  Project.activateusers(6)
      Project.addfollowers(6)
      Process.sleep(500)
      Project.tweeter(6,2)
      Process.sleep(500)
      tbd = Enum.at(activelist,0)
      Project.delete_user(tbd)
      Process.sleep(500)
      assert :ets.member(:active_users,tbd) == false
  end

  test "deletion2" do
      runner()
      Project.intialize(6)
      activelist =  Project.activateusers(6)
      Project.addfollowers(6)
      Process.sleep(500)
      Project.tweeter(6,2)
      Process.sleep(500)
      tbd1 = Enum.at(activelist,0)
      tbd2 = Enum.at(activelist,1)
      Project.delete_user(tbd1)
      Project.delete_user(tbd2)
      Process.sleep(500)
      assert :ets.member(:active_users,tbd1) == false && :ets.member(:active_users,tbd2) == false
  end

  test "mentions1" do
      runner()
      Project.intialize(2)
      Process.sleep(500)
      Tweets.mentionsworker("Hey buddy @user1")
      Tweets.mentionsworker("Hey buddy @user2")
      Process.sleep(500)
      [{a,_b}] = :ets.lookup(:mentions, "user1")
      [{c,_d}] = :ets.lookup(:mentions, "user2")
      
      assert a == "user1" && c == "user2"
  end

  test "mentions2" do
      runner()
      Project.intialize(4)
      Process.sleep(500)
      Tweets.mentionsworker("Hey buddy @user1")
      Tweets.mentionsworker("Hey buddy @user2")
      Tweets.mentionsworker("Hey buddy @user3")
      Tweets.mentionsworker("Hey buddy @user4")
      Process.sleep(500)
      [{a,_b}] = :ets.lookup(:mentions, "user1")
      [{c,_d}] = :ets.lookup(:mentions, "user2")
      [{e,_f}] = :ets.lookup(:mentions, "user3")
      [{g,_h}] = :ets.lookup(:mentions, "user4")
      assert a == "user1" && c == "user2" && e =="user3" && g == "user4"
  end

  test "hash1" do
      runner()
      Project.intialize(2)
      Process.sleep(500)
      Tweets.hashtagworker("#DOS")
      Tweets.hashtagworker("#DOS")
      Tweets.hashtagworker("#Gators")

      Process.sleep(500)
      [{_a,b}] = :ets.lookup(:hashtags, "#DOS")
      [{_c,d}] = :ets.lookup(:hashtags, "#Gators")
      assert b==2 && d ==1
  end


   test "hash2" do
      runner()
      Project.intialize(2)
      Process.sleep(500)
      Tweets.hashtagworker("#DOS")
      Tweets.hashtagworker("#DOS")
      Tweets.hashtagworker("#DOS")
      Tweets.hashtagworker("#DOS")
      Tweets.hashtagworker("#DOS")
      Tweets.hashtagworker("#Gators")
      Tweets.hashtagworker("#GoGators")
      Tweets.hashtagworker("#GoGators")

      Process.sleep(500)
      [{_a,b}] = :ets.lookup(:hashtags, "#DOS")
      [{_c,d}] = :ets.lookup(:hashtags, "#Gators")
      [{_e,f}] = :ets.lookup(:hashtags, "#GoGators")
      assert b==5 && d ==1 && f==2
  end


    

end
