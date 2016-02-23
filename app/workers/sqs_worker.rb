class SqsWorker
  include Shoryuken::Worker

  shoryuken_options queue: "dustproof-queue-#{Rails.env.to_s}",
                    auto_delete: true

  def perform(sqs_msg, body)
    begin
      hash = JSON.parse(body)
    rescue => e
      STDERR.puts "Unable to parse message: #{e.message}"
      sqs_msg.delete
    end
    puts hash
  end
end
