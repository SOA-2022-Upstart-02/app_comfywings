# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    ComfyWings::App.DB.run('PRAGMA foreign_keys = OFF')
    # ComfyWings::Database::TripQueryOrm.map(&:destroy)
    # ComfyWings::Database::CurrencyOrm.map(&:destroy)
    ComfyWings::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
