require_relative "SuperWindow.rb"

$:.unshift File.dirname($0)
if ENV["OCRA_EXECUTABLE"] != nil
  $:.unshift File.dirname(ENV["OCRA_EXECUTABLE"])
end

app = SuperWindow.new

if not defined?(Ocra)
  app.run
end
