# frozen_string_literal: true

require_relative "aroap/version"
require "active_support/all"

module Aroap
  extend ActiveSupport::Concern

  included do
    @ar_initialize_counter = Hash.new(0)
    @ar_find_counter = Hash.new(0)

    after_initialize :_count_initialize
    after_find :_count_find
  end

  class_methods do
    def enable_counter?
      @enable_counter
    end

    def enable_counter
      @enable_counter = true
    end

    def disable_counter
      @enable_counter = false
    end

    def log_counter
      File.open('hoge.log', 'w') do |file|
        file.puts 'ar_initialize_counter'
        file.write @ar_initialize_counter.inspect
        file.puts 'ar_find_counter'
        file.write @ar_find_counter.inspect
      end
    end

    def reset_counter
      @ar_initialize_counter = Hash.new(0)
      @ar_find_counter = Hash.new(0)
    end
  end

  def _gem_paths
    @_gems_paths = (Gem.path | [Gem.default_dir]).map { |p| Regexp.escape(p) }
  end

  def _count_initialize
    return unless self.class.enable_counter?
    caller_in_app = caller.find { |file_and_lineno| !_gems_paths.any? { |gem_path| file_and_lineno.match?(gem_path) } }
    self.class.instance_variable_get(:@ar_initialize_counter)[caller_in_app] += 1
  end

  def _count_find
    return unless self.class.enable_counter?
    caller_in_app = caller.find { |file_and_lineno| !_gems_paths.any? { |gem_path| file_and_lineno.match?(gem_path) } }
    self.class.instance_variable_get(:@ar_find_counter)[caller_in_app] += 1
  end
end

ActiveSupport.on_load(:active_record) do
  include Aroap
end
