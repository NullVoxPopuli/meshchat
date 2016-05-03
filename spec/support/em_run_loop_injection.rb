RSpec::Core::Example.class_eval do
  alias ignorant_run run

  def run(example_group_instance, reporter)
    result = false

    Fiber.new do
      EM.run do
        df = EM::DefaultDeferrable.new
        df.callback do |test_result|
          result = test_result
          # stop if we are still running.
          # We won't be running if something inside the test
          # stops the run loop.
          EM.stop if EM.reactor_running?
        end
        test_result = ignorant_run example_group_instance, reporter
        df.set_deferred_status :succeeded, test_result
      end
    end.resume

    result
  end
end
