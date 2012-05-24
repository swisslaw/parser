# -*- coding: utf-8 -*-
require 'swiss_law/table_element'
require 'swiss_law/text'
require 'swiss_law/core_ext'

module SwissLaw
  class Table < Text
    def tr(children)
      current = TableElement.new
      case children[0]
      when /^(\d|\w)\.$/
        current.order = 1 # 0 is the table itself
        current.index = $1
        range = 1..-1
        @enumeration = Enumerator.new(1..1/0.0)
      when "" # in case of more indentation, refactor
        case children[1]
        when /^(-|–|)$/
          current.order = 2
          current.index = @enumeration.next
          range = 2..-1
        else
          raise "unknown pattern"
        end
      else
        raise "unknown pattern"
      end
      current.content = children[range]
      current.pre = @pre[range]
      @content << current
    end

    def initialize(child)
      # Let's hope here isn't any relevant markup inside the table elements.
      @table = child.css('tr').map {|e| e.css('td').map {|e| e.text.clean}}
      @content = []
      clean_columns!
      send(child.parent.attr('class'))
      @table.each do |row|
        tr(row)
      end
    end

    def to_s
      @content.join("\n")
    end

    private
    # This cuts off any columns that contain empty? elements only
    def clean_columns!
      # Unit test for this?
      to_delete = @table.first.each.with_index.map do |_,index|
        [index, @table.all? {|row| row[index].empty?}]
      end.select do |(index, delete)|
        delete
      end.map {|(index, _)| index}
      @table.each do |row|
        row.reject!.with_index do |column, index|
          to_delete.include? index
        end
      end
    end

    # Following: special table handling

    # a196
    def kavTable
      # @pre is the stuff that comes before every element in that
      # column.
      @pre = @table.slice!(1)
      @table.last.insert(2, "")
    end
  end
end
