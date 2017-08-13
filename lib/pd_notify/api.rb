Dir.glob(File.join(__dir__, 'api', '**', '*')).each do |f|
  if File.directory?(f)
    next
  end
  require f
end

module PdNotify
  module API
  end
end
