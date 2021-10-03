class Category < ApplicationRecord
  has_and_belongs_to_many :products
  has_many :sub_categories, class_name: "Category", foreign_key: "category_id", dependent: :destroy
  belongs_to :main_category, class_name: "Category", foreign_key: "category_id", optional: true

  scope :categories_parents, -> { where(category_id: nil) }
  scope :subcategories, -> { where.not(category_id: nil) }


  def self.categories_sons
    @categories_parents = Category.categories_parents
    @categories_parents_ids = @categories_parents.pluck(:id)
    @subcategories = Category.subcategories
    @sons = Array.new

    @subcategories.each do |category|
      if category.category_id.in? @categories_parents_ids
        @sons << category
      end 
    end
    return @sons
  end

  def self.categories_grandsons
    @subcategories = Category.subcategories
    @sons = Category.categories_sons
    @sons_ids = @sons.pluck(:id)
    @grandsons = Array.new

    @subcategories.each do |category|
      if category.category_id.in? @sons_ids
        @grandsons << category
      end
    end
    return @grandsons
  end
end
