module IssueSearch
  extend ActiveSupport::Concern
  included do
    include ApplicationSearch

    def to_indexed_json
      IssueSerializer.new(self).to_json
    end

  end

  module ClassMethods

    def elastic(options = {})
      query_options = {}
      Tire.search(Issue.index_name, query_options) do
        query do
          string options[:q]
        end
      end
    end

    def index_settings
      {}
    end

    def index_mapping
      {
          issue: { properties: issue_mapping_hash }
      }
    end

    def issue_mapping_hash
      event_mapping_hash
    end

  end
end
