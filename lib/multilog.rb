class MultiLog
  def initialize(*args)
    @loggers = args
  end

  def method_missing(symbol, *args)
    @loggers.each do |logger|
      logger.send(symbol, *args)
    end
  end
end