require_relative 'settings'
module Sabretache
  class Tar

    def tar(collection, out)
      collection_name = collection['repository'] + collection['collection']

      #to-do: tar the metadata bag

      Dir.chdir(STORAGE_DIR + collection_name + "_bags")

      entries = Dir.entries(Dir.pwd).select {|entry| File.directory? File.join(Dir.pwd,entry) and !(entry =='.' || entry == '..') }

      puts entries

      entries.each do |dirname|

        tar_command = "cd #{STORAGE_DIR}#{collection_name}_bags ; tar cvf #{dirname}.tar #{dirname}"
        out << system(tar_command)

      end
    end

  end
end