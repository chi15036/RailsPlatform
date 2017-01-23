require 'open3'
class V1::EntitiesController < ApplicationController

  @@Authorization = "Bearer 3EJEHFVZ7YUPQF3HFMBOGAK2UYWD5PFG"

  def index
    respond_to do |format|
      format.html { render :json => {stat: 'helloworld'} }
    end
  end

  def show
    words = cutWord(params[:sentence])
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
    result = `python #{Rails.root}/lib/Taiba/main.py #{sentence}`
    puts "RETURN FROM PYTHON"
    result = result.tr("[]'\n", '').split(',')
    puts result
    return result
  end


end
