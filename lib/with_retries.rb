require "with_retries/version"

module Kernel
  def with_retries(errors, params = {}, &block)
    attempts = params[:attempts] or
      raise ArgumentError.new("Attempts parameter not provided")
    logger = params[:logger]
    timeout = params[:timeout]

    begin
      yield
    rescue *errors => e
      attempts -= 1

      Kernel.sleep(timeout) if timeout

      if logger
        times = (attempts == 1 ? "time" : "times")

        logger.warn(
          "Attempt failed. Retrying #{attempts} more #{times}...\n" +
          ["#{e.class}: #{e.message}:", *e.backtrace].join("\n  ") +
          "\n"
         )
      end

      attempts > 0 ? retry : raise
    end
  end
end
