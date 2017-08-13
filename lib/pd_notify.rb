
lib_dir = File.join(File.dirname(File.expand_path(__FILE__)), 'pd_notify')
Dir.glob(File.join(lib_dir, '**', '*')).reject {|f| File.directory?(f)}.each do |f|
  require f
end

module PdNotify
end
