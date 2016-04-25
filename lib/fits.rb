require_relative 'settings'
module Sabretache
  class Fits

    def create_fits(collection)

      collection_name = collection['collection']
      mkdir_parent_command = "mkdir #{STORAGE_DIR}#{collection_name}_metadata"
      mkdir_command = "mkdir #{STORAGE_DIR}#{collection_name}_metadata/fits"

      system(mkdir_parent_command)
      system(mkdir_command)

      fits_command = "#{FITS_location} -xc -i #{STORAGE_DIR}#{collection_name} -r -o #{STORAGE_DIR}#{collection_name}_metadata/fits"

      return fits_command
    end

  end
end