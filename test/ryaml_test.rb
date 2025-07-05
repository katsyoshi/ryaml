# frozen_string_literal: true

require_relative "test_helper"

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

  test "parse sequence with dash" do
    ryaml = Ryaml::Parser.new("- foo\n- bar\n- buzz").parse
    assert_equal ryaml, ["foo", "bar", "buzz"]
  end

  description "parse sequence with square bracket"
  test "single line" do
    ryaml = Ryaml::Parser.new("[foo,bar,buzz]").parse
    assert_equal ryaml, ["foo", "bar", "buzz"]
  end

  test "parse mapping from file" do
    ryaml = Ryaml::Parser.new(File.read("./samples/mapping.yml")).parse
    assert_equal ryaml, {"alice" => 42, "bravo" => 1.3, "charlie" => "delta", "echo" => "Foxtrot", "golf" => {"hotel" => "india", "juliet" => {"kilo" => 1}}}
  end
end
