module ApplicationHelper

  def status_row_class(status)
    case status.to_sym
      when :not_working
        :info
      when :working
        :success
      when :in_lunch
        :warning
    end
  end
end
