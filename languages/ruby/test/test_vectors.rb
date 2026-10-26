# frozen_string_literal: true

require 'minitest/autorun'
require 'human_short_code'

# Runs every row of spec/vectors.tsv against the Ruby implementation.
class TestVectors < Minitest::Test
  PATH = File.expand_path('../../../spec/vectors.tsv', __dir__)

  def run_row(op, input, alphabet, length)
    opts = {}
    opts[:alphabet] = alphabet unless alphabet == '-'
    opts[:length] = length.to_i unless length == '-'
    case op
    when 'encode' then HumanShortCode.encode(input.to_i, **opts)
    when 'decode' then HumanShortCode.decode(input, **opts).to_s
    when 'verify' then HumanShortCode.verify(input, **opts).to_s
    end
  end

  def test_vectors
    File.readlines(PATH, chomp: true).each_with_index do |line, n|
      next if line.empty? || line.start_with?('#')

      op, input, alphabet, length, expected = line.split("\t", -1)
      got = begin
        run_row(op, input, alphabet, length)
      rescue ArgumentError
        '!error'
      end
      assert_equal expected, got, "line #{n + 1}: #{op} #{input.inspect}"
    end
  end
end
