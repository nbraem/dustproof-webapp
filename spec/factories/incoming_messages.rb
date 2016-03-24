# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :incoming_message do
    status "new"
    timestamp Time.now

    body '{"gatewayEui":"GATEWAY_EUI","deviceEui":"DEVICE_EUI",'\
            '"packetTime":"2016-03-14T11:51:19.783817Z","tmst":3969010612,'\
            '"frequency":868.1,"dataRate":"SF12BW125","rssi":-120,'\
            '"snr":-14.2,"data":"AA0BLwAWADsABSb8Jvw="}'

    trait :with_lora_data_from_different_device_eui do
      body '{"gatewayEui":"GATEWAY_EUI","deviceEui":"ANOTHER_DEVICE_EUI",'\
              '"packetTime":"2016-03-14T11:51:19.783817Z","tmst":3969010612,'\
              '"frequency":868.1,"dataRate":"SF12BW125","rssi":-120,'\
              '"snr":-14.2,"data":"AA0BLwAWADsABSb8Jvw="}'
    end

    trait :with_invalid_lora_data do
      body '{"gatewayEui":"GATEWAY_EUI","deviceEui":"DEVICE_EUI",'\
              '"packetTime":"2016-03-14T11:51:19.783817Z","tmst":3969010612,'\
              '"frequency":868.1,"dataRate":"SF12BW125","rssi":-120,'\
              '"snr":-14.2,"data":null}'
    end

    trait :via_wifi do
      body '{"api_key":"API_KEY","transport":"wifi",'\
              '"measurement":{"ratioPM25": 0,"ratioP2": 0,"nP1": 0,"nP2": 0}}'
    end

    factory :incoming_message_with_lora_data, traits: [:with_lora_data]
    factory :incoming_message_with_lora_data_from_another_device_eui,
      traits: [:with_lora_data_from_different_device_eui]
    factory :incoming_message_with_invalid_lora_data, traits: [:with_invalid_lora_data]
    factory :incoming_message_via_wifi, traits: [:via_wifi]
  end
end
