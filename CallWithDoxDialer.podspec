Pod::Spec.new do |s|
  s.name         = "CallWithDoxDialer"
  s.version      = "1.0.2"
  s.summary      = "A µLibrary for initiating calls through the Doximity app."
  s.description  = <<-DESC
                  Doximity lets healthcare professionals make phone calls 
                  to patients while on the go -- without revealing personal phone numbers.
                  Calls are routed through Doximity's HIPPA-secure platform and relayed to the patient
                  who will see the doctor's office number in the Caller ID.
                  Doximity Dialer is currently available to verified physicians, nurse practitioners,
                  physician assistants and pharmacists in the United States.

                  This µLibrary lets 3rd-party apps easily initiate calls through the Doximity app.
                   DESC
  s.homepage     = "https://github.com/doximity/CallWithDoxDialer/"
  s.license      = { :type => "Unlicense", :file => "LICENSE.MD" }
  s.author       = { "Atai Barkai" => "abarkai@doximity.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/doximity/CallWithDoxDialer.git", :tag => "v#{s.version}" }
  s.source_files  = "CallWithDoxDialer/**/*.{h,m}"
  s.resource = 'CallWithDoxDialer/CallWithDoxDialer.bundle'
end
