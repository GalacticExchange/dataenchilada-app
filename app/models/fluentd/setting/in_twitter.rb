class Fluentd
  module Setting
    class InTwitter < Source
      # include ActiveModel::Model
      include Common

      relate_to_details

      KEYS = [
          :consumer_key,
          :consumer_secret,
          :access_token,
          :access_token_secret,
          :timeline,
          :keyword,
          :follow_ids,
          :locations,
          :lang,
          :output_format
      ].freeze
      #
      # attr_accessor(*KEYS)
      #

      def self.default_tag
        'twitter_nasa'
      end

      def self.initial_params
        {
            timeline: 'tracking',
            keyword: 'nasa',
            follow_ids: '',
            locations: '',
            lang: :en,
            output_format: 'simple',
            consumer_key: 'a530R2VCibX8qDE1e19EIvm18',
            consumer_secret: '9QmK9w3ZaAEJGJxmrYd0dE5EhxFdTHTsr57WXHetE21M0VzPv8',
            access_token: '454451418-hGagC8lLAwVPfXOLtfNlrPgUnMGuMD7JYvNdyluH',
            access_token_secret: 'fqReoxNwIZwCi5v9nd0lOszWssDCHMnO0mpdpTUphh4DH'
        }
      end

      def fields_descriptions
        {
            consumer_key: '* YOUR_CONSUMER_KEY (required)',
            consumer_secret: '* YOUR_CONSUMER_SECRET (required)',
            access_token: '* YOUR_CONSUMER_SECRET (required)',
            access_token_secret: '* YOUR_CONSUMER_SECRET (required)',
            # tag: '* for example input.twitter.sampling (required)',
            timeline: '* tracking or sampling or location or userstream (required)',
            keyword: 'keyword has priority than follow_ids (optional)',
            follow_ids: '"14252,53235" - integers, not screen names (optional)',
            locations: '"31.110283, 129.431631, 45.619283, 145.510175" - bounding boxes; first pair specifies longitude/latitude of southwest corner (optional)',
            lang: 'ja,en (optional)',
            output_format: 'nest or flat or simple[default] (optional)'
        }
      end

      def common_options
        [
            :consumer_key, :consumer_secret, :access_token, :access_token_secret, :keyword
        ]
      end

      def advanced_options
        [
            :timeline, :follow_ids, :locations, :lang, :output_format
        ]
      end

      def plugin_name
        "twitter"
      end
    end
  end
end