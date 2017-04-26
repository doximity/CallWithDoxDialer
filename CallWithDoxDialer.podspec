Pod::Spec.new do |s|
  s.name         = "CallWithDoxDialer"
  s.version      = "0.1"
  s.summary      = "A µLibrary for initiating calls through Doximity's Dialer app."
  s.description  = <<-DESC
                  Doximity's Dialer app lets healthcare professionals make
                  phone calls to patients while on the go -- without revealing personal phone numbers.
                  Calls are routed through Doximity's HIPPA-compliant bridge lines,
                  and are presented to recepients as if they originated from one's office phone number.

                  This µLibrary lets 3rd-party apps easily initiate calls through the Doximity Dialer app.
                   DESC
  s.homepage     = "https://www.doximity.com/clinicians/download/dialer"
  s.license      = { :type => "Unlicense", :file => "LICENSE.MD" }
  s.author       = { "Atai Barkai" => "abarkai@doximity.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/doximity/CallWithDoxDialer.git", :tag => "v#{s.version}" }
  s.source_files  = "CallWithDoxDialer", "CallWithDoxDialer/**/*.{h,m}"
  s.public_header_files = "CallWithDoxDialer/**/*.h"
  s.resources = "Resources/*.png"
  s.framework  = "UIKit"
end
