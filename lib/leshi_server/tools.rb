# -*- encoding: utf-8 -*-
require 'digest/md5'
module LeshiServer
  module Tools
    
    #一次行密码生成器
    def mk_one_password(key)
      require 'digest/md5'
      tmp = Digest::MD5.new
      tmp.update([key].pack("H*"))
      tmp.update([Time.now.to_i.to_s].pack("H*"))
      return tmp.to_s
    end
    
    #数据加密
    def jiami_password(challenge)
      md = Digest::MD5.new
      f = FlowMedia.find_by_user_id(self.id)
      return false unless f
      pwd = f.ss_key
      pd = Digest::MD5.hexdigest(pwd)
      md.update([pd].pack("H*"))
      md.update([challenge].pack("H*"))
      return md.to_s
    end

  end
end