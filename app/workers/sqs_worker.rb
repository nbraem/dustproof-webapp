class SqsWorker
  include Shoryuken::Worker

  shoryuken_options queue: "dustproof-queue-#{Rails.env.to_s}",
                    auto_delete: true

  def perform(sqs_msg, body)
    IncomingMessage.create! body: body, status: "new"
    puts "Received message: #{body}"
  end
end
