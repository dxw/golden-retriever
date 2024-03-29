# frozen_string_literal: true

module GoldenRetriever
  class SlackNotification
    def initialize(opportunity_count:, import_count:)
      @opportunity_count = opportunity_count
      @import_count = import_count
    end

    def send!
      HTTParty.post(ENV["SLACK_WEBHOOK_URL"], body: payload.to_json)
    end

    private

    def payload
      {
        text: message.split.join(" ")
      }
    end

    def message
      @import_count.positive? ? successful_import : no_imports
    end

    def successful_import
      "
        Woof woof! :dog: :wave: I've imported #{@import_count} #{pluralize(@import_count, "opportunity")}
        this morning! Check #{pluralize(@import_count, "it", "them")} out here: #{search_url}
      "
    end

    def no_imports
      "Woof woof! :dog: No new opportunities on the marketplace today"
    end

    def search_url
      "https://app.hubspot.com/contacts/#{ENV["HUBSPOT_PORTAL_ID"]}/deals/list/view/#{ENV["HUBSPOT_LIST_ID"]}/?"
    end

    def pluralize(count, name, pluralized_version = nil)
      pluralized_version ||= name.pluralize
      (count == 1) ? name : pluralized_version
    end
  end
end
