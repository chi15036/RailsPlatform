class V1::EntitiesController < ApplicationController
  require 'net/http'

  def index
    respond_to do |format|
      format.json { render :json => {stat: 'index'} }
    end
  end

  def show
    sentence = URI.encode(params[:sentence])
    uri = URI.parse("https://api.wit.ai/message?v=20160526&q=" + sentence)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    #set header
    request["Authorization"] = "Bearer VWZA77MGCI5NFC633GUSJ2TKZGKB5DRP"
    request["Content-Type"] = "application/json"

    response = http.request(request)
    puts :json => response.body
    respond_to do |format|
      format.json { render :json => response.body}
    end
  end

  def create
    puts params[:entity].to_json
    uri = URI.parse("https://api.wit.ai/entities/intent/values?v=20160526")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    #set header
    request["Authorization"] = "Bearer VWZA77MGCI5NFC633GUSJ2TKZGKB5DRP"
    request["Content-Type"] = "application/json"
    request.body = params[:entity].to_json

    response = http.request(request)
    puts :json => response.body
    respond_to do |format|
      format.json { render :json => response.body}
    end
  end
end
