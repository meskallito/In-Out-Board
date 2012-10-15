Dir[::Rails.root.to_s + '/lib/extensions/*.rb'].each do |file|
  require file.chomp(File.extname file)
end