require 'yaml'
require "net/http"
require "uri"
require 'cgi'
class Sms
  def self.load_config
    YAML.load_file File.expand_path("#{Rails.root}/config/config.yml", __FILE__)
  end

  def self.execute(number,message)
    params = {"u" => self.load_config['sms_gateway']['username'],
              "p" => self.load_config['sms_gateway']['password'],
              "s" => self.load_config['sms_gateway']['sender'],
              "r" => self.msisdn_corrector(number),
              "m" => message,
              "t" => 1}

    url = self.load_config['sms_gateway']['url'] + "?u=" + params["u"] + "&p=" + params["p"] + "&s=" + params["s"] + "&r=" + params["r"] + "&m=" + URI.encode(params["m"]) + "&t=" + params["t"].to_s
    response = Net::HTTP.get_response(URI.parse(url))
    case
    when response.body.to_s.include?("00")
      Rails.logger.info "Successful"
    when response.body.to_s.include?("11")
      Rails.logger.info "Missing username"
    when response.body.to_s.include?("12")
      Rails.logger.info "Missing password"
    when response.body.to_s.include?("13")
      Rails.logger.info "Missing receipient"
    when response.body.to_s.include?("14")
      Rails.logger.info "Missing sender id"
    when response.body.to_s.include?("15")
      Rails.logger.info "Missing message"
    when response.body.to_s.include?("21")
      Rails.logger.info "Sender Id too long"
    when response.body.to_s.include?("22")
      Rails.logger.info "INVALID RECIPIENT"
    when response.body.to_s.include?("23")
      Rails.logger.info "INVALID MESSAGE"
    when response.body.to_s.include?("31")
      Rails.logger.info "INVALID USERNAME"
    when response.body.to_s.include?("32")
      Rails.logger.info "INVALID PASSWORD"
    when response.body.to_s.include?("33")
      Rails.logger.info "INVALID LOGIN"
    when response.body.to_s.include?("34")
      Rails.logger.info "ACCOUNT DISABLED"
    when response.body.to_s.include?("41")
      Rails.logger.info "INSUFFICIENT CREDIT"
    when response.body.to_s.include?("51")
      Rails.logger.info "GATEWAY UNREACHABLE"
    when response.body.to_s.include?("52")
      Rails.logger.info "SYSTEM ERROR"
    else
      Rails.logger.info "Unrecoverable error"
    end
  end

  def self.msisdn_corrector(msisdn)
    case 
    when msisdn[0] == "0"
      msisdn[0] = "234"
    when ((msisdn[0] != "0") && msisdn.size == 10)
      msisdn = "234" + msisdn
    when ((msisdn[0] != "0") && msisdn.size != 11)
      msisdn = msisdn
    else
    end
    msisdn
  end

end
