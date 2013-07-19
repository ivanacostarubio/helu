# helu

[![Build Status](https://travis-ci.org/ivanacostarubio/helu.png)](https://travis-ci.org/ivanacostarubio/helu)


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

    @helu.fail = lambda { |transaction| puts transaction ; # node here for failed in app purchase }
    @helu.winning = lambda { |transaction| puts transaction ; # code here for successful in app purchase }

#### also for restoring in app purchases

	 @helu.restore = lambda { restoring_method }


The transaction object on the lambda is the one we get from Apple; Therefore, it is a SKPaymentTransaction. [More information about it here](http://developer.apple.com/library/ios/#documentation/StoreKit/Reference/SKPaymentTransaction_Class/Reference/Reference.html)



####  buy the product:

    @helu.buy

#### restore the product:

	@helu.restore


### Make sure that if your code ever throws out the Helu object, it better also close the store before doing so.

    @helu.close


## Example App: 

[You can find an example app here](https://github.com/ivanacostarubio/helu-example). Remember that for this to work properly, you must add your app identifier to the Rakefile.
    
    
## Supported types of In App Purchases

+ Consumables and Non-Consumables are supported. 
+ Auto-Renewable subscriptions and Non-Renewing Subscriptions are not supported yet. However, we would love some help making it happen. 
