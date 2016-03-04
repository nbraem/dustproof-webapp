class SqsWorker
  include Shoryuken::Worker

  shoryuken_options queue: "dustproof-queue-#{Rails.env.to_s}",
                    auto_delete: true

  def perform(sqs_msg, body)
    sent_timestamp = sqs_msg.attributes['SentTimestamp'].to_i / 1000
    incoming_message = IncomingMessage.new body: body,
      timestamp: Time.at(sent_timestamp),
      status: "new"
    if incoming_message.save
      puts "Saved incoming message: #{body}"
    else
      puts "Discarded incoming message: #{incoming_message.errors.full_messages.to_sentence}"
    end
  end
end
