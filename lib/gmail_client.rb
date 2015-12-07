class GmailClient
  def initialize
    #print "Email: "
    #@email = gets.chomp

    load_client_info
    @email = "caiden.robinson35@gmail.com"
    load_and_set_oauth2_tokens

    sign_in_gmail
    binding.pry
  end

  private

  def sign_in_gmail
    #begin
      @gmail = Gmail.connect(:xoauth2, @email, @client.access_token)
      @gmail.login true
      binding.pry
    #rescue Exception => e
    #  if @authorization_code[:is_cached]
    #    load_and_set_oauth2_tokens(false)
    #    @gmail = Gmail.connect(:xoauth2, @email, @client.access_token)
    #    @gmail.login true
    #    binding.pry
    #  else
    #    puts e
    #  end
    #end
  end

  def load_client_info
    gmail_credentials = YAML.load_file('config/gmail.yml')
    @client_id = gmail_credentials["client_id"]
    @client_secret = gmail_credentials["client_secret"]
    @redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'
  end

  def load_and_set_oauth2_tokens use_cached_tokens = true
    if use_cached_tokens && File.exist?("config/tokens.yml")
      token_hash = YAML.load_file('config/tokens.yml')
      @authorization_code = { code: token_hash["authorization_code"],
                              is_cached: true }
      @client = signet_client(token_hash)
      @token_hash = @client.refresh!
    else
      if !(instance_variable_defined?("@authorization_code") && @authorization_code[:is_cached] == false)
        retrieve_and_set_authorization_code
      end
      @token_hash = set_client_and_retrieve_oauth2_tokens
    end
    write_tokens_to_file
  end

  def retrieve_and_set_authorization_code
      puts "Go to the following url to enable the gmail cli app:"
      puts "https://accounts.google.com/o/oauth2/auth?scope=email&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=#{@client_id}"
      print "Paste your authorization code here: "
      @authorization_code = { code: gets.chomp,
                              is_cached: false }
  end

  def set_client_and_retrieve_oauth2_tokens
    @client = signet_client
    @client.fetch_access_token!
  end

  def signet_client token_hash = nil
    client = Signet::OAuth2::Client.new(
      client_id: @client_id,
      client_secret: @client_secret,
      redirect_uri: @redirect_uri,
      scope: 'email',
      token_credential_uri: 'https://www.googleapis.com/oauth2/v4/token'
    )
    if token_hash.present?
      client.refresh_token = token_hash["refresh_token"]
    else
      client.authorization_uri = 'https://accounts.google.com/o/oauth2/auth'
      client.code = @authorization_code[:code]
    end
    client
  end

  def write_tokens_to_file
    if File.exist?("config/tokens.yml")
      data = YAML.load_file "config/tokens.yml"
      @token_hash.each { |k, v| data[k] = v }
      File.open('config/tokens.yml', 'w') do |file|
        YAML.dump(data, file)
      end
    else
      File.open('config/tokens.yml', 'w') do |file|
        @token_hash.each { |k, v| file.write("#{k}: #{v}\n") }
        file.write("authorization_code: #{@authorization_code[:code]}\n")
      end
    end
  end
end
