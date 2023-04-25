# frozen_string_literal: true
require 'httparty'
require 'zip'
require 'fileutils'
require 'colored2'

class LanguageDownloader

  HeaderString = %Q{accept: application/json, text/plain, */*
accept-encoding: gzip, deflate, br
accept-language: zh
content-length: 182
content-type: application/json
cookie: sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%221859aeaeae8ac6-062e0ea9cca7ea-17525635-2073600-1859aeaeae9f16%22%2C%22first_id%22%3A%22%22%2C%22props%22%3A%7B%7D%2C%22%24device_id%22%3A%221859aeaeae8ac6-062e0ea9cca7ea-17525635-2073600-1859aeaeae9f16%22%7D; Token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0OTAyODA1ZjNlYTQxODgyLjY5Mjg0MTEzMjM5Mjc5MjA2NSIsImlzcyI6Imh0dHBzOi8vYWlvdC1ycGMuYXFhcmEuY24iLCJhY2NvdW50IjoiamluZ3lhLmx1LWExMDc5QGFxYXJhLmNvbSIsImlhdEdtdDgiOjE2NzQ5ODM4MTMsImp0aSI6IjYxMTE3MDY3ZTRmNDQ2Mzg5YzI3Y2IxNDNjYTk5ZTRlMDdiMGZjNThmOWZlNGJjNjg5MjI2NjMxNWYwMzIxZDUifQ.AA90VKxT6zjlxnkFpaOMO9ujTXrssEXxuRp0WRhliGM; Userid=4902805f3ea41882.692841132392792065; currentSid=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0OTAyODA1ZjNlYTQxODgyLjY5Mjg0MTEzMjM5Mjc5MjA2NSIsImlzcyI6Imh0dHBzOi8vYWlvdC1ycGMuYXFhcmEuY24iLCJpYXRHbXQ4IjoxNjc0OTgzODEzLCJqdGkiOiIwZTY3NThjMjM3NGY0YmJiOWE3NjBmYzI0ZmZkY2NmODYzNGI4ODRjZGM1NTRjM2NiNTU1YzNkZjdmN2NjNWNhIn0.r7cBEpWVHWSpHH6zDX32FXNjMQ6IZN0DFBc3Oa8Tb5w; currentAccount=jingya.lu-a1079@aqara.com; userInfo=%7B%22accountCategory%22%3A%220%22%2C%22company%22%3A%7B%22companyId%22%3A1%2C%22companyName%22%3A%22%E7%BB%BF%E7%B1%B3%E8%81%94%E5%88%9B%22%7D%2C%22user%22%3A%7B%22avatarUrl%22%3A%22%22%2C%22companyId%22%3A1%2C%22email%22%3A%22jingya.lu-a1079%40aqara.com%22%2C%22nickName%22%3A%22%22%2C%22userName%22%3A%22%E9%B2%81%E9%9D%99%E4%BA%9A%22%2C%22userType%22%3A0%7D%7D; sidebarStatus=0lang: zh
nonce: k9a7yh3vjjyd6vb47ktmcyh50bv3m3c2
operate-platform: 40
origin: https://intl-lang.aqara.com
projectid: 5
referer: https://intl-lang.aqara.com/
sec-ch-ua: "Google Chrome";v="107", "Chromium";v="107", "Not=A?Brand";v="24"
sec-ch-ua-mobile: ?0
sec-ch-ua-platform: "macOS"
sec-fetch-dest: empty
sec-fetch-mode: cors
sec-fetch-site: same-origin
time: 1668061116811
timestamp: 1668061116811
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36
}
  def self.makeHeader
    headerArray = HeaderString.split("\n")
    header = {}
    headerArray.each do |str|
      header[str.split(":",2)[0].strip] = str.split(":",2)[1].strip
    end
    header
  end
  def self.download

    # puts makeHeader

    #下载文件

    params = {"projectIdList":[5],"langIds":[1,2,3,9,10,11,12,13,14,15,16],"fileTypeList":["excel"],"auditState":1,"valueState":0,"userId":"","value":"","tagIds":nil,"bizUseTagIds":nil,"pkeys":[]}
    response = HTTParty.post('https://intl-lang.aqara.com/v1.0/lumi/language/file/export', body: JSON.generate(params), headers:LanguageDownloader.makeHeader)
    # puts response.body
    unless response.body["code"] == nil
      3.times do
        puts "资源包下载失败了！！！！！ code:#{response.body}".red
      end
      return
    end
    destation_path = "./localize.zip"
    if File.exist? destation_path
      FileUtils.rm_rf destation_path
    end
    File.open(destation_path,"w") do |io|
      io.binmode
      io.write response.body
    end

    # 解压缩文件到指定目录
    f_path =  ''

    Zip::File.open(destation_path) do |zip_file|
      zip_file.each do |f|
        f_path = File.join('./','hit_all.xls')
        File.delete f_path if File.exist? f_path
        # FileUtils.mkdir_p(File.dirname(f_path))
        f.extract(f_path)
      end

    end
    if File.exist? destation_path
      FileUtils.rm_rf destation_path
    end

    f_path
  end

end


