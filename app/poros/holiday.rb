require 'time'

class Holiday
  attr_reader :date, :name

  def initialize(data)
    @name = data[:localName]
    @date = DateTime.strptime(data[:date], '%Y-%m-%d')
  end

  def readable_date
    @date.strftime("%b %d, %Y")
  end

end
