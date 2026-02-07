require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # Minimalne ustawienia do deploya na HF Space

  # Eager load, ale bez komplikacji z cache/queue
  config.eager_load = true

  # Logi do STDOUT
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')

  # Active Storage na lokalny dysk
  config.active_storage.service = :local

  # Host z HF Space
  config.hosts.clear
  config.hosts << 'kantown-anituqe-analyzer.hf.space'

  # I18n fallback
  config.i18n.fallbacks = true

  # Nie dumpujemy schematu
  config.active_record.dump_schema_after_migration = false
end
