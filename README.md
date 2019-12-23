
# PROJECT 4.1:  Twitter Clone Using Elixir

### COP5615 - Distributed Operating Systems Principles

In this project, we use Elixir to make a Twitter engine. The basic functionalities of the engine include creating and deleting users, publishing and distributing tweets, retweeting, hashtags, and mentions. To demonstrate the project, we generate a number of users and make them follow each other, tweet, retweet, mention each other and use hashtags. This functionality is the basis for the Twitter application to be created in project 4.2.   

## Team Members:
1.	Karan Manghani (UFID: 7986-9199) Email: karanmanghani@ufl.edu 
2.	Yaswanth Bellam (UFID: 2461-6390) Email: yaswanthbellam@ufl.edu 


## Steps to run the code: 
1.	Clone/Download the file
2.	Using CMD/ terminal, go the directory where you have downloaded the zip file
3.	Enter the project's source code directory
4.	Run the command “mix run proj4.exs numUsers numTweets” 

### Example: 
```sh
mix run proj4.exs 10 10
```

## Functionalities
Our project provides the following functionalities: 
•	Create account 
•	Making tweets 
•	Following users 
•	Retweets 
•	Hashtags 
•	Mentions 
•	Delete account 

## Tests using ExUnit: 

Tests Created: 
•	Creating account 
•	Following users 
•	Tweeting 
•	Deleting account 
•	Mentions 
•	Hashtags 

## Steps to the run the tests:
1.	To run all the tests, cd into the project folder and use the command “mix test”.
2.	To run individual tests, use the line number of the test case with the command “mix test test/project4_test.exs:{line_number}”.

### Example: 
```sh 
mix test test/project4_test.exs:60
```
**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `project4` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:project4, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/project4](https://hexdocs.pm/project4).

