class Holiday
  attr_reader :date, :name

  def initialize(data)
    @date = data[:date]
    @name = data[:localName]
  end

end
