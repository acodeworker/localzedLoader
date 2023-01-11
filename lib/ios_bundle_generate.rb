# frozen_string_literal: true
require_relative './LanguageDownloader'
require_relative  './File_util'
require 'fileutils'

class BundleGenerater
  def self.generate
    # 下载excel
    f_path = LanguageDownloader.download
    # unless f_path != nil
    #   return
    # end
    # f_path = "./hit_all.xls"
    # 读取excel到内存
    file_til = File_util.new
    hash = file_til.read_excel f_path
    if File.exist? f_path
      FileUtils.rm_rf f_path
    end
    puts "一共有 #{hash.keys.size} 条文案"

    # 创建文件夹
    file_til.getLangList.each do |lang|
      # puts lang
      localized_file = "./#{lang}.lproj/Localizable.strings"
      dir = File.dirname localized_file
      FileUtils.rm_rf localized_file
      FileUtils.mkdir_p dir
    end

    #生成资源文件
    hash.each do |key, stringElement|
      stringElement.langHash.each do |lang, value|
        # puts "#{lang}:#{value}"
        next if lang.downcase === "selfkey" or value === nil or value === " " or value === ""
        value = self.handleValue value,stringElement
        localized_file = "./#{lang}.lproj/Localizable.strings"
        str = %Q|"#{key}" = "#{value}";\n|
        File.open(localized_file, "a") do |io|
          io.write str
        end
      end
    end

    #验证导出的多语言包格式是否正确
    puts "\e[31m 开始校验多语言包格式\e[0m"
    file_til.getLangList.each do |lang|
      localized_file = "./#{lang}.lproj/Localizable.strings"
      system("plutil #{localized_file}")
    end

    #拷贝到代码仓库里
    #查找bundle路径
    bundPath = ""
    require 'find'
    Find.find("./") do |filePath|
      if  filePath.end_with?("LMFramework.bundle")
        bundPath = filePath
        break
      end
    end
    unless bundPath != ""
      puts '没有拷贝'
      return
    end

    file_til.getLangList.each do |lang|
      path = "#{lang}.lproj/Localizable.strings"
      dest = bundPath + "/#{lang}.lproj"
      FileUtils.mkdir_p dest
      FileUtils.mv("./#{path}",dest,force:true)
      FileUtils.rm_rf File.dirname("./#{path}")
    end
    puts "多语言拷贝到目录:#{bundPath}"

  end

  private
  #对多语言的value进行处理
  def self.handleValue(value='',stringElement = nil)
    #替换{=}
    value = value.gsub(/{#}/,"%@")
    value = value.gsub(/""/,'"')
    value = value.gsub(/\\"/,'"')
    value = value.gsub(/""/,'"')
    value = value.gsub(/"/,'\"')
    #fix "common_time_day_with_space" = "\ day \";
    if value.end_with?"\\"
      value = value.chop
    end
    if value.end_with?"\\"
      value = value.chop
    end
    value
  end

end
#
# BundleGenerater.generate
# ios_list = ["%@","%d"]
# str = "{#}盏灯开着,真的吗{#}"
# i = -1
# str = str.gsub(/{#}/) do |matched|
#   i+=1
#   ios_list[i]
# end
#
# p str
