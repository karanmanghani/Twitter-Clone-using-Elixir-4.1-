defmodule Project do
  use GenServer

  def start(data) do
    numusers = Enum.at(data, 0)
    numtweets = Enum.at(data, 1)
    :ets.new(:services, [:set, :public, :named_table])

    start_time = System.system_time(:millisecond)
    
    Server.start_link()
    Server.createaccounts()
    Active.createactiveusers()
    Process.sleep(1000)
    Follower.createf()
    Tweets.createtweets()
    Hashtags.createhashtags()
    Mentions.creatementions()
    Newsfeed.createfeed()
    
    intialize(numusers)
    activelist = activateusers(numusers)
    addfollowers(numusers)
    Process.sleep(1000)


    time_tables = System.system_time(:millisecond)
    IO.inspect "Time to create tables: #{time_tables - start_time}ms"

    tweet_start = System.system_time(:millisecond)
    tweeter(numusers,numtweets)
    Process.sleep(1000)

    tweet_end = System.system_time(:millisecond)
    IO.inspect "Time taken for users to tweet #{numtweets} tweets: #{tweet_end - tweet_start}ms"

    user1 = "user#{Enum.at(activelist,0)}"
    user2 = "user#{Enum.at(activelist,1)}"
    retweet_start = System.system_time(:millisecond)
    retweet(user1, user2)
    retweet_end = System.system_time(:millisecond)
    IO.inspect "Time to retweet is: #{retweet_end - retweet_start}ms"
    view_start = System.system_time(:millisecond)
    Enum.each(1..numusers, fn x-> viewfeed("user#{x}") end)
    Process.sleep(1000)
    view_end = System.system_time(:millisecond)
    IO.inspect "Time to view news feed: #{view_end - view_start} ms"
    del(activelist)
    Process.sleep(1000)
    Enum.each(1..numusers, fn x-> 
      if(:ets.member(:tweets, "user#{x}")) do
          # viewfeed("user#{x}") 
        end
      end)

    Process.sleep(1000)
    end_time = System.system_time(:millisecond)
    IO.inspect "Total time taken: #{end_time - start_time}ms"

  end

  def tweeter(numusers, numtweets) do
    Enum.map(1..numusers, fn x ->
      username = "user#{x}"
      if(checkifactive(username)) do
        Enum.each(1..numtweets, fn _b->  
          generate_tweets(username,numusers) 
        end)
      end
    end)
  end

  def del(activelist) do
  	tbd = Enum.take_random(activelist,2)
    Enum.each(tbd, fn x->
      y = "user#{x}"
      # IO.inspect "#{y} will be deleted"
      delete_start = System.system_time(:millisecond)
      delete_user(y)
      delete_end = System.system_time(:millisecond)
      IO.inspect "Time to delete account: #{delete_end - delete_start}ms"
    end)
  end

  def viewfeed(username) do
    [{_,pid}] = :ets.lookup(:services, "feedpid")
    GenServer.cast(pid, {:displayfeed, username})
  end

  def addfollowers(numusers) do
    [{_,pid}] = :ets.lookup(:services, "followerspid")
    GenServer.cast(pid, {:addfollowers, numusers})
  end

  def activateusers(numusers) do
    count = numusers /2 |> trunc()
    l = Enum.take_random(1..numusers, count)
    [{_,apid}] = :ets.lookup(:services, "activeusers")
    GenServer.cast(apid, {:activate, l})
    l
  end

  def generate_tweets(username,numusers) do
    usernum = String.at(username, 4) |> String.to_integer()
    randlist = List.delete(Enum.to_list(1..numusers), usernum)
    randommention = "user#{Enum.random(randlist)}"
    ht = ["#GoGators", "#COP5615", "#DOS", "#Gators"]
    hashtag = Enum.random(ht)
    tweet = "Hi! @#{randommention} #{hashtag}"
    Client.add_tweet(username, tweet)
    castthetweet(username,tweet)
  end

  def castthetweet(username,tweet) do
    [{_,pid}] = :ets.lookup(:services, "tweetspid")
    GenServer.cast(pid, {:inserttweets, username, tweet})
  end

  def intialize(numusers) do
    Enum.map(1..numusers, fn x ->
      username = "user#{x}"
        # IO.inspect "Creating #{username}"
        upid = create_user([["User Tweets"], ["Following"], ["Followers"]])
        :ets.insert(:users_table, {username, upid})
        :ets.insert(:tweets, {username, []})
        :ets.insert(:mentions, {username, []})
        :ets.insert(:followers, {username, []})
        :ets.insert(:feed, {username, []})
        :ets.insert(:hashtags, {"#GoGators" , 0})
        :ets.insert(:hashtags, {"#COP5615",0})
        :ets.insert(:hashtags, {"#DOS",0})
        :ets.insert(:hashtags, {"#Gators",0})
        # IO.inspect "#{username} created"
      end)
  end

  def checkifactive(username) do
    x = :ets.member(:active_users, username)
    x
  end


  def retweet(user1 , user2) do
    [{_uname, tweet}] = :ets.lookup(:tweets, user2)
    toberetweeted = Enum.at(tweet,0)
    [{_,zpid}] = :ets.lookup(:services, "tweetspid")
    retweet = "#{user1} retweeted #{user2}'s tweet: #{toberetweeted}"
    GenServer.cast(zpid, {:inserttweets, user1, retweet})
  end

  def create_user(state) do
    {:ok, pid} = Client.start_link(state)
    pid
  end

  def delete_user(username) do
    # IO.inspect "Deleting user#{username}"
    if(checkifactive(username)) do
      deletefromothersfeed(username)
      Process.sleep(1000)
      delproc(username)
    end
    # IO.inspect "user#{username} deleted"
  end

  def delproc(username) do
    :ets.delete(:tweets, username)
    :ets.delete(:active_users, username)
    :ets.delete(:followers, username)
    :ets.delete(:feed, username)
  end

  def deletefromothersfeed(username) do
    [{_,pid}] = :ets.lookup(:services, "feedpid")
    GenServer.cast(pid, {:deletefromothersfeed, username})
  end

  def init(state) do
    {:ok, state}
  end

end