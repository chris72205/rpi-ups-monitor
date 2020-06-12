class NutAdapter
  def initialize ups_name
    @ups_name = ups_name
  end

  def current_load
    values = parse_response call_upsc

    calculate_watts values['ups.realpower.nominal'].to_f, values['ups.load'].to_f
  end

  private

    def call_upsc
      `upsc #{@ups_name}`
    end

    def calculate_watts nominal_power, load_percentage
      (load_percentage / 100) * nominal_power
    end

    def parse_response raw_response
      {}.tap do |hash|
        raw_response.split("\n").each do |line|
          key_value = line.split(":")

          hash[key_value.first.strip] = key_value.last.strip
        end
      end
    end

end