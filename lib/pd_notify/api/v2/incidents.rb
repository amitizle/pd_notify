
module PdNotify
  module API
    module V2
      module Incidents
        QUERY_MAPPING = {
          statuses: 'statuses[]',
          services: 'service_ids[]',
          teams: 'team_ids[]',
          users: 'user_ids[]',
          urgencies: 'urgencies[]',
        }
        def Incidents.list(http_client, opts = {})
          query_params = prepare_query_params(opts)
          http_client.get('/incidents', query_params: query_params)
        end

        def Incidents.prepare_query_params(opts)
          query_params = []
          opts.each do |k, v|
            if v.is_a?(Array)
              v.each do |v_item|
                if !v_item.empty?
                  query_params << [QUERY_MAPPING[k] || k.to_s, v_item]
                end
              end
            else
              query_params << [QUERY_MAPPING[k] || k.to_s, v]
            end
          end
          query_params
        end
      end
    end
  end
end
