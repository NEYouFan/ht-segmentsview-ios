#
#  Be sure to run `pod spec lint HTSegmentsView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "HTSegmentsView"
  s.version      = "0.0.2"
  s.summary      = "网易标准化控件库之 HTSegmentsView."

  s.description  = <<-DESC
                   A longer description of HTSegmentsView in Markdown format.
                   DESC

  s.homepage     = "https://github.com/NEYouFan/ht-segmentsview-ios"


  s.license      = "MIT"

  s.author             = { "netease" => "taozeyu890217@126.com" }

  s.platform     = :ios, "7.0"


  s.source       = { :git => "https://github.com/NEYouFan/ht-segmentsview-ios.git", :tag => s.version.to_s }

  s.source_files  = "HTSegmentsView/*.{h,m}"

  s.dependency   'HTCommonUtility' , '~>0.0.2'

end
