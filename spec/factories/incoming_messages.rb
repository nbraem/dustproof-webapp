# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :incoming_message do
    status "new"
    timestamp Time.now

    body '{"gatewayEui":"GATEWAY_EUI","devAddr":"DEVICE_EUI",'\
            '"packetTime":"2016-03-14T11:51:19.783817Z","tmst":3969010612,'\
            '"frequency":868.1,"dataRate":"SF12BW125","rssi":-120,'\
            '"snr":-14.2,"payload":"FfQAeAAZAF8ADQAEAE4CxA=="}'

    trait :with_lora_data_from_different_device_eui do
      body '{"gatewayEui":"GATEWAY_EUI","devAddr":"ANOTHER_DEVICE_EUI",'\
              '"packetTime":"2016-03-14T11:51:19.783817Z","tmst":3969010612,'\
              '"frequency":868.1,"dataRate":"SF12BW125","rssi":-120,'\
              '"snr":-14.2,"payload":"FfQAeAAZAF8ADQAEAE4CxA=="}'
    end

    trait :with_invalid_lora_data do
      body '{"gatewayEui":"GATEWAY_EUI","devAddr":"DEVICE_EUI",'\
              '"packetTime":"2016-03-14T11:51:19.783817Z","tmst":3969010612,'\
              '"frequency":868.1,"dataRate":"SF12BW125","rssi":-120,'\
              '"snr":-14.2,"payload":null}'
    end

    trait :via_wifi do
      body '{"api_key":"API_KEY","transport":"wifi",'\
              '"measurement":"00000a8e05b704d800f300be003d0337"}'
    end

    factory :incoming_message_with_lora_data, traits: [:with_lora_data]
    factory :incoming_message_with_lora_data_from_another_device_eui,
      traits: [:with_lora_data_from_different_device_eui]
    factory :incoming_message_with_invalid_lora_data, traits: [:with_invalid_lora_data]
    factory :incoming_message_via_wifi, traits: [:via_wifi]
  end
end
