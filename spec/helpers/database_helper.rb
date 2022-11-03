# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    ComfyWings::App.DB.run('PRAGMA foreign_keys = OFF')
    # TODO: add ComfyWings::Database::Ormname.map(&:destroy)
    ComfyWings::App.DB.run('PRAGMA foreign_keys = ON')
  end
end
