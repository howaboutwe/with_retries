require "with_retries/version"

module Kernel
  def with_retries(errors, params = {}, &block)
    attempts = params[:attempts] or
      raise ArgumentError.new("Attempts parameter not provided")
    logger = params[:logger]

    begin
      yield
    rescue *errors
      attempts -= 1

      if logger
        times = (attempts == 1 ? "time" : "times")

        logger.warn(
          "Attempt failed: #{errors}. Retrying #{attempts} more #{times}"
         )
      end

      attempts > 0 ? retry : raise
    end
  end
end

