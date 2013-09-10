class FakeHelu
  attr_reader :product_id
  attr_accessor :storage, :winning, :restore, :fail

  def initialize(product_id)
    @produc_id = product_id
  end

  def bought?
    #TODO. Be able to switch this
    false
  end

  def close
    # just implementing Helu's interface
  end

  def buy
    winning.call(fake_transaction)
  end

  def fake_fail
    # TODO: We need to implement a way to fake a fail
  end

  def restore
    winning.call(fake_transaction)
  end

  private 

  def fake_transaction
    ""
  end
end
