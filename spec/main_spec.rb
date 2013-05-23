#
# SKPaymentQueue
# + defaultQueue
#   - addTransactionObserver(observer)
#   - addPayment(product)
#   - finishTransaction(transaction)
# SKPayment
# + paymentWithProductIdentifier(id)
#

class FakeQueue

  attr_accessor :added_observer, :payment_sent

 def self.instance
    Dispatch.once { @instance ||= new }
    @instance
  end

  def addTransactionObserver(object)
    @added_observer = true
  end

  def addPayment(product)
    @payment_sent = true
  end

  def finishTransaction(transaction)
  end
end


class SKPaymentQueue
  def self.defaultQueue
    FakeQueue.instance
  end
end



class SKPayment

  def self.paymentWithProductIdentifier(id)
  end
end


describe "Application 'helu'" do

  before do
    @app = UIApplication.sharedApplication
  end

  it "adds the observer to self in initialization" do 
    FakeQueue.instance.added_observer.should == nil
    @carlos = Helu.new("wasa")
    FakeQueue.instance.added_observer.should == true
  end

  it "sends the payment to apple" do
    @carlos = Helu.new("wasa")
    FakeQueue.instance.payment_sent.should == nil
    @carlos.buy
    FakeQueue.instance.payment_sent.should == true
  end
end
