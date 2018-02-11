# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

unless defined?(Sprockets::SasscCompressor)
  return
end

module Jekyll
  module Assets
    module Compressors
      class SassC < Sprockets::SasscCompressor
        def call(input)
          out = super(input)
          Hook.trigger(:asset, :after_compression) do |h|
            h.call(input, out, {
              type: :css,
            })
          end

          out
        end
      end

      # --
      Sprockets.register_compressor "text/css", :assets_sassc, SassC
      Hook.register :env, :after_init, priority: 3 do |e|
        e.css_compressor = nil
        next unless e.asset_config[:compression]
        Utils.activate("sassc") do
          e.css_compressor = :assets_sassc
        end
      end
    end
  end
end
