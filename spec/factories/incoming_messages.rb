# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :incoming_message do
    timestamp Time.now

    body '{"snr": -14.2, "fcnt": "06E2", "rssi": -116, "tmst": 2574036324,'\
      '"devAddr": "DEVICE_EUI", "payload": "FfQAeAAZAF8ADQAEAE4CxA==",'\
      '"rawData": "QIHwGgAA4gYBGLJJLXgu", "dataRate": "SF12BW125",'\
      '"micValid": "true", "frequency": 867.1,'\
      '"localTime": "2017-02-11 21:13:31", "gatewayEui": "GATEWAY_EUI",'\
      '"packetTime": "2017-02-11T20:13:29.698503Z", "packetsLeft": 0,'\
      '"packetIdentifier": "95972e15fd409b3079385c7adb4ad1b6"}'
  end
end
