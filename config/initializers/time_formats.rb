# frozen_string_literal: true

# For example: 04/12/2019
Time::DATE_FORMATS[:day_month_year_slashes] = "%d/%m/%Y"
# For example: 04/12/2019 15:01
Time::DATE_FORMATS[:day_month_year_time_slashes] = "%d/%m/%Y %H:%M"
# For example: Monday 2 December 2019 at 6:53pm
Time::DATE_FORMATS[:weekday_day_month_year_at_time] = "%A %e %B %Y at %l:%M%P"
# For example: 2 December 2019
Time::DATE_FORMATS[:day_month_year] = "%d %B %Y"
# For example: 2019-12-02
Time::DATE_FORMATS[:year_month_day_hyphens] = "%Y-%m-%d"
# For example: 2019-11-19T00:00Z
Time::DATE_FORMATS[:calendar_date_and_local_time] = "%FT%H:%MZ"
