require 'spec_helper'

describe Kernel do
  describe "#with_retries" do
    Boom = Class.new(RuntimeError)

    context "when given valid parameters" do
      it "rescues the given error" do
        expect do
          attempt = 0
          with_retries(Boom, attempts: 3) do
            attempts += 1
            raise Boom.new if attempt < 3
          end
        end.to_not raise_error(Boom)
      end

      it "retries the block the given number of times" do
        Kernel.should_receive(:raise).exactly(3).times

        attempts = 0
        with_retries(Boom, attempts: 3) do
          attempts += 1
          raise Boom.new if attempts < 3
        end
        attempts.should == 3
      end

      it "raises the exception when the number of retries has been exceeded" do
        expect do
          with_retries(Boom, attempts: 2) { 3.times { raise Boom.new } }
        end.to raise_error(Boom)
      end

      it "does not retry unexpected exceptions" do
        unexpected_error = Class.new(RuntimeError)
        expect do
          with_retries(Boom, attempts: 2) { raise unexpected_error.new }
        end.to raise_error(unexpected_error)
      end

      context "when given a logger parameter" do
        let(:logger) { Logger.new(STDOUT) }

        it "logs a warning to the given logger" do
          logger.should_receive(:warn).exactly(5).times

          expect do
            with_retries(Boom, attempts: 5, logger: logger) do
              raise Boom.new
            end
          end.to raise_error
        end
      end

      context "when given a timeout parameter" do
        it "retries the block after sleeping for the provided timeout" do
          Kernel.should_receive(:sleep).with(5).twice

          expect do
            with_retries(Boom, attempts: 2, timeout: 5) do
              3.times do
                raise Boom.new
              end
            end
          end.to raise_error(Boom)
        end
      end

      context "when not given a timeout parameter" do
        it "does not sleep" do
          Kernel.should_not_receive(:sleep)

          expect do
            with_retries(Boom, attempts: 2) do
              3.times do
                raise Boom.new
              end
            end
          end.to raise_error(Boom)
        end
      end
    end

    context "when not given an attempts parameter" do
      it "raises an ArgumentError" do
        expect do
          with_retries(Boom) { raise Boom.new }
        end.to raise_error(ArgumentError, "Attempts parameter not provided")
      end
    end
  end
end
