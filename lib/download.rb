require_relative 'settings'
module Sabretache
class Download

 def download(download_info, out)
      p download_info

      if download_info['fileTypes']
        file_types = download_info['fileTypes'].split(',')
        include_list = ''
        file_types.each do |file_type|
          include_list += "  --include=*.#{file_type}  "
        end
      end

      folder_name = download_info['collection']
      Dir.mkdir(STORAGE_DIR + folder_name) unless Dir.exist?(STORAGE_DIR + folder_name)

      download_file_list = download_info['files']
      
      download_file_list.each do |file|

        rsync_command = "rsync -rPuRc #{Remote_user}@#{Remote_server}:#{file} #{STORAGE_DIR}#{folder_name} --include=#{Includes_default}"

        IO.popen(rsync_command, 'r') do |io|
          while line=io.gets
            puts line
            out << line
            
            progress_file = File.open('progress.txt', 'w+')
            progress_file.puts(line)
            progress_file.close
          end
          
        end
      end
 end

end
end