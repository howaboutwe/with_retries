require "with_retries/version"

module Kernel
  def with_retries(errors, params = {}, &block)
    attempts = params[:attempts] or
      raise ArgumentError.new("Attempts parameter not provided")

    begin
      yield
    rescue *errors
      attempts -= 1
      attempts > 0 ? retry : raise
    end
  end
end

