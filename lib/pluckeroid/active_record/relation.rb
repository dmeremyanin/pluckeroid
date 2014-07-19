module Pluckeroid
  module ActiveRecord
    module Relation
      # Performs select by column names as direct SQL query.
      # Returns <tt>Array</tt> of hashes each element of which contains
      # specified column names as keys and the values of the column names as values.
      # The values has same data type as column.
      #
      # Examples:
      #
      #   Person.pluck(:id) # SELECT people.id FROM people
      #   # => [{ 'id' => 1 }, { 'id' => 2 }]
      #
      #   Person.pluck_attributes(:id, :name) # SELECT people.id, people.name FROM people
      #   # => [{ 'id' => 1, 'name' => 'Obi-Wan' }, { 'id' => 2, 'name' => 'Luke' }]
      #
      # You can also re-map/alias attributes:
      #
      #   Person.pluck(:id, :column_mappings => { 'id' => 'person_id' }) # SELECT people.id FROM people
      #   # => [{ 'person_id' => 1 }, { 'person_id' => 2 }]
      #
      #   Person.pluck_attributes(:id, :name, :column_mappings => { 'id' => 'person_id' }) # SELECT people.id, people.name FROM people
      #   # => [{ 'person_id' => 1, 'name' => 'Obi-Wan' }, { 'person_id' => 2, 'name' => 'Luke' }]
      #
      def pluck_attributes(*args)
        options, column_names = extract_options_and_column_names(args)
        column_mappings = extract_column_mappings(options)
        pluck_columns(column_names) do |attributes|
          HashWithIndifferentAccess.new.tap do |mapped_attributes|
            attributes.each do |key, _|
              mapped_attributes[column_mappings[key] || key] = \
                klass.type_cast_attribute(key, attributes)
            end
          end
        end
      end

      # Same as +pluck_attributes+ but returns <tt>Array</tt> with values
      # of the specified column names.
      #
      # Examples:
      #
      #   Person.pluck(:id) # SELECT people.id FROM people
      #   # => [1, 2]
      #
      #   Person.pluck(:id, :name) # SELECT people.id, people.name FROM people
      #   # => [[1, 'Obi-Wan'], [2, 'Luke']]
      #
      def pluck(*column_names)
        flatten = column_names.one?

        pluck_columns(column_names) do |attributes|
          values = attributes.map do |key, _|
            klass.type_cast_attribute(key, attributes)
          end

          if flatten
            values.first
          else
            values
          end
        end
      end
      alias :value_of  :pluck
      alias :values_of :pluck

      protected

      def pluck_columns(column_names)
        if column_names.size.zero?
          raise ArgumentError, 'wrong number of arguments (0 for 1)', caller(1)
        end

        column_names = column_names.map do |column_name|
          if Symbol === column_name && self.column_names.include?(column_name.to_s)
            "#{connection.quote_table_name(table_name)}.#{connection.quote_column_name(column_name)}"
          else
            column_name.to_s
          end
        end

        relation = clone
        relation.select_values = column_names
        klass.connection.select_all(relation.arel).map! do |attributes|
          yield klass.initialize_attributes(attributes)
        end
      end

      private

      def extract_options_and_column_names(args)
        [args.last.is_a?(Hash) ? args.pop : {}, args]
      end

      def extract_column_mappings(options)
        (options[:column_mappings] || {}).stringify_keys
      end
    end
  end
end

class ActiveRecord::Relation
  include Pluckeroid::ActiveRecord::Relation
end
