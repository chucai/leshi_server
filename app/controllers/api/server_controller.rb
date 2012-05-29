# -*- encoding: utf-8 -*-
class Api::ServerController < ApplicationController
  layout false
  before_filter :flow_server_filter

  #GET /api/login.json
  #login for client
  #auth mobile client
  def login
    challenge = params[:challenge]
    response = params[:response]
    username = params[:username]
    if User.authenticate_for_mobile?(username, challenge,response)
      render :status => 200, :json => {:result => "ok" }.to_json
    else
      render :status => 400, :json => {:result => "fail"}.to_json
    end
  end

  #POST /api/archived.json
  #close video socket
  def save_archived
    respond_to do |format|
      format.json {
        archive = Video.find_by_tid(params[:video][:tid])
        if archive
          Video.transaction do
            archive.update_attributes(params[:video])
            archive.update_attribute(:vstate, 'archived')
          end
          render :json => {:result => I18n.t('leshi_server.archived.success')}.to_json
        else
          render :json => {:result => I18n.t('leshi_server.archived.fail')}.to_json , :status => 400
        end
      }
    end
  end

  #POST /api/live.json
  #open video socket
  def save_live
    respond_to do |format|
      format.json {
        user = User.find_by_login(params[:username])
        living = Video.new(params[:video])
        living.user = user
        if user and living.save!
          image_path = File.join(Rails.root, "public", "video", "#{living.tid}.jpg")
          logger.info(image_path)
          if living.encoding == "flv/mp3/h263" then
            str = "/usr/bin/ffmpeg -re -i #{living.url} -acodec libfaac -ar 22050 -ac 2 -vcodec libx264 -vpre default -vpre baseline -g 60 -vb 150000 -f flv rtmp://127.0.0.1/live/mp4:#{living.tid}"
          else
            str = "/usr/bin/ffmpeg -re -i #{living.url} -acodec libfaac -ar 22050 -ac 2 -vcodec copy -f flv rtmp://127.0.0.1/live/mp4:#{living.tid}"
          end
          logger.info str
          Thread.new {
            until(File.exist?(image_path))
              sleep 1
            end
            `#{str}`
          }
          render :json => {:result => I18n.t('leshi_server.live.success')}.to_json
        else
          render :json => {:result => I18n.t('leshi_server.live.fail')}.to_json , :status => 400
        end
      }
    end
  end


  private
  #流媒体过滤器
  def flow_server_filter
    remote_ip = request.remote_ip
    access_ip = "".split(" ").map { |ip|  ip.split(":").first  }
    unless access_ip.include?(remote_ip)
      respond_to do |wants|
        wants.json {
          render :json => {:result => "非法访问" }.to_json, :status => 400
        }
      end
    end
  end

end