require_relative "test_helper"

class OwnershipTest < Minitest::Test
  def setup
    super
    $current_owner = nil
  end

  def test_job
    TestJob.perform_now
    assert_equal :logistics, $current_owner
  end

  def test_around
    owner :logistics do
      $around_calls << "middle"
    end
    assert_equal $around_calls, ["start", "middle", "finish"]
  end

  def test_exception
    error = assert_raises do
      owner :logistics do
        raise "boom"
      end
    end
    assert_equal error.owner, :logistics
  end

  def test_respond_to?
    assert !nil.respond_to?(:owner)
  end

  def test_method_owner
    assert_equal Kernel, method(:puts).owner
  end

  def test_pry
    assert_equal Kernel, Pry::Method.new(method(:puts)).wrapped_owner.wrapped
  end
end
