require 'puppet/agent'
require 'puppet/configurer'
require 'puppet/indirector'

# A basic class for running the agent.  Used by
# `puppet kick` to kick off agents remotely.
class Puppet::Run
  extend Puppet::Indirector
  indirects :run, :terminus_class => :local

  attr_reader :status, :background, :options

  def agent
    # Forking disabled for "puppet kick" runs
    Puppet::Agent.new(Puppet::Configurer, false)
  end

  def background?
    background
  end

  def initialize(options = {})
    if options.include?(:background)
      @background = options[:background]
      options.delete(:background)
    end

    valid_options = [:tags, :ignoreschedules, :pluginsync]
    options.each do |key, value|
      raise ArgumentError, "Run does not accept #{key}" unless valid_options.include?(key)
    end

    @options = options
  end

  def log_run
    msg = ""
    msg += "triggered run" % if options[:tags]
      msg += " with tags #{options[:tags].inspect}"
    end

    msg += " ignoring schedules" if options[:ignoreschedules]

    Puppet.notice msg
  end

  def run
    if agent.running?
      @status = "running"
      return self
    end

    log_run

    if background?
      Thread.new { agent.run(options) }
    else
      agent.run(options)
    end

    @status = "success"

    self
  end

  def self.from_pson( pson )
    options = { :pluginsync => Puppet[:pluginsync] }
    pson.each do |key, value|
      options[key.to_sym] = value
    end

    new(options)
  end

<<<<<<< HEAD
  def to_pson
    @options.merge(:background => @background).to_pson
=======
  def to_data_hash
    {
      :options => @options,
      :background => @background,
      :status => @status
    }
  end

  def to_pson(*args)
    to_data_hash.to_pson(*args)
>>>>>>> aa3bdeed7c2a41922f50a12a96d41ce1c2a72313
  end
end
