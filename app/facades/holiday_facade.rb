class HolidayFacade

  def holidays
    holiday_data.map do|holiday|
      Holiday.new(holiday)
    end
  end

  def holiday_data
    @_holiday_data ||= service.get_repo
  end

  def service
    @_service ||= HolidayService.new
  end

end
