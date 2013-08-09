=begin
# Sample use:
## Asynchronous, raw:
inapps = %w[first second third]
@x = Helu::ProductInfoFetcher.new(inapps) do |pi|
  p pi
end

## Asynchronous, wrapped in method call:
Helu::ProductInfoFetcher.fetch(inapps) do |pi|
  p pi
end

## Synchronous:
pi = Helu::ProductInfoFetcher.fetch(inapps)
p pi


# All three calls return hash of the following form:
# {
#   "inapp_id": {
#     id: "inapp_id",
#     title: "inapp_localized_title",
#     description: "inapp_localized_description",
#     price: "0.89", # float
#     currency: "EUR",
#     price_str: "\u20AC0.89",
#   },
#   # ...
# }
=end
class Helu
  class ProductInfoFetcher
    @@mutex = Mutex.new
    @@cache = {}
    def initialize(*products, &b)
      raise LocalJumpError, "block expected" if b.nil?
      @callback = b
      @products = products.flatten

      # all cached? skip the call...
      if (@@cache.keys & @products).sort == @products.sort
        h = @products.inject({}) { |m, prod| m[prod] = @@cache[prod]; m }
        @callback.call(h)
      else
        @sr = SKProductsRequest.alloc.initWithProductIdentifiers(@products)
        @sr.delegate = self
        @sr.start
      end

      self
    end

    def productsRequest(req, didReceiveResponse: resp)
      if resp.nil?
        @callback.call(nil)
      else
        h = resp.products.inject({}) { |m, prod|
          m.merge(sk_to_hash(prod))
        }
        @@mutex.synchronize { @@cache.merge!(h) }
        @callback.call(h)
      end
    end

    private

    def sk_to_hash(sk)
      nf = NSNumberFormatter.alloc.init
      nf.setFormatterBehavior(NSNumberFormatterBehavior10_4)
      nf.setNumberStyle(NSNumberFormatterCurrencyStyle)
      nf.setLocale(sk.priceLocale)
      price_str = nf.stringFromNumber(sk.price)

      {
        sk.productIdentifier => {
        id: sk.productIdentifier,
        title: sk.localizedTitle,
        description: sk.localizedDescription,
        price: sk.price,
        currency: sk.priceLocale.objectForKey(NSLocaleCurrencyCode),
        price_str: price_str,
      }
      }
    end

    class <<self
      # make a sync call out of an async one
      def call_synchronized(method, *args)
        finished = false
        result = nil
        send(method, *args) do |res|
          result = res
          finished = true
        end
        sleep 0.1 until finished
        result
      end

      def fetch(*products, &b)
        products.flatten!
        if b.nil?
          call_synchronized(:fetch, *products)
        else
          new(*products, &b)
        end
      end

      def clear_cache
        @@mutex.synchronize { @@cache = {} }
      end
    end

  end
end
