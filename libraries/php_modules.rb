module Ingenerator
  module Php
    module PhpModules

      class Php5PackageReferenceError < ArgumentError
        def initialize(invalid_packages)
          msg = "Your node['php']['module_packages'] attribute defines invalid php5 package "
          msg += invalid_packages.join(', ')
          super msg
        end
      end


      def self.module_packages_to_install(node)
        all_packages = node['php']['module_packages']

        invalid = all_packages.keys.select { | name | is_php5(name) }
        raise Php5PackageReferenceError.new(invalid) if invalid.any?

        all_packages
          .select { | name, do_install | do_install }
          .keys
      end

      private

      def self.is_php5(package)
        /php5/.match(package) || (package === 'php-apc')
      end

    end
  end
end
