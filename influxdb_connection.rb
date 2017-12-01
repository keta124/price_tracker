require 'influxdb'
module InfluxConnection

  def self.connection
    InfluxDB::Client.new 'adayroi_price_tracker',
      host: 'localhost',
      username: 'sontn',
      password: 'Son@1123',
      time_precision: 's'
  end

end