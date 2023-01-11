
# require 'file'
$LOAD_PATH << '.'
# -*- coding: UTF-8 -*-
require 'rubyXL'
require_relative  './StringElement'

class File_util

  attr_accessor :keys_hash
    #读取excel 返回StringElement数组
    def read_excel(filename)
      unless filename != nil
        puts "读取的excel为空"
        return
      end

      workbook = RubyXL::Parser.parse filename
      worksheet = workbook[0]
      row1 = worksheet[0]
      @key_hash = getkeyHash(row1)
      lang_hash = {}
      worksheet.each_with_index do |row|
        ele = StringElement.new
        self_key = ''
        # 设置StringElement的值
        row.cells.each_with_index do |cell, i|

          next unless cell
          case i
          when 0

          when 1
            self_key = cell.value
          else
            key = @key_hash[i]
            ele.langHash[key] = (cell.value || '')
          end
        end

        lang_hash[self_key] = ele
      end
      lang_hash
    end

    #根据第一行来获取当前cell的key
    # return {1:selfkey,2:en,3:zh....} 方便excel取
    # Command+Option+L 对齐快捷键
    def getkeyHash(row1,ios:true)
      keys_hash = {}
      row1.cells.each_with_index do |cell, i|
        next unless cell
        if i > 1
          result = cell.value.scan(/.*?\[(.*)\]/)
          key = result[0][0]
          case key
          when /zh_HK/
            key="zh-HK"
          when /zh_TW/
            key ="zh-Hant-TW"
          when /zh/
            key ="zh-Hans"
          when /fr.*/
            key ="fr"
          when /it.*/
            key="it"
          when /ger.*/
            key ="de"
          else
            key
          end
          keys_hash[i] = key
        elsif i == 1
          keys_hash[i] = cell.value
        end
      end
      keys_hash
    end

    def getLangList
      list = @key_hash.values
      list.delete_if{|item| item.downcase === "selfkey"}
      list
    end
end

# hash = File_util.read_excel"hit_all.xls"
# puts hash.keys.size
# hash.each do |key,value|
#   puts value
# end

# p "sssssssss中文[zh]".scan(/.*?\[(.*)\]/)

