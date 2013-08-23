# Helu

[![Build Status](https://travis-ci.org/ivanacostarubio/helu.png)](https://travis-ci.org/ivanacostarubio/helu)

In-App purchases for RubyMotion.

![Money](https://raw.github.com/ivanacostarubio/helu/readme/resources/money.jpg)

## Installation

Add this line to your application's Gemfile:

    gem 'helu'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install helu
    
Include the StoreKit framework in your Rakefile:

    app.frameworks += ['StoreKit']

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


#### Make sure that if your code ever throws out the Helu object, it better also close the store before doing so.

    @helu.close

### Supported types of In App Purchases

+ Consumables and Non-Consumables are supported. 
+ Auto-Renewable subscriptions and Non-Renewing Subscriptions are not supported yet. However, we would love some help making it happen. 

### Requesting product information: 

Asynchronous, raw:

    inapps = %w[first second third]
    @x = Helu::ProductInfoFetcher.new(inapps) do |pi|
      p pi
    end

Asynchronous, wrapped in method call:

    Helu::ProductInfoFetcher.fetch(inapps) do |pi|
      p pi
    end

Synchronous:

    pi = Helu::ProductInfoFetcher.fetch(inapps)
    p pi


All three calls return hash of the following form:

    {
      "inapp_id": {
        id: "inapp_id",
        title: "inapp_localized_title",
        description: "inapp_localized_description",
        price: "0.89", # float
        currency: "EUR",
        price_str: "\u20AC0.89",
      }, # .... 
    }


## Example App: 

[You can find an example app here](https://github.com/ivanacostarubio/helu-example). 
Remember that for this to work properly, you must add your app identifier to the Rakefile.
 

## License

Helu is relase under the [MIT license](http://opensource.org/licenses/MIT).
