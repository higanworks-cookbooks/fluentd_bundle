module FluentdBundle
  module DependsHelper
    def self.has_depends?(node)
      my_recipes = node.run_context.cookbook_collection['fluentd_bundle'].recipe_filenames_by_name
      my_recipes.has_key?("depends_#{node[:platform]}")
    end
  end
end
