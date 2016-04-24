Sabretache
==================
This software downloads a selection of files from a remote server, creates bags based on the APTrust bagging profile, and uploads them to an Amazon S3 bucket.

# Software required

* Ruby 1.9.3 or higher
* Unix tools: rsync, tar
* [Library of Congress BagIt] (https://github.com/LibraryOfCongress/bagit-java)
* [File Information Tool Set] (http://projects.iq.harvard.edu/fits)

### How do I get set up? ###

To run the software you'll need to configure settings in the lib/settings.rb.sample file to match your server environment and
copy it to lib/settings.rb.

You'll need to download the LOC bagit tool and the FITS tool and enter the path to their executables in the settings.rb

You'll also need to set a username and password that will be used for authentication in the settings.rb file. This application uses basic HTTP
authentication, so you should only run the application in a public environment over HTTPS.

The software uses rsync over SSH to transfer files from the remote server to the machine running the automation software. For this to work, you'll need to set up public key authentication.

After that, run:

    bundle install
    rackup

The server should be up and running.

