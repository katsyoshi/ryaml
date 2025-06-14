# frozen_string_literal: true

require "test_helper"

class RyamlTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Ryaml.const_defined?(:VERSION)
    end
  end

  test "parse mapping yaml" do
    ryaml = Ryaml::Parser.new("foo: bar\nbuzz: 1").parse
    assert_equal ryaml, {"foo" => "bar", "buzz" => 1}
  end
end
