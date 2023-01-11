# frozen_string_literal: true
require 'httparty'
require 'zip'
require 'fileutils'

class LanguageDownloader

  HeaderString = %Q{accept: application/json, text/plain, */*
accept-encoding: gzip, deflate, br
accept-language: zh
content-length: 182
content-type: application/json
cookie: experimentation_subject_id=ImNhNTFhZTQ4LTVjNWItNDBmOS05ZmY3LTY5ZjgwMjE2YzU3ZCI%3D--adfdeb4234398bb82727d204df565baf4fcb9e02; __gads=ID=330a8bae159ec1c5-224c3fce10d50039:T=1657179992:RT=1657179992:S=ALNI_MbFcfcws4Qph_vMu9ocv_uTUODlsQ; _gcl_au=1.1.1930354128.1661415060; _fbp=fb.1.1661415060137.191157889; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%22e81e719330108226.642068199734845441%22%2C%22first_id%22%3A%2217f2542445d8d6-0c4aee16f19597-37677a09-1484784-17f2542445e707%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E5%BC%95%E8%8D%90%E6%B5%81%E9%87%8F%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC%22%2C%22%24latest_referrer%22%3A%22https%3A%2F%2Fuc.aqara.cn%2F%22%7D%2C%22%24device_id%22%3A%2217f2542445d8d6-0c4aee16f19597-37677a09-1484784-17f2542445e707%22%7D; __gpi=UID=00000770b0955020:T=1657179992:RT=1667284690:S=ALNI_Max_O1qEORw1S9hsg1OFkW2uV7oQg; _ga=GA1.2.283585764.1638366289; _ga_3EMB6JL0XV=GS1.1.1667298252.19.1.1667299119.60.0.0; Hm_lvt_2df419cadb3951597d5f6df3a9e563d1=1667528944; Hm_lpvt_2df419cadb3951597d5f6df3a9e563d1=1667547607; Token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJlODFlNzE5MzMwMTA4MjI2LjY0MjA2ODE5OTczNDg0NTQ0MSIsImlzcyI6Imh0dHBzOi8vYWlvdC1ycGMuYXFhcmEuY24iLCJhY2NvdW50IjoieGlmYW4uemhhb0BhcWFyYS5jb20iLCJpYXRHbXQ4IjoxNjY3ODE3OTU1LCJqdGkiOiIxY2JkZjc4YzU2MzI0N2Q4OTJkZjIwYzZlZmY1YTdiZTY4MWZiMzc1YjIxYTQzNzQ5YjNlMDkyZDY0NjY5Zjc2In0.HO1YbsvUp50GFAXfYDwpbpW8rwaiSI2_PTp38CmhQbU; Userid=e81e719330108226.642068199734845441; currentSid=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJlODFlNzE5MzMwMTA4MjI2LjY0MjA2ODE5OTczNDg0NTQ0MSIsImlzcyI6Imh0dHBzOi8vYWlvdC1ycGMuYXFhcmEuY24iLCJpYXRHbXQ4IjoxNjY3ODE3OTU1LCJqdGkiOiJhZDZjZmMyYTBmZDk0OGIwODkzN2MxMzgzZDQwNGRkYTlmNmExMDFkNjUzNDQ1ZWU5NjM0Yzc2MjIzODYzZWJhIn0.WHEe5H6ImH5FbGA9MByXhSIB6Y3sP1ltmlVsdmtg6kY; currentAccount=xifan.zhao@aqara.com; userInfo=%7B%22accountCategory%22%3A%220%22%2C%22company%22%3A%7B%22companyId%22%3A1%2C%22companyName%22%3A%22%E7%BB%BF%E7%B1%B3%E8%81%94%E5%88%9B%22%7D%2C%22user%22%3A%7B%22avatarUrl%22%3A%22%22%2C%22companyId%22%3A1%2C%22email%22%3A%22xifan.zhao%40aqara.com%22%2C%22nickName%22%3A%22%22%2C%22userType%22%3A0%7D%7D; sidebarStatus=0
lang: zh
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

    params = {"projectIdList":[5],"langIds":[1,2,3,9,10,11,12,13,14,15],"fileTypeList":["excel"],"auditState":1,"valueState":0,"userId":"","value":"","tagIds":nil,"bizUseTagIds":nil,"pkeys":[]}
    response = HTTParty.post('https://intl-lang.aqara.com/v1.0/lumi/language/file/export', body: JSON.generate(params), headers:LanguageDownloader.makeHeader)
    # puts response.body["code"]
    # unless response.body["code"] === 0
    #   puts "资源包下载失败 code:#{response.body}"
    #   return
    # end
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


