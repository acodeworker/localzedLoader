require 'cocoapods-localzedLoader/command'
require_relative 'cocoapods-localzedLoader/ios_bundle_generate'
module CocoapodsGitHooks
  Pod::HooksManager.register('cocoapods-localzedLoader', :pre_install) do |context|
    args = ['gen', "--project-directory=#{Config.instance.installation_root}"]
    Localzedloader::Command.run(args)
  end
end