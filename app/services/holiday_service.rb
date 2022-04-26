class HolidayService

  def get_repo
    get_url("https://date.nager.at/api/v1/Get/US/2022")
  end

  def get_url
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

end
