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
      #
      def pluck_attributes(*column_names)
        pluck_columns(column_names) do |attributes|
          attributes.each do |key, _|
            attributes[key] = klass.type_cast_attribute(key, attributes)
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

      def pluck_columns(columns)
        if columns.size.zero?
          raise ArgumentError, 'wrong number of arguments (0 for 1)', caller(1)
        end

        columns = columns.map do |column_name|
          if Symbol === column_name && column_names.include?(column_name.to_s)
            "#{connection.quote_table_name(table_name)}.#{connection.quote_column_name(column_name)}"
          else
            column_name.to_s
          end
        end

        relation = clone
        relation.select_values = columns
        klass.connection.select_all(relation.arel).map! do |attributes|
          yield klass.initialize_attributes(attributes)
        end
      end
    end
  end
end

class ActiveRecord::Relation
  include Pluckeroid::ActiveRecord::Relation
end
