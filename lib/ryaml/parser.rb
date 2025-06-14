# frozen_string_literal: true

class Ryaml::Parser
  attr_reader :lines_enum
  class << self
    def parse(yaml_string)
      lines = new(yaml_string)

      lines.parse_node(-1)
    end
  end

  class Line
    attr_reader :indent, :content
    def initialize(indent, content)
      @indent = indent
      @content = content
    end
    def to_s
      "#{indent} #{content}"
    end
  end

  def initialize(yaml_string)
    @lines = yaml_string.lines.map(&:chomp).reject(&:empty?).map { |line| parse_line(line) }
    @lines_enum = @lines.to_enum
  end

  def parse = parse_node(-1)

  def parse_line(line)
    indent = line.match(/^\s*/)[0].length
    content = line.strip
    Line.new(indent, content)
  end

  def parse_node(parent_indent)
    first_line = lines_enum.peek
    raise "Indentation error" if first_line.indent <= parent_indent

    current_indent = first_line.indent

    if first_line.content.start_with?('- ')
      parse_sequence(current_indent)
    elsif first_line.content.include?(': ')
      parse_mapping(current_indent)
    else
      lines_enum.next.content
    end
  end

  def parse_mapping(current_indent)
    result = {}
    loop do
      line = lines_enum.next
      key, value_str = line.content.split(/:\s*/, 2)

      next_line = begin
                    lines_enum.peek.indent > current_indent
                  rescue StopIteration
                    false
                  end
      value = next_line ? parse_node(current_indent) : value_str
      result[key] = parse_type(value)
    end
    result
  end

  def parse_sequence(current_indent)
    result = []
    loop do
      line = lines_enum.next
      value_str = line.content.delete_prefix('- ').strip

      next_line = begin
                    lines_enum.peek.indent > current_indent
                  rescue StopIteration
                    false
                  end

      value = next_line ? parse_node(current_indent) : value_str
      result << value
    end
    result
  end

  def parse_type(value)
    case value
    when /^\d+$/
      value.to_i
    when /^\d+\.\d+$/
      value.to_f
    when Hash || Array
      value
    else
      value.gsub(/^['"]|['"]$/, '')
    end
  end
end
