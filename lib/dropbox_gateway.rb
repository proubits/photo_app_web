# This references the Dropbox SDK gem install with "gem install dropbox-sdk"
require 'dropbox_sdk'

module DropboxGateway

  # Get your app key and secret from the Dropbox developer website
  APP_KEY = ENV['DROPBOX_APP_KEY']
  APP_SECRET = ENV['DROPBOX_APP_SECRET']
  REQ_TOKEN_KEY = ENV['DROPBOX_REQ_TOKEN_KEY']
  REQ_TOKEN_SECRET = ENV['DROPBOX_REQ_TOKEN_SECRET']

  # ACCESS_TYPE should be ':dropbox' or ':app_folder' as configured for your app
  ACCESS_TYPE = :app_folder

  def upload2db(file_obj, path, options={})
    session = DropboxSession.new(APP_KEY, APP_SECRET)
    #session.set_access_token(options[:t_key], options[:t_secret])
    session.set_access_token(REQ_TOKEN_KEY, REQ_TOKEN_SECRET)
    client = DropboxClient.new(session, ACCESS_TYPE)
    #puts "linked account:", client.account_info().inspect

    response = client.put_file(path, file_obj)
    #puts "uploaded:", response.inspect
    return response.to_hash[:path]
  end

  def download(path)
    puts path
    session = DropboxSession.new(APP_KEY, APP_SECRET)
    session.set_access_token(REQ_TOKEN_KEY, REQ_TOKEN_SECRET)
    client = DropboxClient.new(session, ACCESS_TYPE)
    contents = client.get_file(path)
    #contents, metadata = client.get_file_and_metadata(path)
    #puts metadata
    return contents
  end
end

