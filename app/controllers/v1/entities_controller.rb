class V1::EntitiesController < ApplicationController

  @@Authorization = "Bearer 3EJEHFVZ7YUPQF3HFMBOGAK2UYWD5PFG"

  def index
    respond_to do |format|
      format.json { render :json => {stat: 'index'} }
    end
  end

  def show
    words, flags = cutWord(params[:sentence])
    sentence = URI.encode(words.join(" "))
    uri = URI.parse("https://api.wit.ai/message?v=20160526&q=" + sentence)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    #set header
    request["Authorization"] = @@Authorization
    request["Content-Type"] = "application/json"

    response = http.request(request)
    puts :json => response.body
    respond_to do |format|
      format.json { render :json => response.body}
    end
  end

  def create
    entities = params[:entities]
    entities.each do |entity|
      uri = URI.parse("https://api.wit.ai/entities/" + entity[:id] + "/values?v=20160526")
      response = postData(uri, entity[:values][0].to_json)
      puts response.body.inspect
      if JSON.parse(response.body).key?("error")
        uri = URI.parse("https://api.wit.ai/entities?v=20160526")
        response = postData(uri, entity.to_json)
        puts response.body.inspect
      end
    end
    respond_to do |format|
      format.json { render :json => {stat: 'ok'}}
    end
  end

  private
  def postData(uri, body)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    #set header
    request["Authorization"] = @@Authorization
    request["Content-Type"] = "application/json"
    # puts entity[:values][0].inspect
    request.body = body
    response = http.request(request)
    return response
  end

  private
  def cutWord(sentence)
    RubyPython.start # start the Python interpreter
    sys = RubyPython.import("sys")
    sys.path.append("#{Rails.root}/lib")
    taiba = RubyPython.import('Taiba')
    cut_words = taiba.lcut(sentence, true).to_a  #我也不知為何第二個參數一定要true...
    puts cut_words
    words = []
    flags = []
    cut_words.each do |word|
      word, flag = word.to_s.split('/')
      words << word
      flags << flag
    end
    puts words
    return words, flags
    # # RubyPython.stop # stop the Python interpreter
    # result = exec("python #{Rails.root}/lib/Taiba/main.py #{sentence}")
  end


end
