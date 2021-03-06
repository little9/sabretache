module Sabretache
  class Bag

    def bag_files(params, out)
      collection_name = params['collection']
      collection_title = params['title']
      collection_desc = params['description']

      bag_name =  params['collection']

      metadata_bag_command = "#{BagIt_location} create \"#{STORAGE_DIR}#{collection_name}_bags/#{Institution}.#{collection_name}_metadata\" \"#{STORAGE_DIR}#{collection_name}_metadata\""

      puts metadata_bag_command
      out << system(metadata_bag_command)

      # Go to the directory that the collection was downloaded to
      Dir.chdir(STORAGE_DIR + collection_name)
      files = Dir['**/*'].reject {|fn| File.directory?(fn) }
      files.reject{|fn| fn.include?(".mtf") }
      #files = FileList.new(STORAGE_DIR + collection_name)
      # Go through all the files in the directory and create bags for the files
      files.map(&File.method(:realpath)).each do |filename|
        bag_filename = filename.gsub("/","_").gsub(".","_")
        bag_filename[0] = "#{Institution}."
        bag_command = "#{BagIt_location} create \"#{STORAGE_DIR}#{collection_name}_bags/#{bag_filename}\" \"#{filename}\""

        puts bag_command

        out << system(bag_command)
        # Create text files require for bag
        gen_info = Info.new
        gen_info.create_baginfo(collection_title, collection_name, collection_desc, bag_filename, bag_name)
        gen_info.create_aptrust_info(bag_filename, collection_title, collection_name, collection_desc)

      end
    end
  end
end