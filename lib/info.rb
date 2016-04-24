require_relative 'settings'
module Sabretache
  class Info

    def create_baginfo(collection_title, collection_name, collection_desc, bag_filename, bag_name)
      bag_id = bag_name.gsub("_","")
      bagging_date = Time.now.utc.iso8601

      bag_info_text = "Source-Organization: #{Source_org} \n" +
          "Bagging-Date: #{bagging_date} \n" +
          "Internal-Sender-Description: #{collection_desc} \n" +
          "Internal-Sender-Identifier: #{bag_id}"

      File.open("#{STORAGE_DIR}#{collection_name}_bags/#{bag_filename}/bag-info.txt", 'w+') { |file| file.write(bag_info_text) }

      begin
        File.open("#{STORAGE_DIR}#{collection_name}_bags/#{Institution}.#{collection_name}_metadata/bag-info.txt", 'w+') { |file| file.write(bag_info_text) }

      rescue
        puts "Error creating metadata info files.."
      end
    end

    def create_aptrust_info(bag_filename, collection_title, collection_name, collection_desc)

      aptrust_info_text = "Title: #{collection_title} \n" +
          "Rights: Institution\n"

      File.open("#{STORAGE_DIR}#{collection_name}_bags/#{bag_filename}/aptrust-info.txt", "w+") { |file| file.write(aptrust_info_text) }
      File.open("#{STORAGE_DIR}#{collection_name}_bags/#{Institution}.#{collection_name}_metadata/aptrust-info.txt", "w+") {|file| file.write(aptrust_info_text)}

    end
  end
end