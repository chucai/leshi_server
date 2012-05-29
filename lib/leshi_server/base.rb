module LeshiServer
  module Base
    def self.included(base)
      base.send :extend, ClassMethods
    end
    
    #提供服务器的手机认证代码，验证请求的客户端是否合法
    module ClassMethods
      def authenticate_for_mobile?(username, challenge,response)
        u = User.find_by_username(username)
        if u
          response == u.jiami_password(challenge)
        else
          false
        end
      end
    end

    module InstanceMethods

      #返回ss_key, ss_ip, ss_port
      def values_for_mobile(ext)
        hash = {}
        ip_and_port = get_server_ip_and_port
        hash[:ss_ip], hash[:ss_port] = ip_and_port.first, ip_and_port.last
        flow = FlowMedia.save_or_update({:user_id => self.id, :ss_key => User.mk_one_password(ext[:key]), :expire_time => 3600 })
        hash[:ss_key] = flow.ss_key
        hash[:key_duration] = flow.expire_time
        hash
      end

      def get_server_ip_and_port
        ip = FlowIPGetway::Getway.get_server_ip_and_port
        ip.split(":")
        [AppConfig["leshi_server_ip"], AppConfig["leshi_server_in_port"]]
      end
      
    end


  end
end