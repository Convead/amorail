module Amorail
  # AmoCRM lead entity
  class Lead < Amorail::Entity
    amo_names "leads"

    amo_field :name, :price, :status_id, :tags, :pipeline_id

    validates :name, :status_id, presence: true
  end
end
