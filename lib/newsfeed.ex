defmodule Newsfeed do

	def createfeed() do
      feedtable = :ets.new(:feed, [:set, :public, :named_table])
      {:ok, pid} = GenServer.start_link(__MODULE__,[], name: :feed)
      :ets.insert(:services, {"feedpid" , pid})
    end

    def init(state) do    
    	{:ok, state}
  	end

  	def handle_cast({:displayfeed, username}, state) do
    	if(true) do
        [{_, feed}] = :ets.lookup(:feed, username)
        # IO.inspect "#{username}'s feed:"
        # IO.inspect "#{feed}"
        Enum.each(feed, fn x -> 
          # IO.inspect x
        end)
      end
    	{:noreply, state}
 	  end

    def handle_cast({:broadcast, username, tweet}, state) do
      [{_uname, feed}] = :ets.lookup(:feed, username)
      feed = feed ++ [tweet]
      :ets.insert(:feed, {username, feed})
      f = findfollower(username)
      Enum.each(f, fn x ->
        if(:ets.member(:feed, x)) do
        [{_uname, feed}] = :ets.lookup(:feed, x)
          newtweet = "#{username} tweeted: #{tweet}"
          if(String.contains?(tweet, "retweet")) do newtweet = tweet end
          feed = feed ++ [newtweet]
          :ets.insert(:feed, {x, feed})
        end
      end)
      {:noreply, state}
    end

  def findfollower(username) do
    [{_uname, followers}] = :ets.lookup(:followers, username)
    followers
  end

  def findtweets(username) do
    [{_uname, tweets}] = :ets.lookup(:tweets, username)
    tweets
  end

  def handle_cast({:deletefromothersfeed, username}, state) do
      f = findfollower(username)
      t = findtweets(username)
      Enum.each(f, fn x ->
        if(:ets.member(:feed, x)) do
          [{_uname, feed}] = :ets.lookup(:feed, x)
          newtweet = "#{username} tweeted: #{t}"
          feed = feed -- [newtweet]
          :ets.insert(:feed, {x, feed})
        end
      end)
      {:noreply, state}
    end

end