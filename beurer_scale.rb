require 'libusb'

# Scale:
#
#   Product ID: 0x8020
#   Vendor ID: 0x04d9  (Holtek Semiconductor, Inc.)
#   Version: 1.00
#   Speed: Up to 1.5 Mb/sec
#   Location ID: 0x14100000 / 16
#   Current Available (mA): 1000
#   Current Required (mA): 100
#   Extra Operating Current (mA): 0

class BeurerScale
  # USB Vendor ID for the Beurer USB Scale
  BSM_VID=0x04d9
  # USB Product ID for the Beurer USB Scale (found on BF 480 USB model)
  BSM_PID=0x8020
  # USB interface number for control transfer
  USB_INTERFACE_IN=0x00
  # USB interface number for interrupt transfer
  USB_INTERFACE_OUT=0x01
  # USB interrupt data length
  USB_INTR_DATA_LEN=8
  # USB control bRequest - HID set report
  USB_CTRL_REQUEST=0x09
  # USB control wValue
  USB_CTRL_VALUE=0x0300
  # USB control data length
  USB_CTRL_DATA_LEN=8
  # USB control data first byte value (others are 0x00)
  USB_CTRL_DATA_FIRST=0x10
  # USB expected data length
  USB_EXPECTED_LEN=8192

  attr_reader :device

  def initialize
    usb = LIBUSB::Context.new
    @device = usb.devices(idVendor: BSM_VID, idProduct: BSM_PID).first
    raise 'couldn\'t open device' unless @device
  end

  def transfer
    @device.open_interface(0) do |handle|
      result = handle.control_transfer(
        bmRequestType: 0x21, # TODO move to const.
        bmRequest: USB_CTRL_REQUEST,
        wValue: USB_CTRL_VALUE,
        wIndex: 0x0000,
        dataOut: USB_CTRL_DATA_FIRST # ???
      )
      puts result
    end
  end
end
