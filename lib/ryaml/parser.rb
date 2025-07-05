# frozen_string_literal: true

class Ryaml::Parser
  attr_reader :ast
  INITIAL_LINE_NUM = 0
  def self.parse(yaml_string)
    lines = new(yaml_string)
    lines.parse_node(-1)
  end

  class IndentationError < StandardError; end

  class Line
    attr_reader :num, :indent, :content
    def initialize(line, indent, content)
      @indent = indent
      @content = content
      @num = line
    end
    def to_s = "#{"%4d|" %num} #{"%2d|" % indent} #{content}"
  end

  def initialize(yaml_string)
    i = 0
    @ast = yaml_string.lines.map(&:chomp).reject(&:empty?)
              .map do |line|
      parsed_line = parse_line(i, line)
      i += 1
      parsed_line
    end
    @pos = INITIAL_LINE_NUM
  end

  def parse = parse_node(-1)
  def rewind = @pos = INITIAL_LINE_NUM
  def parse!
    parse
    rewind
  end

  def parse_line(num, line)
    indent = line.match(/^\s*/)[0].length
    content = line.strip
    Line.new(num, indent, content)
  end

  def parse_node(parent_indent)
    first_line = ast[@pos]
    raise Ryaml::Parser::IndentationError, "Indentation error" if first_line.indent <= parent_indent

    current_indent = first_line.indent

    if first_line.content.start_with?('- ')
      parse_sequence(current_indent)
    elsif first_line.content.start_with?('[')
      parse_bracket_sequence(current_indent)
    elsif first_line.content.include?(': ')
      parse_mapping(current_indent)
    else
      ast[@pos].content
    end
  end

  def parse_mapping(current_indent)
    result = {}
    loop do
      line = ast[@pos]
      key, value_str = line.content.split(/:\s*/, 2)
      @pos += 1
      next_line = ast[@pos]&.indent.to_i > current_indent
      value = next_line ? parse_node(current_indent) : value_str
      result[key] = parse_type(value)
      break if ast[@pos].nil?
    end
    result
  end

  def parse_sequence(current_indent)
    result = []
    loop do
      line = ast[@pos]
      value_str = line.content.delete_prefix('- ').strip
      @pos += 1
      next_line = ast[@pos]&.indent.to_i > current_indent
      value = next_line ? parse_node(current_indent) : value_str
      result << value
      break if ast[@pos].nil?
    end
    result
  end

  def parse_bracket_sequence(current_indent)
    result = []
    loop do
      line = ast[@pos]
      value_str = line.content.delete_prefix('[').delete_suffix(']').split(/,/).map(&:strip)
      result += value_str.map { parse_type(it) }
      @pos += 1
      break if @pos >= ast.size || ast[@pos].nil?
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
