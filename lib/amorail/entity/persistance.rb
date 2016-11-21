module Amorail # :nodoc: all
  class Entity
    class InvalidRecord < ::Amorail::Error; end
    class NotPersisted < ::Amorail::Error; end

    def new_record?
      id.blank?
    end

    def persisted?
      !new_record?
    end

    def save
      return false unless valid?
      if new_record?
        push('add')
      else
        self.last_modified = Time.now.to_i + 20
        push('update')
      end
    end

    def save!
      if save
        true
      else
        fail InvalidRecord
      end
    end

    def update(attrs = {})
      return false if new_record?
      last_modified = Time.now.to_i + 20
      attrs = attrs.dup.with_indifferent_access.merge({last_modified: last_modified})
      merge_params(attrs)
      push('update')
    end

    def update!(attrs = {})
      if update(attrs)
        true
      else
        fail NotPersisted
      end
    end

    def reload
      fail NotPersisted if id.nil?
      load_record(id)
    end

    private

    def extract_data_add(response)
      response.fetch('add').first
    end
  end
end
