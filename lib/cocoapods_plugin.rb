require 'cocoapods-localzedLoader/command'
require_relative 'ios_bundle_generate'
module CocoapodsGitHooks
  Pod::HooksManager.register('cocoapods-localzedLoader', :pre_install) do |context|
    BundleGenerater.generate
  end
  Pod::HooksManager.register('cocoapods-localzedLoader', :pre_update) do |context|
    BundleGenerater.generate
  end
end