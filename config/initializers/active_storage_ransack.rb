# Ransack configuration for Active Storage models (required for Active Admin)

Rails.application.config.to_prepare do
  ActiveStorage::Attachment.class_eval do
    def self.ransackable_attributes(auth_object = nil)
      [ "id", "name", "record_id", "record_type", "blob_id", "created_at" ]
    end

    def self.ransackable_associations(auth_object = nil)
      [ "blob", "record" ]
    end
  end

  ActiveStorage::Blob.class_eval do
    def self.ransackable_attributes(auth_object = nil)
      [ "id", "key", "filename", "content_type", "byte_size", "checksum", "created_at" ]
    end

    def self.ransackable_associations(auth_object = nil)
      [ "attachments" ]
    end
  end
end
