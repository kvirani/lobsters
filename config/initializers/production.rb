# This template for a production-only config file of API tokens was taken and
# cleaned up from Lobsters.
#
# Copy this to config/initializers/production.rb and customize, it's already
# listed in .gitignore to help prevent you from accidentally committing it.
#
# This predates Rails' config/secrets.yml feature and we could probably shift
# to using that at some point.

if Rails.env.production?
  Lobsters::Application.config.middleware.use ExceptionNotification::Rack,
    :ignore_exceptions => [
      "ActionController::UnknownFormat",
      "ActionController::BadRequest",
      "ActionDispatch::RemoteIp::IpSpoofAttackError",
    ] + ExceptionNotifier.ignored_exceptions,
    :email => {
      :email_prefix => "[Labsters] ",                    # fill in site name
      :sender_address => %{"Exception Notifier" <khurram@lighthouselabs.ca>}, # fill in from address
      :exception_recipients => %w{kvirani@lighthouselabs.ca},                 # fill in destination addresses
    }

  Pushover.API_TOKEN = ENV['PUSHOVER_API_TOKEN']
  Pushover.SUBSCRIPTION_CODE = ENV['PUSHOVER_SUBSCRIPTION_CODE']

  StoryCacher.DIFFBOT_API_KEY = ENV['DIFFBOT_API_KEY']

  Twitter.CONSUMER_KEY = ENV['TWITTER_CONSUMER_KEY']
  Twitter.CONSUMER_SECRET = ENV['TWITTER_CONSUMER_SECRET']
  Twitter.AUTH_TOKEN = ENV['TWITTER_AUTH_TOKEN']
  Twitter.AUTH_SECRET = ENV['TWITTER_AUTH_SECRET']

  Github.CLIENT_ID = ENV['GITHUB_CLIENT_ID']
  Github.CLIENT_SECRET = ENV['GITHUB_CLIENT_SECRET']

  BCrypt::Engine.cost = 12

  Keybase.DOMAIN = Rails.application.domain
  Keybase.BASE_URL = ENV.fetch('KEYBASE_BASE_URL') { 'https://keybase.io' }

  ActionMailer::Base.delivery_method = :sendmail

  class << Rails.application
    def allow_invitation_requests?
      ENV['ALLOW_INVITATION_REQUESTS'] == 'true'
    end

    def allow_new_users_to_invite?
      ENV['ALLOW_NEW_USERS_TO_INVITE'] == 'true'
    end

    def domain
      ENV['HOST']
    end

    def name
      ENV['SITE_NAME']'
    end

    def ssl?
      true
    end
  end
end
