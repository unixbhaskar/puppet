require 'benchmark'

# A simple profiling callback system.
#
# @api private
module Puppet::Util::Profiler
  require 'puppet/util/profiler/wall_clock'
  require 'puppet/util/profiler/object_counts'
  require 'puppet/util/profiler/none'

  NONE = Puppet::Util::Profiler::None.new

<<<<<<< HEAD
  # @returns This thread's configured profiler
=======
  # Reset the profiling system to the original state
  def self.clear
    @profiler = nil
  end

  # @return This thread's configured profiler
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
  def self.current
    Thread.current[:profiler] || NONE
  end

  # @param profiler [#profile] A profiler for the current thread
  def self.current=(profiler)
    Thread.current[:profiler] = profiler
  end

  # @param message [String] A description of the profiled event
  # @param block [Block] The segment of code to profile
  def self.profile(message, &block)
    current.profile(message, &block)
  end
end
