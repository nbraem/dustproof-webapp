class IncomingMessage < ActiveRecord::Base
  def device_eui
    if proximus?
      self.body['DevEUI_uplink']['DevAddr']
    else
      self.body['devAddr']
    end
  end

  def gateway_eui
    if lora?
      if proximus?
        'Proximus LoRa network'
      else
        self.body['gatewayEui']
      end
    else
      "WiFi"
    end
  end

  def frequency
    self.body['frequency'] unless proximus?
  end

  def rssi
    if proximus?
      self.body['DevEUI_uplink']['LrrRSSI']
    else
      self.body['rssi']
    end
  end

  def snr
    if proximus?
      self.body['DevEUI_uplink']['LrrSNR']
    else
      self.body['snr']
    end
  end

  def data
    if wifi?
      self.body["measurement"]
    else
      if proximus?
        self.body['DevEUI_uplink']['payload_hex']
      else
        begin
          Base64.decode64(self.body['payload']).unpack("H*").first
        rescue
          ""
        end
      end
    end
  end

  def proximus?
    self.body.key?("DevEUI_uplink")
  end

  def wifi?
    self.body["transport"] == "wifi"
  end

  def lora?
    !wifi?
  end
end
