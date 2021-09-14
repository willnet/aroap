# frozen_string_literal: true

require_relative "aroap/version"
require "active_support/all"

module Aroap
  extend ActiveSupport::Concern

  included do
    after_initialize :_count_initialize
    after_find :_count_find
  end

  def _count_initialize
    return unless Aroap.enable_counter?

    Aroap.increment_initialize_counter(caller)
  end

  def _count_find
    return unless Aroap.enable_counter?

    Aroap.increment_find_counter(caller)
  end

  @ar_initialize_counter = Hash.new(0)
  @ar_find_counter = Hash.new(0)
  @enable_counter = false

  class << self
    attr_reader :ar_initialize_counter, :ar_find_counter

    def profile
      enable_counter
      yield
      log_counter
      reset_counter
    ensure
      disable_counter
    end

    def increment_initialize_counter(caller)
      ar_initialize_counter[caller_in_app(caller)] += 1
    end

    def increment_find_counter(caller)
      ar_find_counter[caller_in_app(caller)] += 1
    end

    def enable_counter?
      @enable_counter
    end

    def enable_counter
      @enable_counter = true
    end

    def disable_counter
      @enable_counter = false
    end

    def reset_counter
      @ar_initialize_counter = Hash.new(0)
      @ar_find_counter = Hash.new(0)
    end

    private

    def gems_paths
      @gems_paths ||= (Gem.path | [Gem.default_dir]).map { |p| Regexp.escape(p) }
    end

    def caller_in_app(caller)
      caller.find { |file_and_lineno| gems_paths.none? { |gem_path| file_and_lineno.match?(gem_path) } }
    end

    def logger
      @logger ||= Logger.new("aroap.log")
    end

    def log_counter
      logger.info "ar_initialize_counter"
      logger.info @ar_initialize_counter.inspect
      logger.info "ar_find_counter"
      logger.info @ar_find_counter.inspect
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include Aroap
end
