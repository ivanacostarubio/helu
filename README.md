# helu

## Installation

Add this line to your application's Gemfile:

    gem 'helu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install helu

## USAGE

Start a helu with the In App Purchase ID:

    @helu = Helu.new("loosing_weight_10")


#### create blocks for failing and buying: 

    fail_block = lambda { # node here for failed in app purchase }
    buy_block = lambda { # code here for successful in app purchase }

    @helu.fail = fail_block
    @helu.winning = winning_block

####  buy the product: 

    @helu.buy