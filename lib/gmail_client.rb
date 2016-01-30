class GmailClient
  Gmail = Google::Apis::GmailV1

  def initialize
    #print "Email: "
    #@email = gets.chomp
    email = "caiden.robinson35@gmail.com"

    user_id = 'me'
    gmail = Gmail::GmailService.new

    load_client_info
    setup

    gmail.authorization = @flow.authorize

    gmail.list_user_messages user_id
    binding.pry
  end

  private

  def authorize
    k
  end

  def load_client_info
    @client_secrets = Google::APIClient::ClientSecrets.load 'config/client_secrets.json'
  end

  def setup
    @flow = Google::APIClient::InstalledAppFlow.new(
      client_id: @client_secrets.client_id,
      client_secret: @client_secrets.client_secret,
      scope: ['https://www.googleapis.com/auth/gmail.readonly']
    )
  end
end
