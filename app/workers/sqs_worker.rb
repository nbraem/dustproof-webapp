class SqsWorker
  include Shoryuken::Worker

  shoryuken_options queue: "dustproof-queue-#{Rails.env.to_s}",
                    auto_delete: true

  def perform(sqs_msg, body)
    sent_timestamp = sqs_msg.attributes['SentTimestamp'].to_i / 1000
    IncomingMessage.create! body: body,
                            timestamp: Time.at(sent_timestamp)
  end
end
