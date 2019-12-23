defmodule Client do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def init(state) do
    {:ok, state}
  end

  def get_tweets(username) do
    [{uname, pid}] = :ets.lookup(:users_table, username)
    [tweets, _, _] = GenServer.call(pid, {:get_tweets})
    tweets
  end

  def get_following(username) do
    [{uname, pid}] = :ets.lookup(:users_table, username)
    [_, following, _] = GenServer.call(pid, {:get_following})
    following
  end

  def get_followers(username) do
    [{uname, pid}] = :ets.lookup(:users_table, username)
    [_, _, followers] = GenServer.call(pid, {:get_followers})
    followers
  end

  def add_tweet(username, tweet) do
     [{uname, pid}] = :ets.lookup(:users_table, username)
     GenServer.cast(pid, {:add_tweet, tweet})
  end

  def add_follower(username, follower) do
    [{uname, pid}] = :ets.lookup(:users_table, username)
    GenServer.cast(pid, {:add_follower, follower})
    [{uname, pid}] = :ets.lookup(:users_table, username)
    add_following(follower, username)
  end

  def add_following(username, following) do
    [{uname, pid}] = :ets.lookup(:users_table, username)
    GenServer.cast(pid, {:add_following, following})
  end

  def handle_call({:get_tweets}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_following}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_followers}, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:add_follower, username}, state) do
    [_tweets, _following, followers] = state
    state = [_tweets, _following, [username | followers]]
    {:noreply, state}
  end

  def handle_cast({:add_tweet, tweet}, state) do
    [tweets, _following, _followers] = state
    state = [[tweet | tweets], _following, _followers]
    {:noreply, state}
  end

  def handle_cast({:add_following, username}, state) do
    [_tweets, following, _followers] = state
    state = [_tweets, [username | following], _followers]
    {:noreply, state}
  end

end