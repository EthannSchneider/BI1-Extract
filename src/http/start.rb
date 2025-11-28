require 'sinatra'


Dir[File.join(__dir__, 'controllers', '**', '*_controller.rb')].sort.each { |file| require file }