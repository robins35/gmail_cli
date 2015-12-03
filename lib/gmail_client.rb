class GmailClient
  def initialize
    #print "Email: "
    #email = gets.chomp

    response = get_oauth_token
    binding.pry
    #gmail = Gmail.new!(:xoauth2, email, "ya29.PgI4eSmbP-cj9r4_9Q3xb-pXkA7QHiWl-5oG5eOPv_8deAbuH7tCcQvq0IRR8JbAQo4h")
  end

  private

  def get_oauth_token
    gmail_credentials = YAML.load_file('config/gmail.yml')
    client_id = gmail_credentials["client_id"]
    client_secret = gmail_credentials["client_secret"]

    puts "Go to the following url to enable the gmail cli app:"
    puts "https://accounts.google.com/o/oauth2/auth?scope=email&redirect_uri=urn:ietf:wg:oauth:2.0:oob&response_type=code&client_id=#{client_id}"
    print "Paste your authorization code here: "
    authorization_code = gets.chomp
    #authorization_code = "4/yYZjdOeprKRIH3VwDfHs0-NsEvcstmvboM_c4Why0uk"

    uri = URI.parse("https://www.googleapis.com/oauth2/v3/token")
    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field('Content-Type', 'application/x-www-form-urlencoded')
    request.set_form_data('code' => authorization_code, 'client_id' => client_id, 'client_secret' => client_secret, 'redirect_url' => "urn:ietf:wg:oauth:2.0:oob", 'grant_type' => "authorization_code")

    http = Net::HTTP.new(uri.host, uri.port)
    http.set_debug_output($stdout)
    http.use_ssl = true

    #request.body = { code: authorization_code, client_id: client_id, client_secret: client_secret, redirect_url: "https://oauth2-login-demo.appspot.com/code&", grant_type: "authorization_code" }
    #post_data = URI.encode_www_form({ code: authorization_code, client_id: client_id, client_secret: client_secret, redirect_url: "https://oauth2-login-demo.appspot.com/code&", grant_type: "authorization_code" })


    response = http.request(request)
  end
end
