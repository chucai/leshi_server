# -*- encoding: utf-8 -*-
# 获取驱动信息
module LeshiServer
  module Device
    
    #获取device的基本信息
    def device_info(device, rom_id)
      reply = {}
      device = Device.find_by_device_and_rom_id(device, rom_id)
      reply[:encode_mode] = device.nil? ? 2 : device.encode_mode
      reply
    end

  end
end