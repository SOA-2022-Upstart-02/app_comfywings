# frozen_string_literal: true

require 'dry/monads'

module ComfyWings
  module Service
    # Retrieves array of all listed project entities
    class Add
      include Dry::Monads::Result::Mixin

      def call(projects_list)
        projects = Repository::For.klass(Entity::Project)
          .find_full_names(projects_list)

        Success(projects)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end
