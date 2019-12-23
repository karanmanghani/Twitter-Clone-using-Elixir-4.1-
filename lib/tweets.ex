defmodule Tweets do

	def createtweets() do
      _tweetstable = :ets.new(:tweets, [:set, :public, :named_table])
      {:ok, pid} = GenServer.start_link(__MODULE__,[], name: :tweets)
      :ets.insert(:services, {"tweetspid" , pid})
    end

    def init(state) do    
    	{:ok, state}
  	end

  def handle_cast({:inserttweets, username, tweet}, state) do
    	  [{_uname, t}] = :ets.lookup(:tweets, username)
      	t = t ++ [tweet]
      	:ets.insert(:tweets, {username, t})
      	# IO.inspect "#{username} tweeted: #{tweet}"
        mentionsworker(tweet)
        hashtagworker(tweet)
      	[{_,fpid}] = :ets.lookup(:services, "feedpid")
    	  GenServer.cast(fpid, {:broadcast, username, tweet})
    	{:noreply, state}
 	end

  def mentionsworker(tweet) do
    mentioned = findmention(tweet)
    [{_,mpid}] = :ets.lookup(:services, "mentionspid")
    GenServer.cast(mpid, {:updatementions, tweet, mentioned})
  end

  def hashtagworker(tweet) do
    hashtagused = findhashtag(tweet)
    [{_,hpid}] = :ets.lookup(:services, "hashtagspid")
    GenServer.cast(hpid, {:updatehashtags, hashtagused})
  end

 	def findmention(tweet) do
    	mentions = Regex.scan(~r/\B@[á-úÁ-Úä-üÄ-Üa-zA-Z0-9_]+/, tweet) |> Enum.concat
    	mentions
  	end

  	def findhashtag(tweet) do
    	hash = Regex.scan(~r/\B#[á-úÁ-Úä-üÄ-Üa-zA-Z0-9_]+/, tweet) |> Enum.concat
    	hash
  	end

end